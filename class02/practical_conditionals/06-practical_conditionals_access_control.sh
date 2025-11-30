#!/bin/bash
#
# Example 6: User Access Control
# Demonstrates: RBAC patterns, resource-based access control
#

set -euo pipefail

echo "======================================="
echo "  USER ACCESS CONTROL"
echo "======================================="
echo ""

check_access() {
    local user=$1
    local resource=$2
    local action=$3
    
    echo "Checking access: $user -> $action on $resource"
    
    # Admin has full access
    if [ "$user" = "admin" ]; then
        echo "  ✓ Access granted (admin user)"
        return 0
    fi
    
    # Check resource type
    case $resource in
        production-db)
            if [[ $action == "read" ]]; then
                echo "  ✓ Read access granted"
                return 0
            else
                echo "  ✗ Write access denied (production database)"
                return 1
            fi
            ;;
        staging-db)
            if [[ $user =~ ^(developer|tester)$ ]]; then
                echo "  ✓ Access granted"
                return 0
            else
                echo "  ✗ Access denied (not authorized)"
                return 1
            fi
            ;;
        logs)
            echo "  ✓ Access granted (logs are public)"
            return 0
            ;;
        *)
            echo "  ✗ Unknown resource"
            return 1
            ;;
    esac
}

# Test various access scenarios
check_access "developer" "staging-db" "write"
echo ""
check_access "developer" "production-db" "write" || echo ""
echo ""
check_access "admin" "production-db" "write"
echo ""
check_access "developer" "production-db" "read"
