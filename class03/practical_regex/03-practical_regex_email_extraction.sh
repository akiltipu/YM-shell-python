#!/bin/bash

# Practical Example 3: Email Extraction and Validation
# Extract and validate email addresses from text

echo "=== Email Extraction with Regex ==="
echo ""

# Sample data with emails
cat > /tmp/contacts.txt << 'EOF'
Contact us at support@example.com for help.
Sales team: sales@company.org
Development: dev-team@tech-startup.io
Invalid emails: user@, @domain.com, user@domain
CEO: john.doe+ceo@corporate.net
Marketing: info@sub.domain.company.com
EOF

echo "Sample text file:"
cat /tmp/contacts.txt
echo ""

# Extract all email addresses
echo "1. Extract all email addresses:"
echo "────────────────────────────────"
grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' /tmp/contacts.txt
echo ""

# Validate email format
echo "2. Validate email addresses:"
echo "────────────────────────────"

validate_email() {
    local email=$1
    
    # More strict email validation
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        # Check for valid structure
        if [[ $email =~ @.*@ ]]; then
            echo "✗ $email (multiple @ symbols)"
            return 1
        fi
        
        if [[ $email =~ \.\. ]]; then
            echo "✗ $email (consecutive dots)"
            return 1
        fi
        
        echo "✓ $email (valid)"
        return 0
    else
        echo "✗ $email (invalid format)"
        return 1
    fi
}

# Test various emails
test_emails=(
    "user@example.com"
    "first.last@company.org"
    "user+tag@domain.co.uk"
    "invalid@"
    "@invalid.com"
    "user@@domain.com"
)

for email in "${test_emails[@]}"; do
    validate_email "$email"
done
echo ""

# Extract email domains
echo "3. Extract unique email domains:"
echo "────────────────────────────────"
grep -oE '@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' /tmp/contacts.txt | \
    sed 's/@//' | sort -u
echo ""

# Group emails by domain
echo "4. Group emails by domain:"
echo "──────────────────────────"
grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' /tmp/contacts.txt | \
    awk -F'@' '{print $2": "$1}' | sort
echo ""

echo "💡 Email regex patterns:"
echo "   - Basic: [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
echo "   - Supports: plus addressing, subdomains, hyphens"
echo "   - Validates: @ symbol, domain structure, TLD"

rm -f /tmp/contacts.txt
