#!/bin/bash
#
# Example 4: Configuration File Validator
# Demonstrates: File testing, content validation, field checking
#

set -euo pipefail

echo "======================================="
echo "  CONFIGURATION VALIDATOR"
echo "======================================="
echo ""

validate_config() {
    local config_file=$1
    
    echo "Validating configuration: $config_file"
    
    # Check if file exists
    if [ ! -f "$config_file" ]; then
        echo "  ✗ Error: Config file not found"
        return 1
    fi
    
    echo "  ✓ File exists"
    
    # Check file permissions
    if [ ! -r "$config_file" ]; then
        echo "  ✗ Error: Config file not readable"
        return 1
    fi
    
    echo "  ✓ File is readable"
    
    # Check if empty
    if [ ! -s "$config_file" ]; then
        echo "  ✗ Error: Config file is empty"
        return 1
    fi
    
    echo "  ✓ File has content"
    
    # Validate required fields
    local required_fields=("server" "port" "timeout")
    local missing_fields=()
    
    for field in "${required_fields[@]}"; do
        if ! grep -q "^${field}=" "$config_file"; then
            missing_fields+=("$field")
        fi
    done
    
    if [ ${#missing_fields[@]} -gt 0 ]; then
        echo "  ✗ Error: Missing required fields: ${missing_fields[*]}"
        return 1
    fi
    
    echo "  ✓ All required fields present"
    
    # Validate port number
    local port=$(grep "^port=" "$config_file" | cut -d= -f2)
    if [ -n "$port" ]; then
        if [[ ! $port =~ ^[0-9]+$ ]]; then
            echo "  ✗ Error: Port must be numeric"
            return 1
        elif [ $port -lt 1 ] || [ $port -gt 65535 ]; then
            echo "  ✗ Error: Port must be between 1-65535"
            return 1
        fi
        echo "  ✓ Port number valid: $port"
    fi
    
    echo ""
    echo "✓ Configuration validation passed"
    return 0
}

# Create test config file
cat > test_config.txt << EOF
server=localhost
port=8080
timeout=30
EOF

echo "Testing valid configuration:"
validate_config "test_config.txt"

# Cleanup
rm test_config.txt
