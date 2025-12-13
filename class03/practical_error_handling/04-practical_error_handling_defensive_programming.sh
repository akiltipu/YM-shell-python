#!/bin/bash
set -euo pipefail

# Practical Error Handling Example 4: Defensive Programming
# Demonstrates input validation and defensive checks

echo "=== Defensive Programming ==="

# Function with defensive checks
process_server_config() {
    local server="${1:-}"
    local port="${2:-}"
    
    # Validate arguments
    if [[ -z "$server" ]]; then
        echo "❌ Error: Server name is required"
        return 1
    fi
    
    if [[ -z "$port" ]]; then
        echo "❌ Error: Port number is required"
        return 1
    fi
    
    # Validate port number
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: Port must be a number"
        return 1
    fi
    
    if [[ "$port" -lt 1 || "$port" -gt 65535 ]]; then
        echo "❌ Error: Port must be between 1 and 65535"
        return 1
    fi
    
    # All checks passed
    echo "✓ Valid configuration:"
    echo "  Server: $server"
    echo "  Port: $port"
    return 0
}

# Test with valid input
echo "Test 1: Valid input"
process_server_config "production.example.com" "8080"

echo ""
echo "Test 2: Missing port (should fail gracefully)"
process_server_config "staging.example.com" "" || echo "Handled error gracefully"

echo ""
echo "Test 3: Invalid port (should fail gracefully)"
process_server_config "dev.example.com" "invalid" || echo "Handled error gracefully"

echo ""
echo "Test 4: Port out of range"
process_server_config "test.example.com" "99999" || echo "Handled error gracefully"

echo ""
echo "✓ All defensive checks demonstrated"
