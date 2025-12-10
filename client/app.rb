require 'sinatra'
require 'json'
require_relative 'json_rpc_client'

class ClientApp < Sinatra::Base
  configure do
    set :port, 4568
    set :bind, '0.0.0.0'
    set :views, File.join(settings.root, 'views')
    set :public_folder, File.join(settings.root, 'public')
  end

  # Initialize JSON-RPC client
  rpc_client = JsonRpcClient.new

  # Home page
  get '/' do
    erb :index
  end

  # Calculator methods
  get '/calculator' do
    erb :calculator
  end

  post '/calculator/:operation' do
    operation = params[:operation]
    a = params[:a].to_f
    b = params[:b].to_f

    result = case operation
             when 'add'
               rpc_client.add(a, b)
             when 'multiply'
               rpc_client.multiply(a, b)
             when 'divide'
               rpc_client.divide(a, b)
             else
               { 'success' => false, 'error' => { 'message' => 'Unknown operation' } }
             end

    @operation = operation
    @a = a
    @b = b
    @result = result
    @formatted_result = rpc_client.format_result_for_display(result)

    erb :calculator_result
  end

  # String methods
  get '/strings' do
    erb :strings
  end

  post '/strings/:operation' do
    operation = params[:operation]
    text = params[:text]

    result = case operation
             when 'reverse'
               rpc_client.reverse_string(text)
             when 'uppercase'
               rpc_client.uppercase(text)
             when 'word_count'
               rpc_client.word_count(text)
             else
               { 'success' => false, 'error' => { 'message' => 'Unknown operation' } }
             end

    @operation = operation
    @text = text
    @result = result
    @formatted_result = rpc_client.format_result_for_display(result)

    erb :strings_result
  end

  # Storage methods
  get '/storage' do
    erb :storage
  end

  post '/storage/store' do
    key = params[:key]
    value = params[:value]

    result = rpc_client.store_data(key, value)

    @operation = 'store'
    @key = key
    @value = value
    @result = result
    @formatted_result = rpc_client.format_result_for_display(result)

    erb :storage_result
  end

  post '/storage/retrieve' do
    key = params[:key]

    result = rpc_client.retrieve_data(key)

    @operation = 'retrieve'
    @key = key
    @result = result
    @formatted_result = rpc_client.format_result_for_display(result)

    erb :storage_result
  end

  post '/storage/list' do
    result = rpc_client.list_keys

    @operation = 'list'
    @result = result
    @formatted_result = rpc_client.format_result_for_display(result)

    erb :storage_result
  end

  # API endpoint for raw JSON-RPC calls
  post '/api/call' do
    content_type :json
    
    begin
      request.body.rewind
      request_data = JSON.parse(request.body.read)
      
      method_name = request_data['method']
      params = request_data['params']
      
      result = rpc_client.call_method(method_name, params)
      result.to_json
    rescue JSON::ParserError => e
      {
        'success' => false,
        'error' => {
          'type' => 'parse_error',
          'message' => "Invalid JSON: #{e.message}"
        }
      }.to_json
    rescue StandardError => e
      {
        'success' => false,
        'error' => {
          'type' => 'client_error',
          'message' => e.message
        }
      }.to_json
    end
  end

  run! if app_file == $0
end