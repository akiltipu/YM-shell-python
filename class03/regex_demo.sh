#!/bin/bash
# Regular Expressions Demonstration

echo "======================================="
echo "     REGULAR EXPRESSIONS IN SHELL"
echo "======================================="
echo ""

# Example 1: Pattern matching with =~
echo "=== Example 1: Email Validation ==="
email_pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

validate_email() {
    local email=$1
    if [[ $email =~ $email_pattern ]]; then
        echo "✓ Valid email: $email"
        return 0
    else
        echo "✗ Invalid email: $email"
        return 1
    fi
}

validate_email "user@example.com"
validate_email "invalid-email"
validate_email "test.user+tag@domain.co.uk"
echo ""

# Example 2: IP Address validation
echo "=== Example 2: IP Address Validation ==="
ip_pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

validate_ip() {
    local ip=$1
    if [[ $ip =~ $ip_pattern ]]; then
        # Additional check for valid ranges (0-255)
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [ "$octet" -gt 255 ]; then
                echo "✗ Invalid IP (out of range): $ip"
                return 1
            fi
        done
        echo "✓ Valid IP: $ip"
        return 0
    else
        echo "✗ Invalid IP format: $ip"
        return 1
    fi
}

validate_ip "192.168.1.1"
validate_ip "256.1.1.1"
validate_ip "10.0.0.1"
validate_ip "invalid"
echo ""

# Example 3: Log parsing
echo "=== Example 3: Log Parsing ==="
cat > sample.log << 'EOF'
2025-12-01 10:15:23 INFO User logged in: john@example.com
2025-12-01 10:16:45 ERROR Database connection failed: timeout
2025-12-01 10:17:12 WARN High memory usage: 85%
2025-12-01 10:18:33 ERROR Failed to send email to admin@company.com
2025-12-01 10:19:01 INFO Backup completed successfully
EOF

echo "Extracting ERROR messages:"
while IFS= read -r line; do
    if [[ $line =~ ERROR ]]; then
        echo "  $line"
    fi
done < sample.log
echo ""

echo "Extracting email addresses:"
email_regex='[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
while IFS= read -r line; do
    if [[ $line =~ $email_regex ]]; then
        echo "  Found: ${BASH_REMATCH[0]}"
    fi
done < sample.log
echo ""

# Example 4: URL validation
echo "=== Example 4: URL Validation ==="
url_pattern="^(https?|ftp)://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$"

validate_url() {
    local url=$1
    if [[ $url =~ $url_pattern ]]; then
        echo "✓ Valid URL: $url"
    else
        echo "✗ Invalid URL: $url"
    fi
}

validate_url "https://example.com"
validate_url "http://sub.domain.com/path/to/resource"
validate_url "ftp://files.company.com"
validate_url "not-a-url"
echo ""

# Example 5: Extract version numbers
echo "=== Example 5: Version Extraction ==="
version_pattern="v?([0-9]+)\.([0-9]+)\.([0-9]+)"

text="Deploying version v1.2.3 to production"
if [[ $text =~ $version_pattern ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"
    echo "Major: ${BASH_REMATCH[1]}"
    echo "Minor: ${BASH_REMATCH[2]}"
    echo "Patch: ${BASH_REMATCH[3]}"
fi
echo ""

echo "======================================="
echo "Regex demo complete!"
