# Sinatra JSON-RPC Demo

A comprehensive demonstration of JSON-RPC 2.0 communication between two Sinatra applications, showcasing proper protocol implementation, error handling, and various parameter types.

## Overview

This demo consists of two separate Sinatra applications that communicate via JSON-RPC 2.0 protocol:

- **Server** (port 4567): Handles JSON-RPC requests and provides RPC method implementations
- **Client** (port 4568): Provides a web interface for making JSON-RPC calls to the server

## Features

### Server RPC Methods

The server implements three categories of RPC methods to demonstrate different parameter types and use cases:

#### 1. Calculator Methods
- `add(a, b)` - Returns sum of two numbers
- `multiply(a, b)` - Returns product of two numbers  
- `divide(a, b)` - Returns division result with zero-division error handling

#### 2. String Methods
- `reverse_string(text)` - Returns reversed string
- `uppercase(text)` - Returns uppercased string
- `word_count(text)` - Returns word count (handles empty strings)

#### 3. Storage Methods
- `store_data(key, value)` - Stores key-value pair in memory
- `retrieve_data(key)` - Retrieves stored value by key
- `list_keys()` - Returns all stored keys with count

### JSON-RPC 2.0 Compliance

This implementation fully complies with JSON-RPC 2.0 specification:

- ✅ Proper request/response format with required fields
- ✅ Standard error codes (-32700 to -32603)
- ✅ Support for both named and positional parameters
- ✅ Comprehensive error handling and validation
- ✅ Request/response logging with timestamps

## Quick Start

### Prerequisites

- Ruby 3.0 or higher
- Bundler gem (`gem install bundler`)

### Installation

1. **Clone or navigate to the demo directory:**
   ```bash
   cd submodules/examples/sinatra-json-rpc-demo
   ```

2. **Install server dependencies:**
   ```bash
   cd server
   bundle install
   ```

3. **Install client dependencies:**
   ```bash
   cd ../client
   bundle install
   ```

### Running the Demo

1. **Start the JSON-RPC Server:**
   ```bash
   cd server
   bundle exec ruby app.rb
   ```
   Server will start on http://localhost:4567

2. **Start the Client (in a new terminal):**
   ```bash
   cd client
   bundle exec ruby app.rb
   ```
   Client will start on http://localhost:4568

3. **Use the Demo:**
   - Open your browser to http://localhost:4568
   - Navigate through Calculator, String Operations, and Data Storage sections
   - Submit forms to see JSON-RPC calls in action
   - View formatted results and raw JSON responses

## Usage Examples

### Web Interface

The client provides an intuitive web interface with forms for each RPC method category. Each form submission generates a JSON-RPC request and displays both formatted results and raw JSON responses.

### Direct JSON-RPC Calls

You can also make direct JSON-RPC calls to the server:

```bash
# Calculator example
curl -X POST http://localhost:4567/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "add",
    "params": [5, 3],
    "id": 1
  }'

# String example with named parameters
curl -X POST http://localhost:4567/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "reverse_string",
    "params": {"text": "Hello World"},
    "id": 2
  }'

# Storage example
curl -X POST http://localhost:4567/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "store_data",
    "params": ["user1", {"name": "John", "age": 30}],
    "id": 3
  }'
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Sinatra JSON-RPC Demo                      │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    HTTP/JSON-RPC    ┌─────────────┐│
│  │   Client App    │◄──────────────────►│ Server App  ││
│  │   (Port 4568)   │                     │(Port 4567)  ││
│  │                 │                     │             ││
│  │ ┌─────────────┐ │                     │┌───────────┐││
│  │ │Web Interface│ │                     ││JSON-RPC   │││
│  │ │   Forms     │ │                     ││Processor  │││
│  │ └─────────────┘ │                     │└───────────┘││
│  │ ┌─────────────┐ │                     │┌───────────┐││
│  │ │JSON-RPC     │ │                     ││RPC Methods│││
│  │ │Client       │ │                     ││- calc     │││
│  │ │             │ │                     ││- string   │││
│  │ └─────────────┘ │                     ││- storage  │││
│  └─────────────────┘                     │└───────────┘││
│                                          └─────────────┘│
├─────────────────────────────────────────────────────────┤
│                   Technology Stack                       │
│  • Ruby + Sinatra                                       │
│  • JSON-RPC 2.0 Protocol                               │
│  • Net::HTTP for client requests                        │
│  • JSON parsing/generation                              │
│  • ERB templates for web interface                      │
└─────────────────────────────────────────────────────────┘
```

