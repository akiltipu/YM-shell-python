#!/bin/bash

# Practical Example 1: Safe File Operations

echo "=== Safe File Operations ==="
echo ""

# Create test environment
TEST_DIR="/tmp/fileops_demo"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Function: Safe file copy with backup
safe_copy() {
    local src=$1
    local dest=$2
    
    if [ ! -f "$src" ]; then
        echo "Source file not found: $src"
        return 1
    fi
    
    if [ -f "$dest" ]; then
        local backup="${dest}.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$dest" "$backup"
        echo "Created backup: $backup"
    fi
    
    cp "$src" "$dest"
    echo "Copied: $src -> $dest"
}

# Function: Safe file move
safe_move() {
    local src=$1
    local dest=$2
    
    if [ ! -e "$src" ]; then
        echo "Source not found: $src"
        return 1
    fi
    
    if [ -e "$dest" ]; then
        read -p "Destination exists. Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Move cancelled"
            return 1
        fi
    fi
    
    mv "$src" "$dest"
    echo "Moved: $src -> $dest"
}

echo "1. Safe copy with backup:"
echo "─────────────────────────"
echo "Original content" > file1.txt
echo "New content" > file2.txt
safe_copy file2.txt file1.txt
echo ""

echo "2. Verifying backup:"
echo "────────────────────"
ls -la file1.txt*
echo ""

# Cleanup
cd - > /dev/null
rm -rf "$TEST_DIR"

echo "Always create backups for important file operations"
