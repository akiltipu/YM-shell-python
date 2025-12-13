#!/bin/bash

# Practical Example 4: URL Parsing and Validation
# Parse and validate URLs, extract components

echo "=== URL Parsing with Regex ==="
echo ""

# Sample data with URLs
cat > /tmp/urls.txt << 'EOF'
https://www.example.com
http://api.service.com:8080/v1/users
https://docs.example.com/guide/getting-started.html
ftp://files.server.com/downloads/
https://sub.domain.example.com:443/path?query=value&key=data
http://192.168.1.100:3000/api/endpoint
https://example.com/path/to/resource#section
EOF

echo "Sample URLs:"
cat /tmp/urls.txt
echo ""

# Extract all URLs
echo "1. Extract all HTTP(S) URLs:"
echo "─────────────────────────────"
grep -oE 'https?://[a-zA-Z0-9./?=_-]+' /tmp/urls.txt
echo ""

# Extract URL components
echo "2. Parse URL components:"
echo "────────────────────────"

parse_url() {
    local url=$1
    
    # Extract protocol
    if [[ $url =~ ^([a-z]+):// ]]; then
        echo "  Protocol: ${BASH_REMATCH[1]}"
    fi
    
    # Extract domain
    if [[ $url =~ ://([a-zA-Z0-9.-]+) ]]; then
        echo "  Domain: ${BASH_REMATCH[1]}"
    fi
    
    # Extract port
    if [[ $url =~ :([0-9]+)/ ]]; then
        echo "  Port: ${BASH_REMATCH[1]}"
    fi
    
    # Extract path
    if [[ $url =~ ://[^/]+(/[^?#]*) ]]; then
        echo "  Path: ${BASH_REMATCH[1]}"
    fi
    
    # Extract query string
    if [[ $url =~ \?([^#]+) ]]; then
        echo "  Query: ${BASH_REMATCH[1]}"
    fi
    
    # Extract fragment
    if [[ $url =~ #(.+)$ ]]; then
        echo "  Fragment: ${BASH_REMATCH[1]}"
    fi
    
    echo ""
}

while IFS= read -r url; do
    echo "URL: $url"
    parse_url "$url"
done < /tmp/urls.txt

# Extract domains only
echo "3. Extract unique domains:"
echo "──────────────────────────"
grep -oE '://[a-zA-Z0-9.-]+' /tmp/urls.txt | \
    sed 's|://||' | sort -u
echo ""

# Validate URL format
echo "4. Validate URL format:"
echo "───────────────────────"

validate_url() {
    local url=$1
    
    # Check for protocol
    if [[ ! $url =~ ^[a-z]+:// ]]; then
        echo "✗ $url (missing protocol)"
        return 1
    fi
    
    # Check for domain
    if [[ ! $url =~ ://[a-zA-Z0-9.-]+ ]]; then
        echo "✗ $url (invalid domain)"
        return 1
    fi
    
    echo "✓ $url (valid)"
    return 0
}

test_urls=(
    "https://example.com"
    "http://api.service.com/v1"
    "example.com"
    "https://"
    "ftp://files.server.com"
)

for url in "${test_urls[@]}"; do
    validate_url "$url"
done
echo ""

echo "💡 URL regex components:"
echo "   - Protocol: ^[a-z]+://"
echo "   - Domain: [a-zA-Z0-9.-]+"
echo "   - Port: :[0-9]+"
echo "   - Path: /[^?#]*"
echo "   - Query: \?[^#]+"
echo "   - Fragment: #.+$"

rm -f /tmp/urls.txt