### Key Components

#### Server Components
- **JsonRpcProcessor**: Handles JSON-RPC 2.0 protocol compliance, request parsing, and response generation
- **RpcMethods**: Contains all available RPC method implementations with parameter validation
- **ServerApp**: Main Sinatra application with logging and error handling

#### Client Components  
- **JsonRpcClient**: Handles JSON-RPC request generation, HTTP communication, and response parsing
- **ClientApp**: Main Sinatra application providing web interface
- **ERB Templates**: User-friendly forms and result display pages

## Development

### Project Structure

```
sinatra-json-rpc-demo/
├── README.md
├── server/
│   ├── Gemfile
│   ├── app.rb                 # Main server application
│   ├── json_rpc_processor.rb  # JSON-RPC protocol handler
│   ├── rpc_methods.rb         # RPC method implementations
│   └── server.log             # Request/response logs
├── client/
│   ├── Gemfile
│   ├── app.rb                 # Main client application
│   ├── json_rpc_client.rb     # JSON-RPC client class
│   ├── views/                 # ERB templates
│   │   ├── layout.erb
│   │   ├── index.erb
│   │   ├── calculator.erb
│   │   ├── calculator_result.erb
│   │   ├── strings.erb
│   │   ├── strings_result.erb
│   │   ├── storage.erb
│   │   └── storage_result.erb
│   └── public/
│       └── style.css          # CSS styling
```

### Running Tests

```bash
# Run server tests
cd server
bundle exec rspec

# Run client tests  
cd client
bundle exec rspec

# Run all tests
cd server && bundle exec rspec && cd ../client && bundle exec rspec
```

### Adding New RPC Methods

1. **Add method to RpcMethods class** (`server/rpc_methods.rb`):
   ```ruby
   def my_new_method(param1, param2)
     # Validate parameters
     # Implement logic
     # Return result
   end
   ```

2. **Add client helper method** (`client/json_rpc_client.rb`):
   ```ruby
   def my_new_method(param1, param2)
     call_method('my_new_method', [param1, param2])
   end
   ```

3. **Add web interface** (client views and routes)

## Error Handling

The demo implements comprehensive error handling:

### JSON-RPC Error Codes
- `-32700` Parse error: Invalid JSON received
- `-32600` Invalid Request: Invalid JSON-RPC object  
- `-32601` Method not found: Method doesn't exist
- `-32602` Invalid params: Invalid method parameters
- `-32603` Internal error: Internal JSON-RPC error

### Client Error Handling
- Network connection failures
- JSON parsing errors  
- HTTP errors
- Timeout handling

### Server Error Handling
- Malformed JSON requests
- Missing required fields
- Parameter validation
- Method execution errors
- Comprehensive logging

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Check what's using the ports
   lsof -i :4567
   lsof -i :4568
   # Kill processes or change ports in app.rb files
   ```

2. **Connection refused**
   - Ensure server is running before starting client
   - Check server logs for startup errors
   - Verify firewall settings

3. **Gem installation issues**
   ```bash
   # Update bundler and gems
   gem update bundler
   bundle update
   ```

4. **Ruby version issues**
   ```bash
   # Check Ruby version
   ruby --version
   # Should be 3.0 or higher
   ```

### Debugging

1. **Server Logs**: Check `server/server.log` for detailed request/response logs
2. **Console Output**: Both applications log to console during development
3. **Health Check**: Visit http://localhost:4567/health to verify server status
4. **Raw JSON**: Use curl or Postman to test server directly

### Configuration

Both applications support environment variable configuration:

```bash
# Server port (default: 4567)
export SERVER_PORT=4567

# Client port (default: 4568)  
export CLIENT_PORT=4568

# Server URL for client (default: http://localhost:4567/jsonrpc)
export JSON_RPC_SERVER_URL=http://localhost:4567/jsonrpc
```

## Contributing

This demo is designed for educational purposes. To extend or modify:

1. Follow JSON-RPC 2.0 specification
2. Add comprehensive parameter validation
3. Include proper error handling
4. Update tests for new functionality
5. Document new features in README

## License

This demo is part of the ActiveDataFlow project and follows the same licensing terms.