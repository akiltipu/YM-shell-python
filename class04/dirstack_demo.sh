#!/bin/bash
# Directory Stack Management Demonstration

echo "======================================="
echo "    DIRECTORY STACK MANAGEMENT"
echo "======================================="
echo ""

# Display current location and stack
show_stack() {
    echo "Current directory: $(pwd)"
    echo "Directory stack:"
    dirs -v
    echo ""
}

# Initial state
echo "=== Initial State ==="
show_stack

# Create test directories
echo "=== Creating Test Directories ==="
mkdir -p test_project/{src,docs,tests,config}
echo "Created: test_project/{src,docs,tests,config}"
echo ""

# Navigate using pushd
echo "=== Using pushd to Navigate ==="
echo "Pushing test_project/src..."
pushd test_project/src > /dev/null
show_stack

echo "Pushing ../docs..."
pushd ../docs > /dev/null
show_stack

echo "Pushing ../tests..."
pushd ../tests > /dev/null
show_stack

# Display numbered stack
echo "=== Numbered Stack Display ==="
dirs -v
echo ""

# Jump to specific directory in stack
echo "=== Jump to Directory 2 ==="
pushd +2 > /dev/null
show_stack

# Pop directories
echo "=== Using popd ==="
echo "Popping..."
popd > /dev/null
show_stack

echo "Popping again..."
popd > /dev/null
show_stack

# Clear stack
echo "=== Clear Stack ==="
dirs -c
show_stack

# Cleanup
echo "=== Cleanup ==="
cd ..
rm -rf test_project
echo "Test directories removed"
echo ""

echo "======================================="
echo "Demo complete!"
