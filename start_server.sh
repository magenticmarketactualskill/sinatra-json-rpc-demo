#!/bin/bash

# Start JSON-RPC Server
echo "Starting JSON-RPC Server on port 4567..."
echo "Press Ctrl+C to stop the server"
echo "Server will be available at http://localhost:4567"
echo "Health check: http://localhost:4567/health"
echo "----------------------------------------"

cd server
bundle exec ruby app.rb