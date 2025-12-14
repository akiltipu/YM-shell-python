#!/bin/bash

# Comprehensive Practical File Operations Examples

echo "========================================"
echo "  Practical File Operations"
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
echo "  File Operations Complete"
echo "========================================"
