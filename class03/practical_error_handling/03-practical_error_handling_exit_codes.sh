#!/bin/bash
set -euo pipefail

# Practical Error Handling Example 3: Custom Exit Codes
# Demonstrates using meaningful exit codes for different error types

echo "=== Custom Exit Codes ==="

# Exit code constants
readonly E_SUCCESS=0
readonly E_INVALID_ARGS=1
readonly E_FILE_NOT_FOUND=2
readonly E_PERMISSION_DENIED=3
readonly E_NETWORK_ERROR=4
readonly E_TIMEOUT=5

# Function to check file exists
check_file() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo "❌ Error: File not found: $file"
        return $E_FILE_NOT_FOUND
    fi
    
    if [[ ! -r "$file" ]]; then
        echo "❌ Error: Permission denied: $file"
        return $E_PERMISSION_DENIED
    fi
    
    echo "✓ File accessible: $file"
    return $E_SUCCESS
}

# Simulate checking files
echo "Checking files..."

# Create a test file
test_file="/tmp/test_exit_codes.txt"
echo "test data" > "$test_file"

if check_file "$test_file"; then
    echo "File check passed"
else
    exit_code=$?
    echo "File check failed with exit code: $exit_code"
    exit $exit_code
fi

# Check non-existent file (simulation)
echo ""
echo "Simulating file not found scenario..."
# check_file "/nonexistent/file.txt" || echo "Exit code: $?"

echo ""
echo "✓ Script completed successfully"
exit $E_SUCCESS
