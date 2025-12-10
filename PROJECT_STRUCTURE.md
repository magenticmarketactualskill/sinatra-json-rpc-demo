# Project Structure

This document describes the organization and structure of the Sinatra JSON-RPC Demo repository.

## Repository Overview

This is a demonstration project showcasing JSON-RPC 2.0 communication between two Sinatra applications. It serves as an educational example and reference implementation.

## Directory Structure

```
sinatra-json-rpc-demo/
├── .git/                          # Git repository metadata
├── .gitignore                     # Git ignore patterns
├── .submoduler.ini               # Submoduler configuration
├── README.md                     # Main documentation
├── PROJECT_STRUCTURE.md          # This file
├── *.sh                          # Utility scripts
│   ├── install_dependencies.sh   # Install all dependencies
│   ├── start_server.sh           # Start JSON-RPC server only
│   ├── start_client.sh           # Start web client only
│   ├── start_demo.sh             # Start both applications
│   └── test_demo.sh              # Test server with sample requests
├── server/                       # JSON-RPC Server Application
│   ├── Gemfile                   # Server dependencies
│   ├── app.rb                    # Main Sinatra server application
│   ├── json_rpc_processor.rb     # JSON-RPC 2.0 protocol handler
│   ├── rpc_methods.rb            # RPC method implementations
│   └── server.log                # Request/response logs (generated)
└── client/                       # Web Client Application
    ├── Gemfile                   # Client dependencies
    ├── app.rb                    # Main Sinatra client application
    ├── json_rpc_client.rb        # JSON-RPC client class
    ├── views/                    # ERB templates
    │   ├── layout.erb            # Base layout template
    │   ├── index.erb             # Home page
    │   ├── calculator.erb        # Calculator forms
    │   ├── calculator_result.erb # Calculator results
    │   ├── strings.erb           # String operation forms
    │   ├── strings_result.erb    # String operation results
    │   ├── storage.erb           # Storage operation forms
    │   └── storage_result.erb    # Storage operation results
    └── public/                   # Static assets
        └── style.css             # CSS styling
```

## Component Descriptions

### Server Application (`server/`)

The server implements a JSON-RPC 2.0 compliant endpoint with the following components:

- **app.rb**: Main Sinatra application with routing, logging, and error handling
- **json_rpc_processor.rb**: Core JSON-RPC protocol implementation with validation
- **rpc_methods.rb**: Business logic for all RPC methods (calculator, string, storage)

### Client Application (`client/`)

The client provides a web interface for interacting with the JSON-RPC server:

- **app.rb**: Main Sinatra application with web routes and form handling
- **json_rpc_client.rb**: HTTP client for making JSON-RPC requests
- **views/**: ERB templates for the web interface
- **public/**: Static CSS and other assets

### Utility Scripts

- **install_dependencies.sh**: Installs Ruby gems for both applications
- **start_server.sh**: Starts only the JSON-RPC server (port 4567)
- **start_client.sh**: Starts only the web client (port 4568)
- **start_demo.sh**: Starts both applications simultaneously
- **test_demo.sh**: Runs automated tests against the server

## Configuration Files

### .submoduler.ini

Contains metadata for the submoduler system:
- Project information (name, description, version)
- Git configuration
- Dependencies
- Available scripts
- Documentation settings

### .gitignore

Excludes common Ruby, OS, and IDE files from version control:
- Ruby artifacts (gems, coverage, logs)
- Bundler files
- OS files (.DS_Store, Thumbs.db)
- IDE files (.vscode, .idea)
- Environment files (.env)

## Development Workflow

1. **Setup**: Run `./install_dependencies.sh` to install all dependencies
2. **Development**: Use `./start_demo.sh` to run both applications
3. **Testing**: Use `./test_demo.sh` to verify functionality
4. **Individual Apps**: Use `./start_server.sh` or `./start_client.sh` for single applications

## Port Configuration

- **Server**: http://localhost:4567 (JSON-RPC endpoint at /jsonrpc)
- **Client**: http://localhost:4568 (Web interface)

## Key Features

- Full JSON-RPC 2.0 specification compliance
- Comprehensive error handling with standard error codes
- Support for both positional and named parameters
- Request/response logging with timestamps
- User-friendly web interface with forms and result display
- Three categories of RPC methods (calculator, string, storage)
- Proper parameter validation and type checking

## Repository Type

This is a **demonstration/example** repository designed for:
- Educational purposes
- Reference implementation
- Testing JSON-RPC concepts
- Showcasing Sinatra web development patterns