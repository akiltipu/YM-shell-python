#!/bin/bash

# Practical Example 1: Directory Stack for Multi-Location Navigation

echo "=== Directory Stack Navigation Demo ==="
echo ""

echo "Current directory: $(pwd)"
echo ""

# Push directories onto the stack
echo "1. Building directory stack:"
echo "────────────────────────────"
echo "Pushing /tmp onto stack..."
pushd /tmp > /dev/null
echo "  Current: $(pwd)"
echo "  Stack: $(dirs)"

echo ""
echo "Pushing /etc onto stack..."
pushd /etc > /dev/null
echo "  Current: $(pwd)"
echo "  Stack: $(dirs)"

echo ""
echo "Pushing /var onto stack..."
pushd /var > /dev/null
echo "  Current: $(pwd)"
echo "  Stack: $(dirs)"
echo ""

# Navigate the stack
echo "2. Navigating the stack:"
echo "────────────────────────"
echo "Popping back (popd)..."
popd > /dev/null
echo "  Current: $(pwd)"
echo "  Stack: $(dirs)"

echo ""
echo "Rotating stack forward (pushd +1)..."
pushd +1 > /dev/null
echo "  Current: $(pwd)"
echo "  Stack: $(dirs)"
echo ""

# Show stack manipulation
echo "3. Stack listing:"
echo "─────────────────"
dirs -v
echo ""

# Clear stack
echo "4. Clearing stack..."
while popd > /dev/null 2>&1; do :; done
echo "  Returned to: $(pwd)"
echo ""

echo "Directory stack is perfect for multi-location workflows"
