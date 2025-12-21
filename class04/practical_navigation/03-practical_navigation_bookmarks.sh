#!/bin/bash

# Practical Example 3: Bookmark System for Frequent Locations

echo "=== Directory Bookmark System ==="
echo ""

# Bookmark file
BOOKMARK_FILE="/tmp/dir_bookmarks.txt"
touch "$BOOKMARK_FILE"

# Function: Save bookmark
bookmark_save() {
    local name=$1
    local path=${2:-$PWD}
    echo "$name=$path" >> "$BOOKMARK_FILE"
    echo "Saved bookmark: $name -> $path"
}

# Function: Go to bookmark
bookmark_go() {
    local name=$1
    local path=$(grep "^$name=" "$BOOKMARK_FILE" | cut -d'=' -f2 | tail -n1)
    if [ -n "$path" ] && [ -d "$path" ]; then
        cd "$path"
        echo "Jumped to: $path"
    else
        echo "✗ Bookmark not found: $name"
    fi
}

# Function: List bookmarks
bookmark_list() {
    echo "Saved bookmarks:"
    if [ -s "$BOOKMARK_FILE" ]; then
        cat "$BOOKMARK_FILE" | nl
    else
        echo "  (none)"
    fi
}

echo "1. Saving bookmarks:"
echo "────────────────────"
bookmark_save "home" "$HOME"
bookmark_save "tmp" "/tmp"
bookmark_save "etc" "/etc"
echo ""

echo "2. Listing bookmarks:"
echo "─────────────────────"
bookmark_list
echo ""

echo "3. Using bookmarks:"
echo "───────────────────"
bookmark_go "tmp"
echo "Current directory: $(pwd)"
echo ""

# Cleanup
rm -f "$BOOKMARK_FILE"

echo "Bookmarks save time navigating to frequent locations"
