#!/bin/bash

# Configuration Validation Tests
# Tests Docker Compose file syntax and Nginx configuration

set -e

echo "=== Configuration Validation Tests ==="
echo

# Test 1: Docker Compose file syntax validation
echo "Test 1: Validating Docker Compose syntax..."
if docker-compose config > /dev/null 2>&1; then
    echo "✅ Docker Compose syntax is valid"
else
    echo "❌ Docker Compose syntax validation failed"
    exit 1
fi

# Test 2: Check required Docker Compose service definitions
echo "Test 2: Checking Docker Compose service definitions..."
if docker-compose config | grep -q "nginx-proxy:"; then
    echo "✅ nginx-proxy service is defined"
else
    echo "❌ nginx-proxy service not found"
    exit 1
fi

# Test 3: Check port mapping
echo "Test 3: Checking port mapping..."
if docker-compose config | grep -q "published.*80"; then
    echo "✅ Port 80 is properly exposed"
else
    echo "❌ Port 80 mapping not found"
    exit 1
fi

# Test 4: Check volume mounts
echo "Test 4: Checking volume mounts..."
if docker-compose config | grep -q "nginx.conf"; then
    echo "✅ nginx.conf volume mount is configured"
else
    echo "❌ nginx.conf volume mount not found"
    exit 1
fi

# Test 5: Nginx configuration file exists
echo "Test 5: Checking nginx.conf file exists..."
if [ -f "nginx.conf" ]; then
    echo "✅ nginx.conf file exists"
else
    echo "❌ nginx.conf file not found"
    exit 1
fi

# Test 6: Check required location blocks in nginx.conf
echo "Test 6: Checking required location blocks..."
required_locations=("/map" "/data" "/pm25" "/pm25infuxd")
for location in "${required_locations[@]}"; do
    if grep -q "location $location" nginx.conf; then
        echo "✅ Location block $location is present"
    else
        echo "❌ Location block $location not found"
        exit 1
    fi
done

# Test 7: Check upstream definitions
echo "Test 7: Checking upstream definitions..."
required_upstreams=("map_backend" "data_backend" "pm25_backend" "pm25infuxd_backend")
for upstream in "${required_upstreams[@]}"; do
    if grep -q "upstream $upstream" nginx.conf; then
        echo "✅ Upstream $upstream is defined"
    else
        echo "❌ Upstream $upstream not found"
        exit 1
    fi
done

# Test 8: Check backend server addresses
echo "Test 8: Checking backend server addresses..."
if grep -q "172.16.116.82:3000" nginx.conf; then
    echo "✅ Map backend (172.16.116.82:3000) is configured"
else
    echo "❌ Map backend address not found"
    exit 1
fi

if grep -q "172.16.116.82:8501" nginx.conf; then
    echo "✅ Data backend (172.16.116.82:8501) is configured"
else
    echo "❌ Data backend address not found"
    exit 1
fi

if grep -q "172.16.116.82:3002" nginx.conf; then
    echo "✅ PM25 backend (172.16.116.82:3002) is configured"
else
    echo "❌ PM25 backend address not found"
    exit 1
fi

if grep -q "172.16.116.82:8086" nginx.conf; then
    echo "✅ PM25infuxd backend (172.16.116.82:8086) is configured"
else
    echo "❌ PM25infuxd backend address not found"
    exit 1
fi

# Test 9: Check proxy headers configuration
echo "Test 9: Checking proxy headers..."
if grep -q "proxy_set_header.*X-Real-IP" nginx.conf; then
    echo "✅ X-Real-IP header is configured"
else
    echo "❌ X-Real-IP header not found"
    exit 1
fi

if grep -q "proxy_set_header.*X-Forwarded-For" nginx.conf; then
    echo "✅ X-Forwarded-For header is configured"
else
    echo "❌ X-Forwarded-For header not found"
    exit 1
fi

# Test 10: Check logging configuration
echo "Test 10: Checking logging configuration..."
if grep -q "access_log.*nginx" nginx.conf; then
    echo "✅ Access logging is configured"
else
    echo "❌ Access logging not found"
    exit 1
fi

if grep -q "error_log.*nginx" nginx.conf; then
    echo "✅ Error logging is configured"
else
    echo "❌ Error logging not found"
    exit 1
fi

echo
echo "🎉 All configuration validation tests passed!"
echo "Configuration is ready for deployment."