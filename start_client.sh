#!/bin/bash

# Start JSON-RPC Client
echo "Starting JSON-RPC Client on port 4568..."
echo "Press Ctrl+C to stop the client"
echo "Client will be available at http://localhost:4568"
echo "Make sure the server is running on port 4567"
echo "----------------------------------------"

cd client
bundle exec ruby app.rb