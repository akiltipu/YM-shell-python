#!/bin/bash

# Practical Example 6: Data Cleaning with Regex
# Clean and normalize data using regex patterns

echo "=== Data Cleaning with Regex ==="
echo ""

# Sample messy data
cat > /tmp/messy_data.txt << 'EOF'
User: john.doe@example.com   Phone: (555) 123-4567
User: jane_smith@company.org Phone: 555.987.6543  
User:bob+test@domain.com     Phone:5551234567
User:  alice@example.com     Phone: 555-111-2222  
EOF

echo "Original messy data:"
cat /tmp/messy_data.txt
echo ""

# Remove extra whitespace
echo "1. Remove extra whitespace:"
echo "───────────────────────────"
sed 's/  */ /g' /tmp/messy_data.txt | sed 's/^ *//;s/ *$//'
echo ""

# Normalize phone numbers
echo "2. Normalize phone numbers to XXX-XXX-XXXX:"
echo "────────────────────────────────────────────"

normalize_phone() {
    # Remove all non-digits
    local clean=$(echo "$1" | sed 's/[^0-9]//g')
    
    # Format as XXX-XXX-XXXX
    if [ ${#clean} -eq 10 ]; then
        echo "${clean:0:3}-${clean:3:3}-${clean:6:4}"
    else
        echo "Invalid: $1"
    fi
}

while IFS= read -r line; do
    if [[ $line =~ Phone:\ *(.+)$ ]]; then
        phone="${BASH_REMATCH[1]}"
        normalized=$(normalize_phone "$phone")
        echo "Original: $phone → Normalized: $normalized"
    fi
done < /tmp/messy_data.txt
echo ""

# Clean email addresses
echo "3. Extract and clean email addresses:"
echo "──────────────────────────────────────"
grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' /tmp/messy_data.txt | \
    tr '[:upper:]' '[:lower:]'
echo ""

# Remove special characters from usernames
echo "4. Clean usernames (remove + suffixes):"
echo "────────────────────────────────────────"
grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' /tmp/messy_data.txt | \
    sed 's/+[^@]*@/@/'
echo ""

# Sample CSV data with issues
cat > /tmp/messy_csv.txt << 'EOF'
Name,Email,Phone,Age
John  Doe,john@example.com,(555) 123-4567,30
Jane Smith  ,jane@company.org,555.987.6543  ,25
Bob   Wilson,bob@domain.com,555-111-2222,  35  
EOF

echo "5. Clean CSV data:"
echo "──────────────────"
echo "Original:"
cat /tmp/messy_csv.txt
echo ""
echo "Cleaned:"
# Remove extra spaces, trim whitespace
sed 's/  */ /g' /tmp/messy_csv.txt | sed 's/ *,/,/g;s/, */,/g;s/^ *//;s/ *$//'
echo ""

# Remove HTML tags
cat > /tmp/html_data.txt << 'EOF'
<div>Hello World</div>
<p>This is a <strong>test</strong> message.</p>
<a href="http://example.com">Link</a>
EOF

echo "6. Strip HTML tags:"
echo "───────────────────"
echo "Original:"
cat /tmp/html_data.txt
echo ""
echo "Cleaned:"
sed 's/<[^>]*>//g' /tmp/html_data.txt
echo ""

# Normalize dates
echo "7. Normalize date formats:"
echo "──────────────────────────"

cat > /tmp/dates.txt << 'EOF'
2024-12-01
12/01/2024
01-Dec-2024
2024.12.01
EOF

echo "Various date formats:"
cat /tmp/dates.txt
echo ""
echo "Converting to YYYY-MM-DD:"
while IFS= read -r date; do
    if [[ $date =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})$ ]]; then
        echo "$date (already normalized)"
    elif [[ $date =~ ^([0-9]{2})/([0-9]{2})/([0-9]{4})$ ]]; then
        echo "${BASH_REMATCH[3]}-${BASH_REMATCH[1]}-${BASH_REMATCH[2]}"
    elif [[ $date =~ ^([0-9]{4})\.([0-9]{2})\.([0-9]{2})$ ]]; then
        echo "${BASH_REMATCH[1]}-${BASH_REMATCH[2]}-${BASH_REMATCH[3]}"
    else
        echo "$date (format not recognized)"
    fi
done < /tmp/dates.txt
echo ""

echo "💡 Data cleaning techniques:"
echo "   - Remove whitespace: s/  */ /g"
echo "   - Strip HTML: s/<[^>]*>//g"
echo "   - Extract digits: s/[^0-9]//g"
echo "   - Lowercase: tr '[:upper:]' '[:lower:]'"
echo "   - Format normalization with capturing groups"

rm -f /tmp/messy_data.txt /tmp/messy_csv.txt /tmp/html_data.txt /tmp/dates.txt
