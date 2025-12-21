#!/bin/bash
# Interactive Menu System

show_menu() {
    clear
    echo "======================================="
    echo "        SYSTEM TOOLS MENU"
    echo "======================================="
    echo ""
    echo "1. System Information"
    echo "2. Disk Usage"
    echo "3. Network Information"
    echo "4. Process List"
    echo "5. File Finder"
    echo "6. Play Number Game"
    echo "0. Exit"
    echo ""
    echo "======================================="
}

system_info() {
    clear
    echo "=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "OS: $(uname -s)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo "Current User: $(whoami)"
    read -p "Press Enter to continue..."
}

disk_usage() {
    clear
    echo "=== Disk Usage ==="
    df -h | head -10
    echo ""
    echo "=== Top 5 Largest Directories ==="
    du -sh ./* 2>/dev/null | sort -hr | head -5
    read -p "Press Enter to continue..."
}

network_info() {
    clear
    echo "=== Network Information ==="
    echo "IP Addresses:"
    if command -v ip &> /dev/null; then
        ip addr show | grep "inet " | awk '{print $2}'
    else
        ifconfig | grep "inet " | awk '{print $2}'
    fi
    echo ""
    echo "Active Connections:"
    netstat -an 2>/dev/null | head -10 || ss -an | head -10
    read -p "Press Enter to continue..."
}

process_list() {
    clear
    echo "=== Top Processes by CPU ==="
    ps aux | sort -rk 3 | head -11
    read -p "Press Enter to continue..."
}

file_finder() {
    clear
    echo "=== File Finder ==="
    read -p "Enter filename pattern: " pattern
    
    if [ -z "$pattern" ]; then
        echo "No pattern entered"
    else
        echo "Searching for: $pattern"
        find . -name "*$pattern*" -type f 2>/dev/null | head -20
        echo ""
        echo "(Showing first 20 results)"
    fi
    read -p "Press Enter to continue..."
}

number_game() {
    clear
    echo "=== Quick Number Game ==="
    secret=$((RANDOM % 20 + 1))
    attempts=0
    
    echo "Guess a number between 1 and 20 (3 attempts)"
    
    while [ $attempts -lt 3 ]; do
        ((attempts++))
        read -p "Attempt $attempts: " guess
        
        if [ "$guess" -eq "$secret" ]; then
            echo "🎉 Correct! The number was $secret"
            read -p "Press Enter to continue..."
            return
        elif [ "$guess" -lt "$secret" ]; then
            echo "Higher!"
        else
            echo "Lower!"
        fi
    done
    
    echo "Game Over! The number was $secret"
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    show_menu
    read -p "Enter choice [0-6]: " choice
    
    case $choice in
        1) system_info ;;
        2) disk_usage ;;
        3) network_info ;;
        4) process_list ;;
        5) file_finder ;;
        6) number_game ;;
        0) 
            clear
            echo "Thank you for using System Tools!"
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            sleep 2
            ;;
    esac
done
