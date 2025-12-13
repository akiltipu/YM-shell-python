#!/bin/bash
# Error Handling Demonstration

# Enable strict error checking
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

echo "======================================="
echo "      ERROR HANDLING DEMO"
echo "======================================="
echo ""

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Function for warnings
warning() {
    echo "WARNING: $1" >&2
}

# Trap errors and cleanup
cleanup() {
    echo ""
    echo "Cleaning up..."
    # Add cleanup code here
    echo "Cleanup complete"
}

trap cleanup EXIT  # Run cleanup on exit
trap 'error_exit "Script interrupted"' INT TERM  # Handle Ctrl+C

# Example 1: Check command success
echo "=== Example 1: Command Success Check ==="
if command -v docker &> /dev/null; then
    echo "✓ Docker is installed"
else
    error_exit "Docker is not installed!"
fi
echo ""

# Example 2: File operations with error checking
echo "=== Example 2: File Operations ==="
config_file="config.txt"

if [ ! -f "$config_file" ]; then
    warning "Config file not found, creating default"
    echo "default_config=true" > "$config_file" || error_exit "Failed to create config"
fi

echo "✓ Config file ready: $config_file"
echo ""

# Example 3: Function with error return
echo "=== Example 3: Function Error Handling ==="
check_port() {
    local port=$1
    
    if [ -z "$port" ]; then
        return 1
    fi
    
    if [ "$port" -lt 1024 ] || [ "$port" -gt 65535 ]; then
        return 2
    fi
    
    return 0
}

if check_port 8080; then
    echo "✓ Port 8080 is valid"
else
    exit_code=$?
    case $exit_code in
        1)
            error_exit "Port number not provided"
            ;;
        2)
            error_exit "Port number out of range"
            ;;
    esac
fi
echo ""

# Example 4: Try-catch like behavior
echo "=== Example 4: Try-Catch Pattern ==="
{
    # Try block
    echo "Attempting risky operation..."
    # Simulate command that might fail
    [ -d "/nonexistent" ] && echo "Found" || echo "Not found (handled)"
} || {
    # Catch block
    warning "Operation had issues but recovered"
}
echo ""

echo "======================================="
echo "Script completed successfully!"
