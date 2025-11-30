#!/bin/bash
#
# Example 13: Interactive Menu System
# Demonstrates: Menu patterns, case statements, loop-based navigation
#

set -euo pipefail

echo "======================================="
echo "  INTERACTIVE MENU SYSTEM"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

show_menu() {
    cat << EOF
========================================
          DEPLOYMENT MENU
========================================
1. Deploy to Development
2. Deploy to Staging
3. Deploy to Production
4. Rollback
5. View Status
6. Exit
========================================
EOF
}

# Simulate menu (non-interactive for demo)
log "Menu system example (simulated)"
choices=(1 5 2 6)

for choice in "${choices[@]}"; do
    log "User selected: $choice"
    
    case $choice in
        1)
            log "  Action: Deploy to Development"
            ;;
        2)
            log "  Action: Deploy to Staging"
            ;;
        3)
            log "  Action: Deploy to Production"
            ;;
        4)
            log "  Action: Rollback"
            ;;
        5)
            log "  Action: View Status"
            ;;
        6)
            log "  Action: Exit"
            break
            ;;
        *)
            log "  Error: Invalid option"
            ;;
    esac
    echo ""
done

log "Menu session ended"
