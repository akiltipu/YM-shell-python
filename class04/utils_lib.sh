#!/bin/bash
# Utility Function Library

# Text formatting
print_header() {
    local text=$1
    local width=50
    
    echo ""
    printf '=%.0s' $(seq 1 $width)
    echo ""
    printf "%*s\n" $(((${#text}+$width)/2)) "$text"
    printf '=%.0s' $(seq 1 $width)
    echo ""
}

print_success() {
    echo -e "\033[0;32m✓ $1\033[0m"
}

print_error() {
    echo -e "\033[0;31m✗ $1\033[0m" >&2
}

print_warning() {
    echo -e "\033[0;33m⚠ $1\033[0m"
}

print_info() {
    echo -e "\033[0;36mℹ $1\033[0m"
}

# Confirmation prompts
confirm() {
    local prompt="${1:-Are you sure?}"
    local default="${2:-n}"
    
    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi
    
    read -p "$prompt" response
    response=${response:-$default}
    
    [[ "$response" =~ ^[Yy]$ ]]
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    
    printf "\rProgress: ["
    printf "%${filled}s" | tr ' ' '='
    printf "%$((width-filled))s" | tr ' ' ' '
    printf "] %3d%%" $percentage
    
    if [ $current -eq $total ]; then
        echo ""
    fi
}

# Spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    while ps -p $pid > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Retry logic
retry() {
    local max_attempts=$1
    shift
    local cmd="$@"
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "Attempt $attempt of $max_attempts: $cmd"
        
        if eval "$cmd"; then
            print_success "Command succeeded"
            return 0
        fi
        
        if [ $attempt -lt $max_attempts ]; then
            print_warning "Command failed, retrying..."
            sleep 2
        fi
        
        ((attempt++))
    done
    
    print_error "Command failed after $max_attempts attempts"
    return 1
}

# Validate input
validate_number() {
    local input=$1
    [[ "$input" =~ ^[0-9]+$ ]]
}

validate_email() {
    local email=$1
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

validate_ip() {
    local ip=$1
    [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
}

# String utilities
to_uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

trim() {
    echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Array utilities
array_contains() {
    local seeking=$1
    shift
    local array=("$@")
    
    for element in "${array[@]}"; do
        if [ "$element" = "$seeking" ]; then
            return 0
        fi
    done
    return 1
}

# Demo usage
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    print_header "UTILITY LIBRARY DEMO"
    
    print_success "This is a success message"
    print_error "This is an error message"
    print_warning "This is a warning message"
    print_info "This is an info message"
    echo ""
    
    print_header "Progress Bar"
    for i in $(seq 1 10); do
        progress_bar $i 10
        sleep 0.2
    done
    echo ""
    
    print_header "Input Validation"
    validate_number 123 && print_success "123 is a number" || print_error "Invalid"
    validate_email "user@example.com" && print_success "Valid email" || print_error "Invalid"
    validate_ip "192.168.1.1" && print_success "Valid IP" || print_error "Invalid"
    echo ""
    
    print_header "String Utilities"
    echo "Uppercase: $(to_uppercase 'hello world')"
    echo "Lowercase: $(to_lowercase 'HELLO WORLD')"
    echo "Trimmed: '$(trim '  hello  ')'"
    echo ""
    
    print_header "Array Utilities"
    fruits=("apple" "banana" "cherry")
    array_contains "banana" "${fruits[@]}" && print_success "Found banana" || print_error "Not found"
    array_contains "grape" "${fruits[@]}" && print_success "Found grape" || print_error "Not found"
    
    print_header "Demo Complete"
fi
