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
