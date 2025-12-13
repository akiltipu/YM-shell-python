#!/bin/bash

# Practical Example 5: Configuration File Parsing
# Extract configuration values using regex patterns

echo "=== Configuration Parsing with Regex ==="
echo ""

# Create sample config file
cat > /tmp/app.conf << 'EOF'
# Application Configuration
app.name=MyApplication
app.version=1.2.3
app.port=8080

# Database Settings
db.host=localhost
db.port=5432
db.name=production_db
db.user=admin
db.password=secret123

# Feature Flags
feature.auth.enabled=true
feature.cache.enabled=false
feature.logging.level=INFO

# URLs
api.base.url=https://api.example.com/v1
cdn.url=https://cdn.example.com

# Numeric Settings
max.connections=100
timeout.seconds=30
retry.attempts=3
EOF

echo "Sample configuration file:"
head -n 15 /tmp/app.conf
echo "..."
echo ""

# Extract all key-value pairs
echo "1. Extract all key-value pairs:"
echo "────────────────────────────────"
grep -E '^[a-z.]+=.+' /tmp/app.conf
echo ""

# Extract specific configuration section
echo "2. Extract database configuration:"
echo "───────────────────────────────────"
grep -E '^db\.' /tmp/app.conf
echo ""

# Extract configuration by pattern
echo "3. Extract feature flags:"
echo "─────────────────────────"
grep -E '^feature\..+=(true|false)' /tmp/app.conf
echo ""

# Extract URLs from config
echo "4. Extract all URLs:"
echo "────────────────────"
grep -oE 'https?://[a-zA-Z0-9./?=_-]+' /tmp/app.conf
echo ""

# Extract numeric values
echo "5. Extract numeric configuration:"
echo "──────────────────────────────────"
grep -E '=[0-9]+$' /tmp/app.conf
echo ""

# Parse and validate port numbers
echo "6. Extract and validate port numbers:"
echo "──────────────────────────────────────"

while IFS='=' read -r key value; do
    if [[ $key =~ \.port$ ]] && [[ $value =~ ^[0-9]+$ ]]; then
        if [ "$value" -ge 1 ] && [ "$value" -le 65535 ]; then
            echo "✓ $key=$value (valid port)"
        else
            echo "✗ $key=$value (invalid port range)"
        fi
    fi
done < <(grep -E '^[a-z.]+=[0-9]+$' /tmp/app.conf)
echo ""

# Extract version numbers
echo "7. Extract version numbers:"
echo "───────────────────────────"
grep -oE '[0-9]+\.[0-9]+\.[0-9]+' /tmp/app.conf
echo ""

# Convert config to environment variables
echo "8. Convert to environment variables:"
echo "─────────────────────────────────────"
grep -E '^[a-z.]+=.+' /tmp/app.conf | \
    sed 's/\./_/g' | \
    tr '[:lower:]' '[:upper:]' | \
    head -n 5
echo "..."
echo ""

# Group configuration by prefix
echo "9. Group by configuration prefix:"
echo "──────────────────────────────────"
grep -E '^[a-z.]+=.+' /tmp/app.conf | \
    awk -F'[.=]' '{print $1}' | \
    sort -u | \
    while read prefix; do
        count=$(grep -c "^$prefix\." /tmp/app.conf)
        echo "$prefix: $count settings"
    done
echo ""

echo "💡 Config parsing patterns:"
echo "   - Key-value: ^[a-z.]+="
echo "   - Section prefix: ^db\."
echo "   - Boolean: =(true|false)$"
echo "   - Numeric: =[0-9]+$"
echo "   - Version: [0-9]+\.[0-9]+\.[0-9]+"

rm -f /tmp/app.conf
