#!/bin/bash
# Advanced Navigation Utilities

# Save current directory
save_dir() {
    export SAVED_DIR=$(pwd)
    echo "Saved: $SAVED_DIR"
}

# Return to saved directory
back() {
    if [ -n "$SAVED_DIR" ]; then
        cd "$SAVED_DIR" || return 1
        echo "Returned to: $(pwd)"
    else
        echo "No saved directory"
        return 1
    fi
}

# Navigate up N directories
up() {
    local levels=${1:-1}
    local path=""
    
    for ((i=0; i<levels; i++)); do
        path="../$path"
    done
    
    cd "$path" || return 1
    echo "Current directory: $(pwd)"
}

# Find and navigate to directory
goto() {
    local target=$1
    
    if [ -z "$target" ]; then
        echo "Usage: goto <directory_name>"
        return 1
    fi
    
    # Search in current directory tree
    local found=$(find . -type d -name "$target" -print -quit 2>/dev/null)
    
    if [ -n "$found" ]; then
        cd "$found" || return 1
        echo "Navigated to: $(pwd)"
    else
        echo "Directory not found: $target"
        return 1
    fi
}

# List recent directories
recent_dirs() {
    echo "Recent directories:"
    dirs -v | head -10
}

# Interactive directory chooser
choose_dir() {
    local dirs_array=($(find . -maxdepth 3 -type d | sort))
    local count=${#dirs_array[@]}
    
    if [ $count -eq 0 ]; then
        echo "No directories found"
        return 1
    fi
    
    echo "Available directories:"
    for i in "${!dirs_array[@]}"; do
        echo "  $((i+1)). ${dirs_array[$i]}"
        if [ $i -ge 19 ]; then
            echo "  ... (showing first 20)"
            break
        fi
    done
    
    read -p "Choose directory (1-$count): " choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$count" ]; then
        local target="${dirs_array[$((choice-1))]}"
        cd "$target" || return 1
        echo "Current directory: $(pwd)"
    else
        echo "Invalid choice"
        return 1
    fi
}

# Demo usage
echo "======================================="
echo "    NAVIGATION UTILITIES DEMO"
echo "======================================="
echo ""

# Create test structure
mkdir -p demo/{project1/{src,tests},project2/{lib,docs}}
cd demo || exit

echo "=== Current Location ==="
pwd
echo ""

echo "=== Save Current Directory ==="
save_dir
echo ""

echo "=== Navigate to project1/src ==="
cd project1/src
pwd
echo ""

echo "=== Go up 2 levels ==="
up 2
echo ""

echo "=== Return to Saved Directory ==="
back
echo ""

echo "=== Find and Go to 'docs' ==="
goto docs
echo ""

# Cleanup
cd ../..
rm -rf demo

echo ""
echo "======================================="
echo "Demo complete!"
echo ""
echo "Available functions:"
echo "  save_dir    - Save current directory"
echo "  back        - Return to saved directory"
echo "  up [N]      - Go up N directories"
echo "  goto <name> - Find and navigate to directory"
echo "  recent_dirs - List recent directories"
echo "  choose_dir  - Interactive directory chooser"
