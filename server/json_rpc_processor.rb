require 'json'

class JsonRpcProcessor
  # JSON-RPC 2.0 Error Codes
  PARSE_ERROR = -32700
  INVALID_REQUEST = -32600
  METHOD_NOT_FOUND = -32601
  INVALID_PARAMS = -32602
  INTERNAL_ERROR = -32603

  def initialize(rpc_methods)
    @rpc_methods = rpc_methods
  end

  def process_request(request_body)
    begin
      # Parse JSON
      request = JSON.parse(request_body)
    rescue JSON::ParserError => e
      return create_error_response(nil, PARSE_ERROR, "Parse error", "Invalid JSON: #{e.message}")
    end

    # Validate JSON-RPC 2.0 format
    validation_error = validate_request(request)
    return validation_error if validation_error

    # Extract request components
    method_name = request['method']
    params = request['params']
    id = request['id']

    # Check if method exists
    unless @rpc_methods.respond_to?(method_name)
      return create_error_response(id, METHOD_NOT_FOUND, "Method not found", "The method '#{method_name}' does not exist")
    end

    begin
      # Call the method with parameters
      result = call_method(method_name, params)
      create_success_response(id, result)
    rescue ArgumentError => e
      create_error_response(id, INVALID_PARAMS, "Invalid params", e.message)
    rescue StandardError => e
      create_error_response(id, INTERNAL_ERROR, "Internal error", e.message)
    end
  end

  private

  def validate_request(request)
    # Must be a hash/object
    unless request.is_a?(Hash)
      return create_error_response(nil, INVALID_REQUEST, "Invalid Request", "Request must be a JSON object")
    end

    # Must have jsonrpc field with value "2.0"
    unless request['jsonrpc'] == '2.0'
      return create_error_response(request['id'], INVALID_REQUEST, "Invalid Request", "Missing or invalid 'jsonrpc' field")
    end

    # Must have method field
    unless request.key?('method') && request['method'].is_a?(String)
      return create_error_response(request['id'], INVALID_REQUEST, "Invalid Request", "Missing or invalid 'method' field")
    end

    # Must have id field (can be null, string, or number)
    unless request.key?('id')
      return create_error_response(nil, INVALID_REQUEST, "Invalid Request", "Missing 'id' field")
    end

    # params field is optional, but if present must be Array or Hash
    if request.key?('params') && !request['params'].is_a?(Array) && !request['params'].is_a?(Hash)
      return create_error_response(request['id'], INVALID_REQUEST, "Invalid Request", "Invalid 'params' field - must be Array or Object")
    end

    nil # No validation errors
  end

  def call_method(method_name, params)
    method = @rpc_methods.method(method_name)
    
    if params.nil?
      # No parameters
      method.call
    elsif params.is_a?(Array)
      # Positional parameters
      method.call(*params)
    elsif params.is_a?(Hash)
      # Named parameters
      method.call(**params.transform_keys(&:to_sym))
    else
      raise ArgumentError, "Invalid parameter format"
    end
  end

  def create_success_response(id, result)
    {
      'jsonrpc' => '2.0',
      'result' => result,
      'id' => id
    }
  end

  def create_error_response(id, code, message, data = nil)
    error = {
      'code' => code,
      'message' => message
    }
    error['data'] = data if data

    {
      'jsonrpc' => '2.0',
      'error' => error,
      'id' => id
    }
  end
end