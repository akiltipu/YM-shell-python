#!/bin/bash
set -euo pipefail

# Practical Error Handling Example 2: Error Trap with ERR Signal
# Demonstrates catching command failures and displaying error context

echo "=== Error Trap with ERR Signal ==="

# Error handler function
error_handler() {
    local line_number=$1
    local command="$2"
    echo "❌ ERROR: Command failed at line $line_number"
    echo "Failed command: $command"
    echo "Exit code: $?"
    exit 1
}

# Set trap for ERR signal
trap 'error_handler ${LINENO} "$BASH_COMMAND"' ERR

echo "Starting operations..."

# This will succeed
echo "Step 1: Successful operation"
ls /tmp > /dev/null

echo "Step 2: Another successful operation"
echo "test" > /tmp/test_file.txt

# Simulate error (uncomment to test)
# echo "Step 3: This will fail"
# ls /nonexistent_directory

echo "All operations completed successfully!"
