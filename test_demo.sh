#!/bin/bash

echo "Testing JSON-RPC Demo with sample requests..."
echo "Make sure the server is running on port 4567"
echo "----------------------------------------"

SERVER_URL="http://localhost:4567/jsonrpc"

# Test if server is running
if ! curl -s "$SERVER_URL" > /dev/null; then
    echo "❌ Server is not running on port 4567"
    echo "Please start the server first with: ./start_server.sh"
    exit 1
fi

echo "✅ Server is running, testing RPC methods..."
echo

# Test calculator methods
echo "🧮 Testing Calculator Methods:"
echo "1. Testing add(5, 3):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "add", "params": [5, 3], "id": 1}' | jq .

echo "2. Testing multiply(4, 7):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "multiply", "params": [4, 7], "id": 2}' | jq .

echo "3. Testing divide(10, 2):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "divide", "params": [10, 2], "id": 3}' | jq .

echo
echo "📝 Testing String Methods:"
echo "1. Testing reverse_string('Hello World'):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "reverse_string", "params": ["Hello World"], "id": 4}' | jq .

echo "2. Testing uppercase('json-rpc demo'):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "uppercase", "params": ["json-rpc demo"], "id": 5}' | jq .

echo "3. Testing word_count('This is a test sentence'):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "word_count", "params": ["This is a test sentence"], "id": 6}' | jq .

echo
echo "💾 Testing Storage Methods:"
echo "1. Testing store_data('user1', {'name': 'John', 'age': 30}):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "store_data", "params": ["user1", {"name": "John", "age": 30}], "id": 7}' | jq .

echo "2. Testing retrieve_data('user1'):"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "retrieve_data", "params": ["user1"], "id": 8}' | jq .

echo "3. Testing list_keys():"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "list_keys", "params": [], "id": 9}' | jq .

echo
echo "❌ Testing Error Handling:"
echo "1. Testing invalid method:"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "invalid_method", "params": [], "id": 10}' | jq .

echo "2. Testing division by zero:"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "method": "divide", "params": [10, 0], "id": 11}' | jq .

echo "3. Testing invalid JSON:"
curl -s -X POST "$SERVER_URL" \
  -H "Content-Type: application/json" \
  -d '{"invalid": "json"' | jq .

echo
echo "----------------------------------------"
echo "✅ Demo testing completed!"
echo "Check the server logs for detailed request/response information"