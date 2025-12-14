#!/bin/bash

# Practical Example 3: Interactive Menu System

echo "=== Interactive Menu System ==="
echo ""

# Menu function
show_menu() {
    local title=$1
    shift
    local options=("$@")
    
    echo "═══════════════════════════════════════"
    echo "  $title"
    echo "═══════════════════════════════════════"
    
    for i in "${!options[@]}"; do
        echo "  $((i + 1)). ${options[$i]}"
    done
    
    echo "  0. Exit"
    echo ""
    read -p "Select option: " choice
    echo "$choice"
}

# Demo menu system
menu_demo() {
    while true; do
        choice=$(show_menu "Main Menu" \
            "View Files" \
            "System Info" \
            "Run Task")
        
        case $choice in
            1)
                echo ""
                echo "→ Listing files..."
                ls -lh | head -5
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                echo "→ System Information:"
                echo "  Hostname: $(hostname)"
                echo "  User: $(whoami)"
                echo "  Date: $(date)"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                echo "→ Running task..."
                echo "  Task completed!"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            0)
                echo ""
                echo "Goodbye!"
                break
                ;;
            *)
                echo ""
                echo "Invalid option!"
                sleep 1
                ;;
        esac
    done
}

echo "Menu system ready (demo mode - showing structure)"
echo ""
echo "Menu would display:"
echo "  1. View Files"
echo "  2. System Info"
echo "  3. Run Task"
echo "  0. Exit"
echo ""

echo "Interactive menus make scripts user-friendly"
