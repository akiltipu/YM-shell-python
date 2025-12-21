# Class `04`
# Shell Scripting for Command-line




#### Mastering the Command-Line




### Managing the Directory Stack

**What Is the Directory Stack?**

The directory stack is a list of directories maintained by the shell. You can push directories onto the stack, pop them off, and navigate between them. This is incredibly useful when working with multiple projects or navigating complex directory hierarchies.

**Key Commands:**

| Command | Description | Example |
|---------|-------------|---------|
| `pushd DIR` | Push directory and change to it | `pushd /var/log` |
| `popd` | Pop directory and change to it | `popd` |
| `dirs` | Display directory stack | `dirs -v` |
| `dirs -c` | Clear directory stack | `dirs -c` |

---

#### Directory Stack Basics

Create `dirstack_demo.sh`:

```bash
#!/bin/bash
# Directory Stack Management Demonstration

echo "======================================="
echo "    DIRECTORY STACK MANAGEMENT"
echo "======================================="
echo ""

# Display current location and stack
show_stack() {
    echo "Current directory: $(pwd)"
    echo "Directory stack:"
    dirs -v
    echo ""
}

# Initial state
echo "=== Initial State ==="
show_stack

# Create test directories
echo "=== Creating Test Directories ==="
mkdir -p test_project/{src,docs,tests,config}
echo "Created: test_project/{src,docs,tests,config}"
echo ""

# Navigate using pushd
echo "=== Using pushd to Navigate ==="
echo "Pushing test_project/src..."
pushd test_project/src > /dev/null
show_stack

echo "Pushing ../docs..."
pushd ../docs > /dev/null
show_stack

echo "Pushing ../tests..."
pushd ../tests > /dev/null
show_stack

# Display numbered stack
echo "=== Numbered Stack Display ==="
dirs -v
echo ""

# Jump to specific directory in stack
echo "=== Jump to Directory 2 ==="
pushd +2 > /dev/null
show_stack

# Pop directories
echo "=== Using popd ==="
echo "Popping..."
popd > /dev/null
show_stack

echo "Popping again..."
popd > /dev/null
show_stack

# Clear stack
echo "=== Clear Stack ==="
dirs -c
show_stack

# Cleanup
echo "=== Cleanup ==="
cd ..
rm -rf test_project
echo "Test directories removed"
echo ""

echo "======================================="
echo "Demo complete!"
```

**Run:**
```bash
chmod +x dirstack_demo.sh
./dirstack_demo.sh
```

---

#### Advanced Directory Navigation

Create `nav_utils.sh`:

```bash
#!/bin/bash
# Advanced Navigation Utilities

# Save current directory
save_dir() {
    export SAVED_DIR=$(pwd)
    echo "Saved: $SAVED_DIR"
}

# Return to saved directory
back() {
    if [ -n "$SAVED_DIR" ]; then
        cd "$SAVED_DIR" || return 1
        echo "Returned to: $(pwd)"
    else
        echo "No saved directory"
        return 1
    fi
}

# Navigate up N directories
up() {
    local levels=${1:-1}
    local path=""
    
    for ((i=0; i<levels; i++)); do
        path="../$path"
    done
    
    cd "$path" || return 1
    echo "Current directory: $(pwd)"
}

# Find and navigate to directory
goto() {
    local target=$1
    
    if [ -z "$target" ]; then
        echo "Usage: goto <directory_name>"
        return 1
    fi
    
    # Search in current directory tree
    local found=$(find . -type d -name "$target" -print -quit 2>/dev/null)
    
    if [ -n "$found" ]; then
        cd "$found" || return 1
        echo "Navigated to: $(pwd)"
    else
        echo "Directory not found: $target"
        return 1
    fi
}

# List recent directories
recent_dirs() {
    echo "Recent directories:"
    dirs -v | head -10
}

# Interactive directory chooser
choose_dir() {
    local dirs_array=($(find . -maxdepth 3 -type d | sort))
    local count=${#dirs_array[@]}
    
    if [ $count -eq 0 ]; then
        echo "No directories found"
        return 1
    fi
    
    echo "Available directories:"
    for i in "${!dirs_array[@]}"; do
        echo "  $((i+1)). ${dirs_array[$i]}"
        if [ $i -ge 19 ]; then
            echo "  ... (showing first 20)"
            break
        fi
    done
    
    read -p "Choose directory (1-$count): " choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$count" ]; then
        local target="${dirs_array[$((choice-1))]}"
        cd "$target" || return 1
        echo "Current directory: $(pwd)"
    else
        echo "Invalid choice"
        return 1
    fi
}

# Demo usage
echo "======================================="
echo "    NAVIGATION UTILITIES DEMO"
echo "======================================="
echo ""

# Create test structure
mkdir -p demo/{project1/{src,tests},project2/{lib,docs}}
cd demo || exit

echo "=== Current Location ==="
pwd
echo ""

echo "=== Save Current Directory ==="
save_dir
echo ""

echo "=== Navigate to project1/src ==="
cd project1/src
pwd
echo ""

echo "=== Go up 2 levels ==="
up 2
echo ""

echo "=== Return to Saved Directory ==="
back
echo ""

echo "=== Find and Go to 'docs' ==="
goto docs
echo ""

# Cleanup
cd ../..
rm -rf demo

echo ""
echo "======================================="
echo "Demo complete!"
echo ""
echo "Available functions:"
echo "  save_dir    - Save current directory"
echo "  back        - Return to saved directory"
echo "  up [N]      - Go up N directories"
echo "  goto <name> - Find and navigate to directory"
echo "  recent_dirs - List recent directories"
echo "  choose_dir  - Interactive directory chooser"
```

