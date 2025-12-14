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
