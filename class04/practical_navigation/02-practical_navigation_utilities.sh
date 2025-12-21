#!/bin/bash

# Practical Example 2: Smart Navigation Utilities

echo "=== Smart Navigation Utilities ==="
echo ""

# Create test directory structure
TEST_DIR="/tmp/nav_demo"
mkdir -p "$TEST_DIR"/{project1,project2,project3}/{src,tests,docs}
mkdir -p "$TEST_DIR"/project1/src/{components,utils}

echo "Created test directory structure at $TEST_DIR"
echo ""

# Function: Jump to project root
find_project_root() {
    local current="$PWD"
    while [ "$current" != "/" ]; do
        if [ -f "$current/.git/config" ] || [ -f "$current/package.json" ] || [ -f "$current/README.md" ]; then
            echo "$current"
            return 0
        fi
        current=$(dirname "$current")
    done
    return 1
}

# Function: Quick jump to common directories
qj() {
    case $1 in
        src) cd */src 2>/dev/null || echo "No src directory found" ;;
        test|tests) cd */test* 2>/dev/null || echo "No test directory found" ;;
        docs) cd */docs 2>/dev/null || echo "No docs directory found" ;;
        *) echo "Unknown quick jump: $1" ;;
    esac
}

# Function: List all subdirectories
list_dirs() {
    local depth=${1:-1}
    echo "Directories (depth $depth):"
    find . -maxdepth "$depth" -type d | sed 's|^\./||' | sort
}

echo "1. Navigation from deep nested location:"
echo "─────────────────────────────────────────"
cd "$TEST_DIR/project1/src/components"
echo "Current: $(pwd)"
if root=$(find_project_root); then
    echo "Project root: $root"
fi
echo ""

echo "2. Quick directory listing:"
echo "───────────────────────────"
cd "$TEST_DIR"
list_dirs 2
echo ""

# Cleanup
rm -rf "$TEST_DIR"

echo "Custom navigation functions boost productivity"