**Run:**
```bash
chmod +x nav_utils.sh
./nav_utils.sh

# Or source it for use in your shell
source nav_utils.sh
```

---

### Filesystem Operations

#### File and Directory Operations

Create `file_ops.sh`:

```bash
#!/bin/bash
# Filesystem Operations Demonstration

echo "======================================="
echo "     FILESYSTEM OPERATIONS"
echo "======================================="
echo ""

# Create test environment
TEST_DIR="file_ops_test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit

# Example 1: Bulk file creation
echo "=== Example 1: Bulk File Creation ==="
for i in {1..5}; do
    echo "Content $i" > "file_$i.txt"
done
echo "Created 5 files"
ls -l
echo ""

# Example 2: File renaming with patterns
echo "=== Example 2: Bulk Rename ==="
echo "Renaming .txt to .bak..."
for file in *.txt; do
    mv "$file" "${file%.txt}.bak"
done
ls -l
echo ""

# Example 3: File organization by extension
echo "=== Example 3: Organize by Extension ==="
# Create mixed files
touch doc1.pdf doc2.pdf image1.jpg image2.jpg script.sh

echo "Created mixed files:"
ls -l
echo ""

# Organize into directories
for ext in pdf jpg sh bak; do
    if ls *.$ext 1> /dev/null 2>&1; then
        mkdir -p "$ext"_files
        mv *.$ext "$ext"_files/
        echo "Moved .$ext files to ${ext}_files/"
    fi
done

echo ""
echo "Organized structure:"
tree . || find . -type d
echo ""

# Example 4: Find and process files
echo "=== Example 4: Find and Process ==="
# Create files with different ages
touch -t 202301010000 old_file.txt
touch recent_file.txt

echo "Finding files modified today:"
find . -type f -mtime 0 -name "*.txt"
echo ""

echo "Finding old files (modified >30 days ago):"
find . -type f -mtime +30 -name "*.txt"
echo ""

# Example 5: Safe file deletion
echo "=== Example 5: Safe Delete with Trash ==="
mkdir -p trash

safe_delete() {
    local file=$1
    if [ -f "$file" ]; then
        mv "$file" trash/
        echo "Moved to trash: $file"
    else
        echo "File not found: $file"
    fi
}

touch temp_file.txt
safe_delete temp_file.txt
echo "Trash contents:"
ls -l trash/
echo ""

# Example 6: File permissions management
echo "=== Example 6: Bulk Permission Changes ==="
touch script1.sh script2.sh script3.sh

echo "Making all .sh files executable:"
chmod +x *.sh
ls -l *.sh
echo ""

# Example 7: Duplicate file detection
echo "=== Example 7: Find Duplicates ==="
# Create duplicate
cp recent_file.txt duplicate.txt

echo "Finding files with same size:"
find . -type f -exec du -b {} \; | sort -n | uniq -d -w5
echo ""

# Cleanup
cd ..
rm -rf "$TEST_DIR"

echo "======================================="
echo "Demo complete!"
echo "Test directory cleaned up"
```

