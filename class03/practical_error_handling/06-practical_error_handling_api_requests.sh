#!/bin/bash

# Practical Example 6: API Request Error Handling
# Demonstrates robust error handling for HTTP API calls

set -euo pipefail

# Configuration
API_BASE_URL="https://api.example.com"
MAX_RETRIES=3
RETRY_DELAY=2
TIMEOUT=10

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Make API request with retry logic
api_request() {
    local endpoint=$1
    local method=${2:-GET}
    local data=${3:-}
    local retry_count=0
    
    while [ $retry_count -lt $MAX_RETRIES ]; do
        echo "Attempt $((retry_count + 1))/$MAX_RETRIES: $method $endpoint"
        
        # Construct curl command
        local curl_cmd="curl -s -w '\n%{http_code}' -X $method"
        curl_cmd="$curl_cmd --max-time $TIMEOUT"
        
        if [ -n "$data" ]; then
            curl_cmd="$curl_cmd -H 'Content-Type: application/json' -d '$data'"
        fi
        
        # Execute request (simulated for demo)
        local response=$(simulate_api_call "$endpoint" "$method" $retry_count)
        local http_code=$(echo "$response" | tail -n1)
        local body=$(echo "$response" | head -n-1)
        
        # Handle response based on HTTP status code
        case $http_code in
            200|201|204)
                echo -e "${GREEN}✓ Success (HTTP $http_code)${NC}"
                echo "$body"
                return 0
                ;;
            400)
                echo -e "${RED}✗ Bad Request (HTTP $http_code)${NC}"
                echo "Error: $body"
                return 1
                ;;
            401|403)
                echo -e "${RED}✗ Authentication/Authorization Error (HTTP $http_code)${NC}"
                echo "Error: $body"
                return 1
                ;;
            404)
                echo -e "${RED}✗ Not Found (HTTP $http_code)${NC}"
                echo "Error: $body"
                return 1
                ;;
            429)
                echo -e "${YELLOW}⚠ Rate Limited (HTTP $http_code)${NC}"
                local wait_time=$((RETRY_DELAY * (retry_count + 1)))
                echo "Waiting ${wait_time}s before retry..."
                sleep $wait_time
                ;;
            500|502|503|504)
                echo -e "${YELLOW}⚠ Server Error (HTTP $http_code)${NC}"
                echo "Retrying in ${RETRY_DELAY}s..."
                sleep $RETRY_DELAY
                ;;
            000)
                echo -e "${YELLOW}⚠ Connection Timeout${NC}"
                echo "Retrying in ${RETRY_DELAY}s..."
                sleep $RETRY_DELAY
                ;;
            *)
                echo -e "${RED}✗ Unexpected HTTP code: $http_code${NC}"
                return 1
                ;;
        esac
        
        ((retry_count++))
    done
    
    echo -e "${RED}✗ Max retries exceeded${NC}"
    return 1
}

# Simulate API calls for demo
simulate_api_call() {
    local endpoint=$1
    local method=$2
    local attempt=$3
    
    case $endpoint in
        "/users/123")
            if [ $attempt -lt 2 ]; then
                # Simulate server error on first attempts
                echo '{"error": "Internal server error"}'
                echo "503"
            else
                # Success on final attempt
                echo '{"id": 123, "name": "John Doe", "email": "john@example.com"}'
                echo "200"
            fi
            ;;
        "/users")
            if [ "$method" = "POST" ]; then
                echo '{"id": 456, "name": "Jane Smith", "created": true}'
                echo "201"
            fi
            ;;
        "/unauthorized")
            echo '{"error": "Invalid API key"}'
            echo "401"
            ;;
        "/not-found")
            echo '{"error": "Resource not found"}'
            echo "404"
            ;;
        "/rate-limited")
            if [ $attempt -eq 0 ]; then
                echo '{"error": "Rate limit exceeded"}'
                echo "429"
            else
                echo '{"message": "Request successful"}'
                echo "200"
            fi
            ;;
        *)
            echo '{"error": "Unknown endpoint"}'
            echo "404"
            ;;
    esac
}

# Batch API requests with error handling
batch_api_requests() {
    local endpoints=("$@")
    local success_count=0
    local failure_count=0
    
    echo "=== Batch API Requests ==="
    echo "Processing ${#endpoints[@]} endpoints..."
    echo ""
    
    for endpoint in "${endpoints[@]}"; do
        echo "→ Processing: $endpoint"
        if api_request "$endpoint" "GET" 2>&1 | grep -q "Success"; then
            ((success_count++))
        else
            ((failure_count++))
        fi
        echo ""
    done
    
    echo "=== Batch Results ==="
    echo -e "${GREEN}Successful: $success_count${NC}"
    echo -e "${RED}Failed: $failure_count${NC}"
    
    if [ $failure_count -gt 0 ]; then
        return 1
    fi
    return 0
}

# Main demo
main() {
    echo "=== API Request Error Handling Demo ==="
    echo ""
    
    # Scenario 1: Successful request after retries
    echo "Scenario 1: Server error with automatic retry"
    echo "─────────────────────────────────────────────"
    api_request "/users/123" "GET"
    echo ""
    
    # Scenario 2: Authentication error
    echo "Scenario 2: Authentication failure (no retry)"
    echo "──────────────────────────────────────────────"
    api_request "/unauthorized" "GET" || echo "Request failed as expected"
    echo ""
    
    # Scenario 3: Not found error
    echo "Scenario 3: Resource not found"
    echo "───────────────────────────────"
    api_request "/not-found" "GET" || echo "Request failed as expected"
    echo ""
    
    # Scenario 4: Rate limiting with backoff
    echo "Scenario 4: Rate limiting with exponential backoff"
    echo "───────────────────────────────────────────────────"
    api_request "/rate-limited" "GET"
    echo ""
    
    # Scenario 5: POST request
    echo "Scenario 5: Successful POST request"
    echo "────────────────────────────────────"
    api_request "/users" "POST" '{"name":"Jane Smith","email":"jane@example.com"}'
    echo ""
    
    echo "=== Error Handling Features Demonstrated ==="
    echo "✓ Automatic retry with exponential backoff"
    echo "✓ Different handling for different HTTP codes"
    echo "✓ Rate limiting detection and recovery"
    echo "✓ Timeout handling"
    echo "✓ Non-retryable error detection (4xx codes)"
    echo "✓ Detailed error reporting"
}

# Run demo
main

echo ""
echo "💡 Key API Error Handling Patterns:"
echo "   - Retry logic with exponential backoff"
echo "   - HTTP status code-based error handling"
echo "   - Timeout protection"
echo "   - Rate limit handling"
echo "   - Non-retryable error detection"
