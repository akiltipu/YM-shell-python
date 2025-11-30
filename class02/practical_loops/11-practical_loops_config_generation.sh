#!/bin/bash
#
# Example 11: Dynamic Configuration Generation
# Demonstrates: Environment-specific configs, case statements in loops
#

set -euo pipefail

echo "======================================="
echo "  DYNAMIC CONFIG GENERATION"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Generate config for multiple environments
declare -a environments=("dev" "staging" "production")

for env in "${environments[@]}"; do
    config_file="/tmp/config_${env}.conf"
    
    log "Generating config for: $env"
    
    case $env in
        dev)
            cat > "$config_file" << EOF
# Development Configuration
debug=true
log_level=DEBUG
cache_enabled=false
EOF
            ;;
        staging)
            cat > "$config_file" << EOF
# Staging Configuration
debug=true
log_level=INFO
cache_enabled=true
EOF
            ;;
        production)
            cat > "$config_file" << EOF
# Production Configuration
debug=false
log_level=ERROR
cache_enabled=true
EOF
            ;;
    esac
    
    log "  ✓ Created: $config_file"
    cat "$config_file" | sed 's/^/    /'
    echo ""
    
    # Cleanup
    rm "$config_file"
done

log "✓ Configuration generation completed"