**Run:**
```bash
chmod +x file_ops.sh
./file_ops.sh
```

---

#### Advanced File Processing

Create `file_processing.sh`:

```bash
#!/bin/bash
# Advanced File Processing

echo "======================================="
echo "    ADVANCED FILE PROCESSING"
echo "======================================="
echo ""

# Create sample data
cat > data.csv << 'EOF'
Name,Age,Department,Salary
John Doe,30,Engineering,75000
Jane Smith,28,Marketing,65000
Bob Johnson,35,Engineering,85000
Alice Williams,32,Sales,70000
Charlie Brown,29,Engineering,72000
EOF

echo "=== Sample Data Created ==="
cat data.csv
echo ""

# Example 1: Extract specific columns
echo "=== Example 1: Extract Names and Departments ==="
awk -F',' 'NR>1 {print $1 " - " $3}' data.csv
echo ""

# Example 2: Filter by condition
echo "=== Example 2: Engineers Only ==="
awk -F',' 'NR>1 && $3=="Engineering" {print $1 " ($" $4 ")"}' data.csv
echo ""

# Example 3: Calculate statistics
echo "=== Example 3: Salary Statistics ==="
awk -F',' '
    NR>1 {
        sum += $4
        count++
        if ($4 > max) max = $4
        if (min == 0 || $4 < min) min = $4
    }
    END {
        print "Average: $" sum/count
        print "Minimum: $" min
        print "Maximum: $" max
    }
' data.csv
echo ""

# Example 4: File transformation
echo "=== Example 4: Convert to JSON ==="
cat > convert_to_json.sh << 'SCRIPT'
#!/bin/bash
echo "["
awk -F',' '
    NR>1 {
        if (NR>2) print ","
        printf "  {\n"
        printf "    \"name\": \"%s\",\n", $1
        printf "    \"age\": %s,\n", $2
        printf "    \"department\": \"%s\",\n", $3
        printf "    \"salary\": %s\n", $4
        printf "  }"
    }
' data.csv
echo ""
echo "]"
SCRIPT

chmod +x convert_to_json.sh
./convert_to_json.sh > data.json

echo "JSON created:"
cat data.json
echo ""

# Example 5: Merge files
echo "=== Example 5: File Merging ==="
cat > file1.txt << 'EOF'
Line 1 from file1
Line 2 from file1
EOF

cat > file2.txt << 'EOF'
Line 1 from file2
Line 2 from file2
EOF

echo "Merging files side by side:"
paste file1.txt file2.txt
echo ""

# Example 6: Split files
echo "=== Example 6: File Splitting ==="
cat > large_file.txt << 'EOF'
Line 1
Line 2
Line 3
Line 4
Line 5
Line 6
EOF

echo "Splitting into 2-line chunks:"
split -l 2 large_file.txt chunk_
ls -l chunk_*
echo ""

# Cleanup
rm -f data.csv data.json convert_to_json.sh
rm -f file1.txt file2.txt large_file.txt chunk_*

echo "======================================="
echo "Demo complete!"
```

**Run:**
```bash
chmod +x file_processing.sh
./file_processing.sh
```

---

### Utility Functions

#### Building a Utility Library

Create `utils_lib.sh`:

```bash
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
```

**Run:**
```bash
chmod +x utils_lib.sh
./utils_lib.sh

# Or source to use functions
source utils_lib.sh
```

---

### Mastering Man Pages

#### Reading and Using Man Pages

Create `man_page_guide.sh`:

