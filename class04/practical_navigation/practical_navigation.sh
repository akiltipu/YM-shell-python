#!/bin/bash

# Comprehensive Practical Navigation Examples

echo "========================================"
echo "  Practical Navigation Examples"
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
echo "  Navigation Examples Complete"
echo "========================================"
