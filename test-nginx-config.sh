#!/bin/bash

echo "Testing Nginx configuration syntax..."

# Test nginx configuration using docker
docker run --rm -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro nginx:alpine nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx configuration is valid!"
else
    echo "❌ Nginx configuration has errors!"
    exit 1
fi