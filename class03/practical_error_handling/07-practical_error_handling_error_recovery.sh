#!/bin/bash
set -euo pipefail

# Practical Error Handling Example 7: Error Recovery Strategies
# Demonstrates graceful degradation and fallback mechanisms

echo "=== Error Recovery Strategies ==="

# Function with fallback mechanism
fetch_config() {
    local primary_source="$1"
    local fallback_source="$2"
    local default_value="$3"
    
    echo "Attempting to fetch from primary source: $primary_source"
    
    # Try primary source
    if [[ -f "$primary_source" ]]; then
        echo "✓ Primary source available"
        cat "$primary_source"
        return 0
    fi
    
    echo "⚠ Primary source unavailable, trying fallback: $fallback_source"
    
    # Try fallback source
    if [[ -f "$fallback_source" ]]; then
        echo "✓ Fallback source available"
        cat "$fallback_source"
        return 0
    fi
    
    echo "⚠ Fallback source unavailable, using default value"
    echo "$default_value"
    return 0
}

# Function with graceful degradation
process_with_fallback() {
    local operation="$1"
    
    case "$operation" in
        "fast")
            echo "Attempting fast processing..."
            if [[ $((RANDOM % 2)) -eq 0 ]]; then
                echo "✓ Fast processing succeeded"
                return 0
            else
                echo "⚠ Fast processing failed, falling back to standard"
                operation="standard"
            fi
            ;;&  # Continue to next match
        
        "standard")
            echo "Attempting standard processing..."
            if [[ $((RANDOM % 2)) -eq 0 ]]; then
                echo "✓ Standard processing succeeded"
                return 0
            else
                echo "⚠ Standard processing failed, falling back to safe mode"
                operation="safe"
            fi
            ;;&  # Continue to next match
        
        "safe")
            echo "Using safe mode processing..."
            echo "✓ Safe mode always succeeds (with reduced functionality)"
            return 0
            ;;
    esac
}

# Demonstrate config fetching with fallback
echo "Example 1: Configuration with fallback chain"
echo "config=primary" > /tmp/primary_config.txt
result=$(fetch_config "/tmp/primary_config.txt" "/tmp/fallback_config.txt" "config=default")
echo "Result: $result"

echo ""
echo "Example 2: Graceful degradation"
process_with_fallback "fast"

echo ""
echo "Example 3: Error recovery with transaction rollback"
transaction_with_rollback() {
    echo "Starting transaction..."
    local checkpoint="/tmp/checkpoint.txt"
    
    # Save checkpoint
    echo "checkpoint_data" > "$checkpoint"
    echo "✓ Checkpoint saved"
    
    # Simulate operation
    echo "Performing operations..."
    
    # Simulate error detection
    if [[ $((RANDOM % 3)) -eq 0 ]]; then
        echo "❌ Error detected, rolling back..."
        echo "✓ Restored from checkpoint"
        rm -f "$checkpoint"
        return 1
    fi
    
    echo "✓ Transaction committed"
    rm -f "$checkpoint"
    return 0
}

transaction_with_rollback || echo "Transaction failed but was handled gracefully"

echo ""
echo "✓ Error recovery strategies demonstrated"
