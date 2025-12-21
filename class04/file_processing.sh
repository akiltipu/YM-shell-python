#!/bin/bash
# Advanced File Processing

echo "======================================="
echo "    ADVANCED FILE PROCESSING"
echo "======================================="
echo ""

# Create sample data
cat > data.csv << 'EOF'
Name,Age,Department,Salary
John Doe,30,Engineering,75000
Jane Smith,28,Marketing,65000
Bob Johnson,35,Engineering,85000
Alice Williams,32,Sales,70000
Charlie Brown,29,Engineering,72000
EOF

echo "=== Sample Data Created ==="
cat data.csv
echo ""

# Example 1: Extract specific columns
echo "=== Example 1: Extract Names and Departments ==="
awk -F',' 'NR>1 {print $1 " - " $3}' data.csv
echo ""

# Example 2: Filter by condition
echo "=== Example 2: Engineers Only ==="
awk -F',' 'NR>1 && $3=="Engineering" {print $1 " ($" $4 ")"}' data.csv
echo ""

# Example 3: Calculate statistics
echo "=== Example 3: Salary Statistics ==="
awk -F',' '
    NR>1 {
        sum += $4
        count++
        if ($4 > max) max = $4
        if (min == 0 || $4 < min) min = $4
    }
    END {
        print "Average: $" sum/count
        print "Minimum: $" min
        print "Maximum: $" max
    }
' data.csv
echo ""

# Example 4: File transformation
echo "=== Example 4: Convert to JSON ==="
cat > convert_to_json.sh << 'SCRIPT'
#!/bin/bash
echo "["
awk -F',' '
    NR>1 {
        if (NR>2) print ","
        printf "  {\n"
        printf "    \"name\": \"%s\",\n", $1
        printf "    \"age\": %s,\n", $2
        printf "    \"department\": \"%s\",\n", $3
        printf "    \"salary\": %s\n", $4
        printf "  }"
    }
' data.csv
echo ""
echo "]"
SCRIPT

chmod +x convert_to_json.sh
./convert_to_json.sh > data.json

echo "JSON created:"
cat data.json
echo ""

# Example 5: Merge files
echo "=== Example 5: File Merging ==="
cat > file1.txt << 'EOF'
Line 1 from file1
Line 2 from file1
EOF

cat > file2.txt << 'EOF'
Line 1 from file2
Line 2 from file2
EOF

echo "Merging files side by side:"
paste file1.txt file2.txt
echo ""

# Example 6: Split files
echo "=== Example 6: File Splitting ==="
cat > large_file.txt << 'EOF'
Line 1
Line 2
Line 3
Line 4
Line 5
Line 6
EOF

echo "Splitting into 2-line chunks:"
split -l 2 large_file.txt chunk_
ls -l chunk_*
echo ""

# Cleanup
rm -f data.csv data.json convert_to_json.sh
rm -f file1.txt file2.txt large_file.txt chunk_*

echo "======================================="
echo "Demo complete!"
