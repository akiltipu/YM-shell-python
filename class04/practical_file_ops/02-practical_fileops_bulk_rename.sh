#!/bin/bash

# Practical Example 2: Bulk File Renaming

echo "=== Bulk File Renaming ==="
echo ""

# Create test files
TEST_DIR="/tmp/rename_demo"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create sample files
for i in {1..5}; do
    touch "IMG_${i}.jpg"
    touch "document ${i}.txt"
done

echo "Original files:"
ls -1
echo ""

# Rename with pattern
echo "1. Remove spaces from filenames:"
echo "────────────────────────────────"
for file in *\ *; do
    newname=$(echo "$file" | tr ' ' '_')
    mv "$file" "$newname"
    echo "  $file -> $newname"
done
echo ""

echo "2. Add prefix to files:"
echo "───────────────────────"
for file in IMG_*.jpg; do
    newname="photo_${file}"
    mv "$file" "$newname"
    echo "  $file -> $newname"
done
echo ""

echo "Final result:"
ls -1
echo ""

# Cleanup
cd - > /dev/null
rm -rf "$TEST_DIR"

echo "Use patterns and loops for bulk file operations"
