#!/bin/bash

# Practical Example 2: Color and Formatting Utilities

echo "=== Color and Formatting Utilities ==="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Formatting utilities
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_header() {
    echo -e "${CYAN}"
    echo "═══════════════════════════════════════"
    echo "  $1"
    echo "═══════════════════════════════════════"
    echo -e "${NC}"
}

# Progress bar
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percent=$((current * 100 / total))
    local filled=$((width * current / total))
    
    printf "\rProgress: ["
    printf "%${filled}s" | tr ' ' '='
    printf "%$((width - filled))s" | tr ' ' ' '
    printf "] %d%%" "$percent"
}

echo "1. Status messages:"
echo "───────────────────"
print_success "Operation completed"
print_error "Operation failed"
print_warning "Proceeding with caution"
print_info "Additional information"
echo ""

echo "2. Formatted headers:"
print_header "System Report"
echo ""

echo "3. Progress bar demo:"
echo "─────────────────────"
for i in $(seq 1 100); do
    show_progress $i 100
    sleep 0.02
done
echo ""
echo ""

echo "Formatting utilities improve script readability"
