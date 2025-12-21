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
        echo "You're very close!"
    elif [ ${diff#-} -le 15 ]; then
        echo "You're getting warm!"
    fi
    
    echo ""
done

# Game over
echo "======================================="
echo "Game Over! You've used all attempts."
echo "The number was: $secret_number"
echo "Better luck next time!"
echo "======================================="
