# if else statement
temperature = 25

if temperature > 30:
    print("It's a hot day.")
elif temperature > 20:
    print("It's a warm day.")
else:
    print("It's a cold day.")

# Practical example: grade checker
score = 85

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
else:
    grade = "F"
    
print(f"Score: {score}, Grade: {grade}")