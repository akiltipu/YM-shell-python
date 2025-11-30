#!/bin/bash
# File and Directory Operations Demo

echo "======================================="
echo "    FILE & DIRECTORY OPERATIONS"
echo "======================================="
echo ""

# ===== 1. CREATING FILES =====
echo "=== 1. Creating Files ==="

# Create simple file
touch demo_file.txt
echo "Created: demo_file.txt"

# Create with content
echo "Hello, World!" > greeting.txt
echo "Created greeting.txt with content"

# Create multiple lines
cat > config.txt << EOF
server=localhost
port=8080
timeout=30
EOF
echo "Created config.txt with multiple lines"

# List created files
ls -lh demo_file.txt greeting.txt config.txt
echo ""

# ===== 2. READING FILES =====
echo "=== 2. Reading Files ==="

# Method 1: cat (entire file)
echo "Method 1 - cat:"
cat greeting.txt
echo ""

# Method 2: Read line by line
echo "Method 2 - Line by line:"
while IFS= read -r line; do
    echo "  Line: $line"
done < config.txt
echo ""

# Method 3: Read into array
echo "Method 3 - Into array:"
mapfile -t lines < config.txt
echo "  Total lines: ${#lines[@]}"
for i in "${!lines[@]}"; do
    echo "  [$i] ${lines[$i]}"
done
echo ""

# ===== 3. WRITING TO FILES =====
echo "=== 3. Writing to Files ==="

# Overwrite file
echo "First line" > output.txt
echo "Created output.txt"

# Append to file
echo "Second line" >> output.txt
echo "Third line" >> output.txt
echo "Appended lines to output.txt"

# Display result
echo "Contents:"
cat output.txt
echo ""

# ===== 4. FILE INFORMATION =====
echo "=== 4. File Information ==="

test_file="greeting.txt"

if [ -f "$test_file" ]; then
    echo "File: $test_file"
    echo "  Size: $(stat -f%z "$test_file" 2>/dev/null || stat -c%s "$test_file" 2>/dev/null) bytes"
    echo "  Permissions: $(stat -f%Sp "$test_file" 2>/dev/null || stat -c%A "$test_file" 2>/dev/null)"
    echo "  Owner: $(stat -f%Su "$test_file" 2>/dev/null || stat -c%U "$test_file" 2>/dev/null)"
    echo "  Modified: $(stat -f%Sm "$test_file" 2>/dev/null || stat -c%y "$test_file" 2>/dev/null)"
fi
echo ""

# ===== 5. COPYING FILES =====
echo "=== 5. Copying Files ==="

# Simple copy
cp greeting.txt greeting_backup.txt
echo "Copied greeting.txt to greeting_backup.txt"

# Copy with timestamp
cp greeting.txt "greeting_$(date +%Y%m%d).txt"
echo "Created timestamped backup"

# List backups
ls -lh greeting*.txt
echo ""

# ===== 6. MOVING/RENAMING FILES =====
echo "=== 6. Moving and Renaming Files ==="

# Rename file
mv demo_file.txt renamed_demo.txt
echo "Renamed demo_file.txt to renamed_demo.txt"

# Create directory and move
mkdir -p temp_dir
mv renamed_demo.txt temp_dir/
echo "Moved renamed_demo.txt to temp_dir/"

ls -lh temp_dir/
echo ""

# ===== 7. DELETING FILES =====
echo "=== 7. Deleting Files ==="

# Delete single file
rm -f greeting_backup.txt
echo "Deleted greeting_backup.txt"

# Delete with pattern
rm -f greeting_2*.txt
echo "Deleted timestamped backups"

# Verify
echo "Remaining files:"
ls -lh *.txt 2>/dev/null || echo "  No .txt files in current directory"
echo ""

# ===== 8. DIRECTORY OPERATIONS =====
echo "=== 8. Directory Operations ==="

# Create directory
mkdir -p projects/webapp/src
echo "Created nested directories: projects/webapp/src"

# Create multiple directories
mkdir -p backup logs data
echo "Created multiple directories"

# List directories
echo "Directory structure:"
ls -la | grep ^d
echo ""

# ===== 9. NAVIGATING DIRECTORIES =====
echo "=== 9. Navigating Directories ==="

# Save current directory
original_dir=$(pwd)
echo "Current directory: $original_dir"

# Change to temp directory
cd temp_dir
echo "Changed to: $(pwd)"

# Go back
cd ..
echo "Back to: $(pwd)"

# Go to home
cd ~
echo "Home directory: $(pwd)"

# Return to original
cd "$original_dir"
echo "Returned to: $(pwd)"
echo ""

# ===== 10. DIRECTORY INFORMATION =====
echo "=== 10. Directory Information ==="

echo "Current directory info:"
echo "  Path: $(pwd)"
echo "  Files: $(find . -maxdepth 1 -type f | wc -l)"
echo "  Directories: $(find . -maxdepth 1 -type d | wc -l)"
echo "  Total size: $(du -sh . 2>/dev/null | cut -f1)"
echo ""

# ===== 11. SEARCHING FILES =====
echo "=== 11. Searching for Files ==="

