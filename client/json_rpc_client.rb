require 'net/http'
require 'json'
require 'uri'

class JsonRpcClient
  def initialize(server_url = 'http://localhost:4567/jsonrpc')
    @server_url = server_url
    @uri = URI.parse(@server_url)
    @request_id = 0
  end

  def call_method(method_name, params = nil)
    @request_id += 1
    
    request_data = {
      'jsonrpc' => '2.0',
      'method' => method_name,
      'id' => @request_id
    }
    
    request_data['params'] = params if params
    
    begin
      response = send_request(request_data)
      parse_response(response)
    rescue StandardError => e
      {
        'success' => false,
        'error' => {
          'type' => 'network_error',
          'message' => "Failed to connect to server: #{e.message}"
        }
      }
    end
  end

  # Calculator method helpers
  def add(a, b)
    call_method('add', [a, b])
  end

  def multiply(a, b)
    call_method('multiply', [a, b])
  end

  def divide(a, b)
    call_method('divide', [a, b])
  end

  # String method helpers
  def reverse_string(text)
    call_method('reverse_string', [text])
  end

  def uppercase(text)
    call_method('uppercase', [text])
  end

  def word_count(text)
    call_method('word_count', [text])
  end

  # Storage method helpers
  def store_data(key, value)
    call_method('store_data', [key, value])
  end

  def retrieve_data(key)
    call_method('retrieve_data', [key])
  end

  def list_keys
    call_method('list_keys')
  end

  def format_result_for_display(result)
    if result['success'] == false
      if result['error']['type'] == 'network_error'
        "❌ Network Error: #{result['error']['message']}"
      else
        "❌ JSON-RPC Error (#{result['error']['code']}): #{result['error']['message']}"
      end
    else
      case result['result']
      when Hash
        if result['result']['success'] == false
          "⚠️  #{result['result']['message']}"
        else
          format_hash_result(result['result'])
        end
      when Array
        "📋 #{result['result'].inspect}"
      when String
        "📝 \"#{result['result']}\""
      when Numeric
        "🔢 #{result['result']}"
      else
        "✅ #{result['result'].inspect}"
      end
    end
  end

  private

  def send_request(request_data)
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = @uri.scheme == 'https'
    http.read_timeout = 10
    http.open_timeout = 5

    request = Net::HTTP::Post.new(@uri.path)
    request['Content-Type'] = 'application/json'
    request.body = JSON.generate(request_data)

    response = http.request(request)
    
    unless response.code == '200'
      raise "HTTP Error: #{response.code} #{response.message}"
    end
    
    response.body
  end

  def parse_response(response_body)
    begin
      response = JSON.parse(response_body)
    rescue JSON::ParserError => e
      return {
        'success' => false,
        'error' => {
          'type' => 'parse_error',
          'message' => "Invalid JSON response: #{e.message}"
        }
      }
    end

    # Check for JSON-RPC error
    if response.key?('error')
      {
        'success' => false,
        'error' => {
          'type' => 'jsonrpc_error',
          'code' => response['error']['code'],
          'message' => response['error']['message'],
          'data' => response['error']['data']
        }
      }
    else
      {
        'success' => true,
        'result' => response['result'],
        'id' => response['id']
      }
    end
  end

  def format_hash_result(hash)
    if hash.key?('keys') && hash.key?('count')
      # list_keys result
      if hash['count'] == 0
        "📂 No keys stored"
      else
        "📂 #{hash['count']} keys: #{hash['keys'].join(', ')}"
      end
    elsif hash.key?('key') && hash.key?('value')
      # retrieve_data result
      "🔍 #{hash['key']} = #{hash['value'].inspect}"
    elsif hash.key?('success') && hash.key?('key')
      # store_data result
      "💾 Stored: #{hash['key']}"
    else
      "📊 #{hash.inspect}"
    end
  end
end