#!/bin/bash

# Practical Example 1: Reusable Utility Library

echo "=== Reusable Utility Functions ==="
echo ""

# String utilities
string_to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

string_to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

string_trim() {
    echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Validation utilities
is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}

is_email() {
    [[ $1 =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# File utilities
get_file_extension() {
    echo "${1##*.}"
}

get_file_name() {
    basename "$1" .${1##*.}
}

echo "1. String utilities:"
echo "────────────────────"
echo "Upper: $(string_to_upper 'hello world')"
echo "Lower: $(string_to_lower 'HELLO WORLD')"
echo "Trim: '$(string_trim '  spaced  ')'"
echo ""

echo "2. Validation utilities:"
echo "────────────────────────"
test_num="123"
test_email="user@example.com"
is_number "$test_num" && echo "$test_num is a number"
is_email "$test_email" && echo "$test_email is valid email"
echo ""

echo "3. File utilities:"
echo "──────────────────"
file="document.pdf"
echo "Extension: $(get_file_extension "$file")"
echo "Name: $(get_file_name "$file")"
echo ""

echo "Build a library of reusable functions for common tasks"
