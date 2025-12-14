#!/bin/bash

# Comprehensive Practical Utilities Examples

echo "========================================"
echo "  Practical Utilities"
echo "========================================"
echo ""

for script in 01-*.sh 02-*.sh 03-*.sh; do
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
echo "  Utilities Examples Complete"
echo "========================================"
