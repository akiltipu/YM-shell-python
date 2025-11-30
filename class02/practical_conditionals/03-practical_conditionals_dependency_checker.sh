#!/bin/bash
#
# Example 3: Service Dependency Checker
# Demonstrates: Dependency validation, case statement patterns
#

set -euo pipefail

echo "======================================="
echo "  SERVICE DEPENDENCY CHECKER"
echo "======================================="
echo ""

check_service_dependencies() {
    local service=$1
    
    echo "Checking dependencies for: $service"
    
    case $service in
        webapp)
            local deps=("nginx" "nodejs" "postgres")
            ;;
        api)
            local deps=("nodejs" "redis" "postgres")
            ;;
        database)
            local deps=("postgres")
            ;;
        *)
            echo "  ✗ Unknown service"
            return 1
            ;;
    esac
    
    local all_ok=true
    
    for dep in "${deps[@]}"; do
        # Simulate dependency check
        if command -v $dep &> /dev/null || [ "$dep" = "nodejs" ] || [ "$dep" = "postgres" ] || [ "$dep" = "redis" ]; then
            echo "  ✓ $dep: Available"
        else
            echo "  ✗ $dep: Missing"
            all_ok=false
        fi
    done
    
    echo ""
    if $all_ok; then
        echo "✓ All dependencies satisfied"
        return 0
    else
        echo "✗ Missing dependencies - cannot start service"
        return 1
    fi
}

# Test with different services
check_service_dependencies "webapp"
echo ""
check_service_dependencies "api" || true
