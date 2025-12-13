#!/bin/bash

# Comprehensive Practical Regex Examples
# All regex patterns in one file for reference

echo "========================================"
echo "  Practical Regex Examples"
echo "========================================"
echo ""

# Run all examples
for script in 01-*.sh 02-*.sh 03-*.sh 04-*.sh 05-*.sh 06-*.sh 07-*.sh; do
    if [ -f "$script" ]; then
        echo ""
        echo "════════════════════════════════════════"
        echo "Running: $script"
        echo "════════════════════════════════════════"
        bash "$script"
    fi
done

echo ""
echo "========================================"
echo "  All Regex Examples Complete"
echo "========================================"
