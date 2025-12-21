#!/bin/bash

# Practical Example 3: Find and Process Files

echo "=== Find and Process Files ==="
echo ""

# Create test structure
TEST_DIR="/tmp/find_demo"
mkdir -p "$TEST_DIR"/{logs,configs,data}
cd "$TEST_DIR"

# Create sample files
echo "error: something failed" > logs/app.log
echo "warning: high memory" > logs/system.log
touch configs/app.conf
touch configs/db.conf
touch data/file1.dat
touch data/file2.dat

# Make some files old
touch -t 202301010000 logs/app.log

echo "Test structure created"
echo ""

echo "1. Find files by extension:"
echo "───────────────────────────"
find . -name "*.log"
echo ""

echo "2. Find files modified in last day:"
echo "────────────────────────────────────"
find . -type f -mtime -1
echo ""

echo "3. Find and process (count lines):"
echo "───────────────────────────────────"
find . -name "*.log" -exec wc -l {} \;
echo ""

echo "4. Find files with specific content:"
echo "─────────────────────────────────────"
grep -r "error" . --include="*.log"
echo ""

# Cleanup
cd - > /dev/null
rm -rf "$TEST_DIR"

echo "find command is powerful for file discovery and batch processing"