```bash
#!/bin/bash
# Man Page Guide and Demo

echo "======================================="
echo "      MAN PAGE MASTERY GUIDE"
echo "======================================="
echo ""

# Man page sections
cat << 'EOF'
=== Man Page Sections ===

1. User Commands         - General commands (ls, cp, etc.)
2. System Calls          - Kernel functions (open, read, etc.)
3. Library Functions     - C library functions
4. Special Files         - Device files (/dev/*)
5. File Formats          - Config file formats (/etc/passwd)
6. Games                 - Games and screensavers
7. Miscellaneous         - Macro packages, conventions
8. System Admin          - Maintenance commands (mount, etc.)

Usage: man [section] command

Examples:
  man ls           # User command
  man 2 open       # System call
  man 5 passwd     # File format
  man 8 mount      # Admin command

EOF

# Man page navigation
cat << 'EOF'
=== Navigation Keys ===

Space     - Next page
b         - Previous page
/pattern  - Search forward
?pattern  - Search backward
n         - Next search result
N         - Previous search result
g         - Go to beginning
G         - Go to end
q         - Quit

EOF

# Useful man commands
cat << 'EOF'
=== Useful Man Commands ===

man -k keyword       - Search all man pages
man -f command       - Display brief description
whatis command       - Same as man -f
apropos keyword      - Same as man -k
man -K pattern       - Search in all man page content

EOF

# Examples
echo "=== Quick Reference Examples ==="
echo ""

echo "1. Find commands related to 'network':"
echo "   man -k network | head -5"
man -k network 2>/dev/null | head -5
echo ""

echo "2. Brief description of 'grep':"
echo "   whatis grep"
whatis grep 2>/dev/null
echo ""

echo "3. Common command options:"
cat << 'EOF'

# Most common patterns in man pages:
ls -la      # -l (long), -a (all)
grep -r     # -r (recursive)
find -name  # -name (by name)
chmod +x    # +x (add execute)
tar -xzf    # -x (extract), -z (gzip), -f (file)

EOF

echo "=== How to Read a Man Page ==="
cat << 'EOF'

Structure of a typical man page:

NAME
  Command name and brief description

SYNOPSIS
  Command syntax and options
  [optional] <required> {choice1|choice2}

DESCRIPTION
  Detailed explanation of the command

OPTIONS
  List of all available flags and arguments

EXAMPLES
  Usage examples (most useful section!)

SEE ALSO
  Related commands

EOF

echo "======================================="
echo "Try these exercises:"
echo "  1. man ls        - Read the ls man page"
echo "  2. man -k copy   - Find commands for copying"
echo "  3. man bash      - Learn about bash features"
echo "======================================="
```

**Run:**
```bash
chmod +x man_page_guide.sh
./man_page_guide.sh
```

---

### Interactive Scripting with Simple Games

#### Number Guessing Game

Create `guess_number.sh`:

```bash
#!/bin/bash
# Number Guessing Game

echo "======================================="
echo "      NUMBER GUESSING GAME"
echo "======================================="
echo ""

# Game setup
secret_number=$((RANDOM % 100 + 1))
attempts=0
max_attempts=7

echo "I'm thinking of a number between 1 and 100"
echo "You have $max_attempts attempts to guess it"
echo ""

# Game loop
while [ $attempts -lt $max_attempts ]; do
    ((attempts++))
    remaining=$((max_attempts - attempts + 1))
    
    read -p "Attempt $attempts: Enter your guess: " guess
    
    # Validate input
    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "Please enter a valid number!"
        ((attempts--))
        continue
    fi
    
    if [ $guess -eq $secret_number ]; then
        echo ""
        echo "🎉 Congratulations! You guessed it!"
        echo "The number was: $secret_number"
        echo "It took you $attempts attempts"
        exit 0
    elif [ $guess -lt $secret_number ]; then
        echo "Too low! ($remaining attempts remaining)"
    else
        echo "Too high! ($remaining attempts remaining)"
    fi
    
    # Provide hints
    diff=$((secret_number - guess))
    if [ ${diff#-} -le 5 ]; then
        echo "🔥 You're very close!"
    elif [ ${diff#-} -le 15 ]; then
        echo "🌡️  You're getting warm!"
    fi
    
    echo ""
done

# Game over
echo "======================================="
echo "Game Over! You've used all attempts."
echo "The number was: $secret_number"
echo "Better luck next time!"
echo "======================================="
```

**Run:**
```bash
chmod +x guess_number.sh
./guess_number.sh
```

---

#### Quiz Game

