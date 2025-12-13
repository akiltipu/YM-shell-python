#!/bin/bash

# Practical Example 2: IP Address Validation and Extraction
# Validate and extract IP addresses from configuration files

echo "=== IP Address Validation with Regex ==="
echo ""

# Create sample config file
cat > /tmp/network.conf << 'EOF'
# Network Configuration
server_ip=192.168.1.100
database_ip=10.0.0.50
cache_ip=172.16.0.25
invalid_ip=999.999.999.999
api_endpoint=256.1.1.1
backup_server=192.168.1.200
EOF

echo "Sample configuration file:"
cat /tmp/network.conf
echo ""

# Extract all IP-like patterns
echo "1. Extract all IP-like patterns:"
echo "────────────────────────────────"
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /tmp/network.conf
echo ""

# Validate IP addresses (basic pattern)
echo "2. Validate IP addresses (with basic validation):"
echo "──────────────────────────────────────────────────"

validate_ip() {
    local ip=$1
    
    # Check if it matches IP pattern
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        # Split and validate each octet
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [ "$octet" -gt 255 ]; then
                echo "✗ $ip (invalid: octet > 255)"
                return 1
            fi
        done
        echo "✓ $ip (valid)"
        return 0
    else
        echo "✗ $ip (invalid format)"
        return 1
    fi
}

while IFS='=' read -r key value; do
    if [[ $key =~ _ip$ ]]; then
        validate_ip "$value"
    fi
done < <(grep -E '=' /tmp/network.conf | grep -v '^#')
echo ""

# Extract only valid private IP addresses
echo "3. Extract private IP addresses (RFC 1918):"
echo "────────────────────────────────────────────"
grep -oE '(192\.168\.[0-9]{1,3}\.[0-9]{1,3}|10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]{1,3}\.[0-9]{1,3})' /tmp/network.conf
echo ""

# Group IPs by subnet
echo "4. Group IPs by subnet:"
echo "───────────────────────"
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /tmp/network.conf | \
    awk -F'.' '{printf "%s.%s.%s.0/24\n", $1, $2, $3}' | sort -u
echo ""

echo "💡 IP validation techniques:"
echo "   - Basic pattern: [0-9]{1,3}(\.[0-9]{1,3}){3}"
echo "   - Private IPs: 192.168.x.x, 10.x.x.x, 172.16-31.x.x"
echo "   - Validate octets: 0-255 range"

rm -f /tmp/network.conf
