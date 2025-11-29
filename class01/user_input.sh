#!/bin/bash
# User Input Demonstration

echo "==============================="
echo "  DevOps Profile Generator"
echo "==============================="
echo ""

# Basic input
echo "What's your name?"
read name

echo "What's your role?"
read role

echo "Years of experience?"
read experience

# Silent input (for passwords)
echo "Enter your GitHub username:"
read github

echo "Enter password (hidden):"
read -s password
echo ""  # New line after hidden input

# Input with prompt on same line
read -p "Favorite programming language: " language

# Input with default value
read -p "Preferred OS [Linux]: " os
os=${os:-Linux}  # Use Linux if empty

# Multiple values
echo "Enter your skills (space-separated):"
read skill1 skill2 skill3

# Display profile
echo ""
echo "================================"
echo "       YOUR PROFILE"
echo "================================"
echo "Name: $name"
echo "Role: $role"
echo "Experience: $experience years"
echo "GitHub: @$github"
echo "Password length: ${#password} characters"
echo "Favorite Language: $language"
echo "Preferred OS: $os"
echo "Top 3 Skills: $skill1, $skill2, $skill3"
echo "================================"