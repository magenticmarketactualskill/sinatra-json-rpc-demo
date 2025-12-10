#!/bin/bash

# Start both server and client in the background
echo "Starting JSON-RPC Demo..."
echo "This will start both server (port 4567) and client (port 4568)"
echo "Press Ctrl+C to stop both applications"
echo "----------------------------------------"

# Function to cleanup background processes
cleanup() {
    echo "Stopping applications..."
    kill $SERVER_PID $CLIENT_PID 2>/dev/null
    exit 0
}

# Set trap to cleanup on exit
trap cleanup SIGINT SIGTERM

# Start server in background
echo "Starting server..."
cd server
bundle exec ruby app.rb &
SERVER_PID=$!
cd ..

# Wait a moment for server to start
sleep 3

# Start client in background
echo "Starting client..."
cd client
bundle exec ruby app.rb &
CLIENT_PID=$!
cd ..

echo "----------------------------------------"
echo "✅ Server started on http://localhost:4567"
echo "✅ Client started on http://localhost:4568"
echo "✅ Open http://localhost:4568 in your browser"
echo "----------------------------------------"
echo "Press Ctrl+C to stop both applications"

# Wait for background processes
wait