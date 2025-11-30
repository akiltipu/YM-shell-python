#!/bin/bash
#
# Example 2: Validation Functions Demo
# Demonstrates: Input validation, regex patterns, error handling
#

set -euo pipefail

echo "======================================="
echo "  VALIDATION FUNCTIONS DEMO"
echo "======================================="
echo ""

readonly LOG_FILE="/tmp/validation_demo.log"

log_error() {
    echo "[ERROR] $*" >&2
}

log_debug() {
    echo "[DEBUG] $*"
}

#==========================================
# VALIDATION FUNCTIONS
#==========================================

validate_not_empty() {
    local value=$1
    local field_name=$2
    
    if [ -z "$value" ]; then
        log_error "$field_name cannot be empty"
        return 1
    fi
    
    log_debug "Validation passed: $field_name is not empty"
    return 0
}

validate_number() {
    local value=$1
    local field_name=${2:-"Value"}
    
    if ! [[ $value =~ ^[0-9]+$ ]]; then
        log_error "$field_name must be a number (got: $value)"
        return 1
    fi
    
    log_debug "Validation passed: $field_name is a number"
    return 0
}

validate_ip_address() {
    local ip=$1
    
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        # Validate each octet
        IFS='.' read -ra OCTETS <<< "$ip"
        for octet in "${OCTETS[@]}"; do
            if [ "$octet" -gt 255 ]; then
                log_error "Invalid IP address: $ip (octet > 255)"
                return 1
            fi
        done
        log_debug "Validation passed: $ip is a valid IP address"
        return 0
    else
        log_error "Invalid IP address format: $ip"
        return 1
    fi
}

validate_email() {
    local email=$1
    
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        log_debug "Validation passed: $email is a valid email"
        return 0
    else
        log_error "Invalid email format: $email"
        return 1
    fi
}

validate_port() {
    local port=$1
    
    if ! validate_number "$port" "Port"; then
        return 1
    fi
    
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        log_error "Port must be between 1-65535 (got: $port)"
        return 1
    fi
    
    log_debug "Validation passed: Port $port is valid"
    return 0
}

#==========================================
# DEMO
#==========================================

echo "Testing validation functions..."
echo ""

# Test 1: Not empty
echo "Test 1: Not empty validation"
validate_not_empty "test_value" "Username" && echo "✓ Passed"
validate_not_empty "" "Username" || echo "✓ Correctly rejected empty value"
echo ""

# Test 2: Number validation
echo "Test 2: Number validation"
validate_number "12345" "Age" && echo "✓ Passed"
validate_number "abc123" "Age" || echo "✓ Correctly rejected non-numeric"
echo ""

# Test 3: IP address validation
echo "Test 3: IP address validation"
validate_ip_address "192.168.1.1" && echo "✓ Passed"
validate_ip_address "999.168.1.1" || echo "✓ Correctly rejected invalid IP"
echo ""

# Test 4: Email validation
echo "Test 4: Email validation"
validate_email "user@example.com" && echo "✓ Passed"
validate_email "invalid.email" || echo "✓ Correctly rejected invalid email"
echo ""

# Test 5: Port validation
echo "Test 5: Port validation"
validate_port "8080" && echo "✓ Passed"
validate_port "99999" || echo "✓ Correctly rejected invalid port"
echo ""

echo "All validation tests completed!"
