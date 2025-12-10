class RpcMethods
  def initialize
    @storage = {}
  end

  # Calculator Methods
  def add(a, b)
    validate_numeric_params(a, b)
    a + b
  end

  def multiply(a, b)
    validate_numeric_params(a, b)
    a * b
  end

  def divide(a, b)
    validate_numeric_params(a, b)
    
    if b == 0
      raise ArgumentError, "Division by zero is not allowed"
    end
    
    a.to_f / b.to_f
  end

  # String Methods
  def reverse_string(text)
    validate_string_param(text)
    text.reverse
  end

  def uppercase(text)
    validate_string_param(text)
    text.upcase
  end

  def word_count(text)
    validate_string_param(text)
    return 0 if text.strip.empty?
    text.strip.split(/\s+/).length
  end

  # Storage Methods
  def store_data(key, value)
    validate_string_param(key, "key")
    
    if key.strip.empty?
      raise ArgumentError, "Key cannot be empty"
    end
    
    @storage[key] = value
    {
      'success' => true,
      'message' => "Data stored successfully",
      'key' => key
    }
  end

  def retrieve_data(key)
    validate_string_param(key, "key")
    
    if @storage.key?(key)
      {
        'success' => true,
        'key' => key,
        'value' => @storage[key]
      }
    else
      {
        'success' => false,
        'message' => "Key '#{key}' not found"
      }
    end
  end

  def list_keys
    {
      'keys' => @storage.keys,
      'count' => @storage.keys.length
    }
  end

  private

  def validate_numeric_params(*params)
    params.each_with_index do |param, index|
      unless param.is_a?(Numeric)
        raise ArgumentError, "Parameter #{index + 1} must be a number, got #{param.class}"
      end
    end
  end

  def validate_string_param(param, param_name = "text")
    unless param.is_a?(String)
      raise ArgumentError, "Parameter '#{param_name}' must be a string, got #{param.class}"
    end
  end
end