Create `quiz_game.sh`:

```bash
#!/bin/bash
# Shell Scripting Quiz Game

echo "======================================="
echo "     SHELL SCRIPTING QUIZ GAME"
echo "======================================="
echo ""

score=0
total=0

# Question function
ask_question() {
    local question=$1
    local correct=$2
    shift 2
    local options=("$@")
    
    ((total++))
    echo "Question $total:"
    echo "$question"
    echo ""
    
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[$i]}"
    done
    
    echo ""
    read -p "Your answer (1-${#options[@]}): " answer
    
    if [ "$answer" = "$correct" ]; then
        echo "✓ Correct!"
        ((score++))
    else
        echo "✗ Wrong! The correct answer was: $correct"
    fi
    echo ""
    echo "-----------------------------------"
    echo ""
}

# Quiz questions
echo "Let's test your shell scripting knowledge!"
echo ""

ask_question \
    "What does \$? represent in bash?" \
    "3" \
    "Process ID" \
    "Number of arguments" \
    "Exit status of last command" \
    "Current line number"

ask_question \
    "Which command changes file permissions?" \
    "2" \
    "chown" \
    "chmod" \
    "chgrp" \
    "attr"

ask_question \
    "What does 'set -e' do?" \
    "1" \
    "Exit script on error" \
    "Enable echo mode" \
    "Set environment variable" \
    "Enable strict mode"

ask_question \
    "Which operator performs arithmetic?" \
    "3" \
    "\$[]" \
    "\${}" \
    "\$(())" \
    "\$\$"

ask_question \
    "What does 'grep -r' do?" \
    "2" \
    "Remove matches" \
    "Recursive search" \
    "Reverse match" \
    "Regular expression"

# Final score
echo "======================================="
echo "          QUIZ COMPLETE!"
echo "======================================="
echo "Your score: $score out of $total"

percentage=$((score * 100 / total))
echo "Percentage: $percentage%"
echo ""

if [ $percentage -ge 80 ]; then
    echo "🌟 Excellent! You're a shell scripting pro!"
elif [ $percentage -ge 60 ]; then
    echo "👍 Good job! Keep practicing!"
elif [ $percentage -ge 40 ]; then
    echo "📚 Not bad! Review the material and try again."
else
    echo "📖 Keep learning! Practice makes perfect."
fi

echo "======================================="
```

**Run:**
```bash
chmod +x quiz_game.sh
./quiz_game.sh
```

---

#### Interactive Menu System

Create `menu_system.sh`:

```bash
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
```

**Run:**
```bash
chmod +x menu_system.sh
./menu_system.sh
```

---

### Wrap-up & Q&A

#### Summary & Key Takeaways

**Recap:**
```
What We Learned Today:
  1. Directory stack management (pushd/popd)
  2. Advanced filesystem operations
  3. Building utility function libraries
  4. Using and understanding man pages
  5. Creating interactive scripts and games

Skills Gained:
  - Efficient directory navigation
  - Bulk file operations and organization
  - Reusable utility functions
  - Reading technical documentation
  - Building user-friendly interactive tools
```

---

#### Homework Assignment

**Assignment:**
```bash
Create an "Interactive DevOps Toolkit" that:
1. Uses directory stack for project navigation
2. Includes file organization utilities
3. Imports and uses a custom utility library
4. Has comprehensive help (like man pages)
5. Provides an interactive menu system
6. Includes at least one game or quiz

Bonus: Create actual man page documentation
Bonus: Add tab completion for your tool
```

**Resources to Share:**
```
Learning Resources:
- Man Page Guide: man man
- Advanced Bash: https://tldp.org/LDP/abs/html/
- Shell Games: https://github.com/topics/shell-game
- Function Libraries: https://github.com/dylanaraps/pure-bash-bible
```

## Message

```
"Excellent work on Class 04!

You've learned to master the command-line like a pro.
These navigation techniques, utility functions, and
interactive scripts will make you significantly more
productive in your daily DevOps work.

Remember: The best engineers build tools that others
love to use. Make your scripts interactive, helpful,
and fun!

Next up: Class 05 - System Automation. Let's automate
everything!"
```

---

**Keep building and automating!**
