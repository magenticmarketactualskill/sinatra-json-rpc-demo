require 'sinatra'
require 'json'
require 'logger'
require_relative 'json_rpc_processor'
require_relative 'rpc_methods'

class ServerApp < Sinatra::Base
  configure do
    set :port, 4567
    set :bind, '0.0.0.0'
    
    # Set up logging
    log_file = File.new("#{settings.root}/server.log", "a+")
    log_file.sync = true
    use Rack::CommonLogger, log_file
    
    set :logger, Logger.new(log_file)
    settings.logger.level = Logger::INFO
  end

  before do
    content_type :json
    
    # Log incoming requests
    if request.post? && request.path_info == '/jsonrpc'
      request.body.rewind
      body = request.body.read
      request.body.rewind
      
      settings.logger.info "Incoming JSON-RPC request: #{body}"
    end
  end

  # Initialize RPC processor
  rpc_methods = RpcMethods.new
  processor = JsonRpcProcessor.new(rpc_methods)

  # JSON-RPC endpoint
  post '/jsonrpc' do
    begin
      request.body.rewind
      request_body = request.body.read
      
      # Process the JSON-RPC request
      response = processor.process_request(request_body)
      
      # Log outgoing response
      response_json = JSON.generate(response)
      settings.logger.info "Outgoing JSON-RPC response: #{response_json}"
      
      response_json
    rescue StandardError => e
      error_response = {
        'jsonrpc' => '2.0',
        'error' => {
          'code' => -32603,
          'message' => 'Internal error',
          'data' => e.message
        },
        'id' => nil
      }
      
      error_json = JSON.generate(error_response)
      settings.logger.error "Server error: #{e.message}"
      settings.logger.error "Backtrace: #{e.backtrace.join("\n")}"
      settings.logger.info "Error response: #{error_json}"
      
      error_json
    end
  end

  # Health check endpoint
  get '/health' do
    {
      'status' => 'ok',
      'timestamp' => Time.now.iso8601,
      'available_methods' => [
        'add', 'multiply', 'divide',
        'reverse_string', 'uppercase', 'word_count',
        'store_data', 'retrieve_data', 'list_keys'
      ]
    }.to_json
  end

  # Root endpoint with basic info
  get '/' do
    content_type :html
    <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>JSON-RPC Server</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; }
          .method { background: #f5f5f5; padding: 10px; margin: 10px 0; border-radius: 5px; }
          .endpoint { background: #e8f4fd; padding: 15px; border-radius: 5px; margin: 20px 0; }
        </style>
      </head>
      <body>
        <h1>JSON-RPC 2.0 Server</h1>
        <p>This server implements JSON-RPC 2.0 protocol and provides various RPC methods.</p>
        
        <div class="endpoint">
          <h3>JSON-RPC Endpoint</h3>
          <p><strong>POST /jsonrpc</strong></p>
          <p>Send JSON-RPC 2.0 requests to this endpoint.</p>
        </div>

        <h2>Available Methods</h2>
        
        <h3>Calculator Methods</h3>
        <div class="method">
          <strong>add(a, b)</strong> - Returns sum of two numbers
        </div>
        <div class="method">
          <strong>multiply(a, b)</strong> - Returns product of two numbers
        </div>
        <div class="method">
          <strong>divide(a, b)</strong> - Returns division result
        </div>

        <h3>String Methods</h3>
        <div class="method">
          <strong>reverse_string(text)</strong> - Returns reversed string
        </div>
        <div class="method">
          <strong>uppercase(text)</strong> - Returns uppercased string
        </div>
        <div class="method">
          <strong>word_count(text)</strong> - Returns word count
        </div>

        <h3>Storage Methods</h3>
        <div class="method">
          <strong>store_data(key, value)</strong> - Stores key-value pair
        </div>
        <div class="method">
          <strong>retrieve_data(key)</strong> - Retrieves stored value
        </div>
        <div class="method">
          <strong>list_keys()</strong> - Returns all stored keys
        </div>

        <h2>Example Request</h2>
        <pre>{
  "jsonrpc": "2.0",
  "method": "add",
  "params": [5, 3],
  "id": 1
}</pre>

        <p><a href="/health">Health Check</a></p>
      </body>
      </html>
    HTML
  end

  run! if app_file == $0
end