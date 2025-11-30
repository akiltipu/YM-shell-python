#!/bin/bash
#
# Example 6: Deployment Functions Demo
# Demonstrates: Prerequisites checking, file downloads, checksum validation
#

set -euo pipefail

echo "======================================="
echo "  DEPLOYMENT FUNCTIONS DEMO"
echo "======================================="
echo ""

log_info() {
    echo "[INFO] $*"
}

log_success() {
    echo "[SUCCESS] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_debug() {
    echo "[DEBUG] $*"
}

log_warn() {
    echo "[WARN] $*"
}

#==========================================
# DEPLOYMENT FUNCTIONS
#==========================================

check_prerequisites() {
    local -a required_commands=("$@")
    local missing=()
    
    log_info "Checking prerequisites..."
    
    for cmd in "${required_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            log_debug "  ✓ $cmd: found"
        else
            log_warn "  ✗ $cmd: not found"
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required commands: ${missing[*]}"
        return 1
    fi
    
    log_success "All prerequisites satisfied"
    return 0
}

download_file() {
    local url=$1
    local destination=$2
    local max_retries=${3:-3}
    local attempt=1
    
    while [ $attempt -le $max_retries ]; do
        log_info "Downloading (attempt $attempt/$max_retries)..."
        log_debug "  URL: $url"
        log_debug "  Destination: $destination"
        
        if command -v curl &> /dev/null; then
            if curl -fsSL -o "$destination" "$url"; then
                log_success "Download completed"
                return 0
            fi
        elif command -v wget &> /dev/null; then
            if wget -q -O "$destination" "$url"; then
                log_success "Download completed"
                return 0
            fi
        else
            log_error "Neither curl nor wget available"
            return 1
        fi
        
        log_warn "Download failed"
        
        if [ $attempt -lt $max_retries ]; then
            local wait_time=$((attempt * 2))
            log_info "Waiting ${wait_time}s before retry..."
            sleep $wait_time
        fi
        
        ((attempt++))
    done
    
    log_error "Download failed after $max_retries attempts"
    return 1
}

verify_checksum() {
    local file=$1
    local expected_checksum=$2
    local algorithm=${3:-sha256}
    
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi
    
    log_info "Verifying checksum ($algorithm)..."
    
    local actual_checksum
    case $algorithm in
        md5)
            if command -v md5sum &> /dev/null; then
                actual_checksum=$(md5sum "$file" 2>/dev/null | awk '{print $1}')
            elif command -v md5 &> /dev/null; then
                actual_checksum=$(md5 -q "$file" 2>/dev/null)
            fi
            ;;
        sha256)
            if command -v sha256sum &> /dev/null; then
                actual_checksum=$(sha256sum "$file" 2>/dev/null | awk '{print $1}')
            elif command -v shasum &> /dev/null; then
                actual_checksum=$(shasum -a 256 "$file" 2>/dev/null | awk '{print $1}')
            fi
            ;;
        *)
            log_error "Unsupported algorithm: $algorithm"
            return 1
            ;;
    esac
    
    if [ "$actual_checksum" = "$expected_checksum" ]; then
        log_success "Checksum verified"
        return 0
    else
        log_error "Checksum mismatch!"
        log_error "  Expected: $expected_checksum"
        log_error "  Actual:   $actual_checksum"
        return 1
    fi
}

#==========================================
# DEMO
#==========================================

echo "Test 1: Check prerequisites"
check_prerequisites "bash" "awk" "sed" "grep"
echo ""

echo "Test 2: Download file"
download_file "https://httpbin.org/robots.txt" "/tmp/robots.txt" 2
if [ -f "/tmp/robots.txt" ]; then
    log_info "Downloaded file size: $(wc -c < /tmp/robots.txt) bytes"
    rm /tmp/robots.txt
fi
echo ""

echo "Test 3: Checksum verification"
echo "test content" > /tmp/test_checksum.txt
if command -v sha256sum &> /dev/null; then
    expected=$(sha256sum /tmp/test_checksum.txt | awk '{print $1}')
elif command -v shasum &> /dev/null; then
    expected=$(shasum -a 256 /tmp/test_checksum.txt | awk '{print $1}')
else
    expected="dummy_checksum"
fi
verify_checksum "/tmp/test_checksum.txt" "$expected" "sha256" || log_warn "Checksum tools may not be available"
rm /tmp/test_checksum.txt
echo ""

log_success "Deployment functions demo completed!"
