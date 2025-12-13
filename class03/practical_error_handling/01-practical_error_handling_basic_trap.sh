#!/bin/bash
set -euo pipefail

# Practical Error Handling Example 1: Basic Trap Usage
# Demonstrates how to catch errors and perform cleanup operations

echo "=== Basic Trap Usage ==="

# Cleanup function that runs on exit
cleanup() {
    echo "Performing cleanup..."
    echo "Removing temporary files..."
    # rm -f /tmp/temp_*.txt
    echo "Cleanup completed"
}

# Set trap to call cleanup on EXIT
trap cleanup EXIT

echo "Starting process..."
echo "Creating temporary files..."
echo "demo" > /tmp/temp_demo.txt
echo "Files created successfully"

echo "Processing data..."
sleep 1

echo "Process completed successfully"
# Script exits here, and cleanup() will be called automatically
