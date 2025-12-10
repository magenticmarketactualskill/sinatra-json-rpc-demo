#!/bin/bash

echo "Installing dependencies for Sinatra JSON-RPC Demo..."
echo "This will install gems for both server and client applications"
echo "----------------------------------------"

# Install server dependencies
echo "Installing server dependencies..."
cd server
if bundle install; then
    echo "✅ Server dependencies installed successfully"
else
    echo "❌ Failed to install server dependencies"
    exit 1
fi
cd ..

# Install client dependencies
echo "Installing client dependencies..."
cd client
if bundle install; then
    echo "✅ Client dependencies installed successfully"
else
    echo "❌ Failed to install client dependencies"
    exit 1
fi
cd ..

echo "----------------------------------------"
echo "✅ All dependencies installed successfully!"
echo "You can now run the demo with:"
echo "  ./start_demo.sh    (starts both server and client)"
echo "  ./start_server.sh  (starts only the server)"
echo "  ./start_client.sh  (starts only the client)"