# Find by name
echo "Finding .txt files:"
find . -name "*.txt" -type f

echo ""
echo "Finding directories named 'temp*':"
find . -name "temp*" -type d
echo ""

# ===== 12. FINDING WITH CONDITIONS =====
echo "=== 12. Advanced Find Operations ==="

# Create some test files
touch old_file.log
touch -t 202301010000 old_file.log  # Set old date

echo "Files modified in last hour:"
find . -name "*.txt" -type f -mmin -60

echo ""
echo "Files larger than 0 bytes:"
find . -name "*.txt" -type f -size +0c
echo ""

# ===== 13. FILE PROCESSING =====
echo "=== 13. Processing Multiple Files ==="

# Process each .txt file
for file in *.txt; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
        echo "  Lines: $(wc -l < "$file")"
        echo "  Words: $(wc -w < "$file")"
        echo "  Size: $(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null) bytes"
    fi
done
echo ""

# ===== 14. BULK OPERATIONS =====
echo "=== 14. Bulk File Operations ==="

# Create test files
for i in {1..3}; do
    echo "Test file $i" > "test_$i.txt"
done
echo "Created test files: test_1.txt, test_2.txt, test_3.txt"

# Bulk rename
for file in test_*.txt; do
    newname="${file/test/processed}"
    mv "$file" "$newname"
done
echo "Renamed test_*.txt to processed_*.txt"

# List results
ls -lh processed_*.txt
echo ""

# ===== 15. FILE PERMISSIONS =====
echo "=== 15. File Permissions ==="

# Create test file
echo "Permission test" > perm_test.txt

# Show initial permissions
echo "Initial permissions:"
ls -lh perm_test.txt

# Change permissions
chmod 644 perm_test.txt
echo "After chmod 644:"
ls -lh perm_test.txt

# Make executable
chmod +x perm_test.txt
echo "After chmod +x:"
ls -lh perm_test.txt
echo ""

# ===== 16. WORKING WITH PATHS =====
echo "=== 16. Path Operations ==="

filepath="/home/user/documents/report.pdf"

# Extract components
echo "Full path: $filepath"
echo "Filename: $(basename "$filepath")"
echo "Directory: $(dirname "$filepath")"
echo "Extension: ${filepath##*.}"
echo "Name without extension: $(basename "$filepath" .pdf)"
echo ""

# Current script location
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script directory: $script_dir"
echo ""

# ===== 17. TEMPORARY FILES =====
echo "=== 17. Working with Temporary Files ==="

# Create temp file
temp_file=$(mktemp)
echo "Created temp file: $temp_file"

# Write to temp file
echo "Temporary data" > "$temp_file"
echo "Content: $(cat "$temp_file")"

# Create temp directory
temp_dir=$(mktemp -d)
echo "Created temp directory: $temp_dir"

# Cleanup
rm "$temp_file"
rmdir "$temp_dir"
echo "Cleaned up temporary files"
echo ""

# ===== 18. FILE COMPARISONS =====
echo "=== 18. File Comparisons ==="

# Create two files
echo "Version 1" > file1.txt
echo "Version 2" > file2.txt

# Compare
if cmp -s file1.txt file2.txt; then
    echo "Files are identical"
else
    echo "Files are different"
fi

# Show differences
echo "Differences:"
diff file1.txt file2.txt || true
echo ""

# ===== 19. ARCHIVING =====
echo "=== 19. Creating Archives ==="

# Create tar archive
tar -czf backup.tar.gz *.txt
echo "Created backup.tar.gz"

# List archive contents
echo "Archive contents:"
tar -tzf backup.tar.gz | head -5

# File size
echo "Archive size: $(stat -f%z backup.tar.gz 2>/dev/null || stat -c%s backup.tar.gz 2>/dev/null) bytes"
echo ""

# ===== 20. PRACTICAL EXAMPLE - LOG ROTATION =====
echo "=== 20. Practical Example - Log Rotation ==="

log_rotation_demo() {
    local log_file="app.log"
    local max_size=1024  # 1KB
    local keep_count=3
    
    # Create dummy log
    echo "Log entry 1" > "$log_file"
    echo "Log entry 2" >> "$log_file"
    echo "Created $log_file"
    
    # Check size
    local size=$(stat -f%z "$log_file" 2>/dev/null || stat -c%s "$log_file" 2>/dev/null)
    echo "Log size: $size bytes"
    
    # Simulate rotation
    if [ $size -gt 0 ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        mv "$log_file" "${log_file}.${timestamp}"
        touch "$log_file"
        echo "Rotated log to ${log_file}.${timestamp}"
    fi
    
    # Clean old logs
    local log_count=$(ls -1 app.log.* 2>/dev/null | wc -l)
    echo "Total archived logs: $log_count"
}

log_rotation_demo
echo ""

# ===== CLEANUP =====
echo "=== Cleaning Up Demo Files ==="

# Remove demo files and directories
rm -f *.txt backup.tar.gz app.log* 2>/dev/null
rm -rf temp_dir projects backup logs data 2>/dev/null
echo "Cleanup completed"
echo ""

echo "======================================="
echo "      DEMO COMPLETED"
echo "======================================="
