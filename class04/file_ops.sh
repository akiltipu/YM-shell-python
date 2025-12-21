#!/bin/bash
# Filesystem Operations Demonstration

echo "======================================="
echo "     FILESYSTEM OPERATIONS"
echo "======================================="
echo ""

# Create test environment
TEST_DIR="file_ops_test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit

# Example 1: Bulk file creation
echo "=== Example 1: Bulk File Creation ==="
for i in {1..5}; do
    echo "Content $i" > "file_$i.txt"
done
echo "Created 5 files"
ls -l
echo ""

# Example 2: File renaming with patterns
echo "=== Example 2: Bulk Rename ==="
echo "Renaming .txt to .bak..."
for file in *.txt; do
    mv "$file" "${file%.txt}.bak"
done
ls -l
echo ""

# Example 3: File organization by extension
echo "=== Example 3: Organize by Extension ==="
# Create mixed files
touch doc1.pdf doc2.pdf image1.jpg image2.jpg script.sh

echo "Created mixed files:"
ls -l
echo ""

# Organize into directories
for ext in pdf jpg sh bak; do
    if ls *.$ext 1> /dev/null 2>&1; then
        mkdir -p "$ext"_files
        mv *.$ext "$ext"_files/
        echo "Moved .$ext files to ${ext}_files/"
    fi
done

echo ""
echo "Organized structure:"
tree . 2>/dev/null || find . -type d
echo ""

# Example 4: Find and process files
echo "=== Example 4: Find and Process ==="
# Create files with different ages
touch -t 202301010000 old_file.txt
touch recent_file.txt

echo "Finding files modified today:"
find . -type f -mtime 0 -name "*.txt"
echo ""

echo "Finding old files (modified >30 days ago):"
find . -type f -mtime +30 -name "*.txt"
echo ""

# Example 5: Safe file deletion
echo "=== Example 5: Safe Delete with Trash ==="
mkdir -p trash

safe_delete() {
    local file=$1
    if [ -f "$file" ]; then
        mv "$file" trash/
        echo "Moved to trash: $file"
    else
        echo "File not found: $file"
    fi
}

touch temp_file.txt
safe_delete temp_file.txt
echo "Trash contents:"
ls -l trash/
echo ""

# Example 6: File permissions management
echo "=== Example 6: Bulk Permission Changes ==="
touch script1.sh script2.sh script3.sh

echo "Making all .sh files executable:"
chmod +x *.sh
ls -l *.sh
echo ""

# Example 7: Duplicate file detection
echo "=== Example 7: Find Duplicates ==="
# Create duplicate
cp recent_file.txt duplicate.txt

echo "Finding files with same size:"
find . -type f -exec du -b {} \; | sort -n | uniq -d -w5
echo ""

# Cleanup
cd ..
rm -rf "$TEST_DIR"

echo "======================================="
echo "Demo complete!"
echo "Test directory cleaned up"
