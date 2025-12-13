#!/bin/bash
set -euo pipefail

# Practical Error Handling Example 5: Retry Logic with Error Handling
# Demonstrates retry mechanisms for transient failures

echo "=== Retry Logic with Error Handling ==="

# Retry function with exponential backoff
retry_with_backoff() {
    local max_attempts=5
    local timeout=1
    local attempt=1
    local exit_code=0
    
    while [[ $attempt -le $max_attempts ]]; do
        echo "Attempt $attempt of $max_attempts..."
        
        # Simulate an operation that might fail
        if [[ $attempt -lt 3 ]]; then
            echo "  ❌ Operation failed (simulated transient error)"
            exit_code=1
        else
            echo "  ✓ Operation succeeded!"
            exit_code=0
            return 0
        fi
        
        if [[ $attempt -lt $max_attempts ]]; then
            echo "  Waiting ${timeout}s before retry..."
            sleep "$timeout"
            timeout=$((timeout * 2))  # Exponential backoff
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo "❌ All retry attempts failed"
    return $exit_code
}

# Function to simulate network request
check_service_health() {
    local service="$1"
    local max_retries=3
    local retry=1
    
    while [[ $retry -le $max_retries ]]; do
        echo "Checking $service health (attempt $retry/$max_retries)..."
        
        # Simulate health check (80% success rate simulation)
        if [[ $((RANDOM % 10)) -lt 8 ]]; then
            echo "✓ $service is healthy"
            return 0
        else
            echo "⚠ $service health check failed"
            if [[ $retry -lt $max_retries ]]; then
                sleep 2
            fi
        fi
        
        retry=$((retry + 1))
    done
    
    echo "❌ $service is unhealthy after $max_retries attempts"
    return 1
}

# Demonstrate retry logic
echo "Example 1: Retry with exponential backoff"
retry_with_backoff

echo ""
echo "Example 2: Service health check with retry"
check_service_health "api-server" || echo "Service check failed, but handled gracefully"

echo ""
echo "✓ Retry patterns demonstrated"
