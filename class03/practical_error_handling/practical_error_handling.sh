#!/bin/bash
set -euo pipefail

# Comprehensive Error Handling Examples
# All error handling patterns in one file for reference

echo "======================================"
echo "Comprehensive Error Handling Examples"
echo "======================================"
echo ""

# ============================================================================
# Example 1: Basic Trap Usage
# ============================================================================
echo "=== 1. Basic Trap Usage ==="

cleanup_demo() {
    echo "Performing cleanup operations..."
}

trap cleanup_demo EXIT

echo "✓ Trap set for cleanup on exit"
echo ""

# ============================================================================
# Example 2: Error Trap with ERR Signal
# ============================================================================
echo "=== 2. Error Trap with ERR Signal ==="

error_handler() {
    local line_number=$1
    echo "ERROR at line $line_number"
}

trap 'error_handler ${LINENO}' ERR

echo "✓ Error trap configured"
echo ""

# ============================================================================
# Example 3: Custom Exit Codes
# ============================================================================
echo "=== 3. Custom Exit Codes ==="

readonly E_SUCCESS=0
readonly E_FILE_NOT_FOUND=2
readonly E_PERMISSION_DENIED=3

check_file_demo() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        return $E_FILE_NOT_FOUND
    fi
    return $E_SUCCESS
}

echo "✓ Exit code constants defined"
echo ""

# ============================================================================
# Example 4: Defensive Programming
# ============================================================================
echo "=== 4. Defensive Programming ==="

validate_input() {
    local value="${1:-}"
    
    if [[ -z "$value" ]]; then
        echo "❌ Error: Value is required"
        return 1
    fi
    
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: Value must be numeric"
        return 1
    fi
    
    echo "✓ Input validated: $value"
    return 0
}

validate_input "123" || true
echo ""

# ============================================================================
# Example 5: Retry Logic
# ============================================================================
echo "=== 5. Retry Logic ==="

retry_operation() {
    local max_attempts=3
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        echo "Attempt $attempt/$max_attempts"
        if [[ $attempt -eq 2 ]]; then
            echo "✓ Operation succeeded"
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 1
    done
    
    return 1
}

retry_operation
echo ""

# ============================================================================
# Example 6: Error Logging
# ============================================================================
echo "=== 6. Error Logging ==="

LOG_FILE="/tmp/error_demo.log"

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE"
}

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"
}

log_info "Operation started"
log_error "Simulated error occurred"
echo "✓ Logged to $LOG_FILE"
echo ""

# ============================================================================
# Example 7: Error Recovery
# ============================================================================
echo "=== 7. Error Recovery ==="

process_with_fallback() {
    echo "Trying primary method..."
    if [[ $((RANDOM % 2)) -eq 0 ]]; then
        echo "✓ Primary method succeeded"
        return 0
    fi
    
    echo "⚠ Primary failed, trying fallback..."
    echo "✓ Fallback method succeeded"
    return 0
}

process_with_fallback
echo ""

# ============================================================================
# Summary
# ============================================================================
echo "======================================"
echo "All error handling patterns demonstrated!"
echo "======================================"
