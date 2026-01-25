# basic function

def greet():
    print("Hello, welcome to the Python function tutorial!")

greet()

# function with parameters
def greet_user(name):
    print(f"Hello, {name}! Welcome to the Python function tutorial!")

greet_user("Akil")
greet_user("DevOps Trainee")

# function with return value
def add(a, b):
    return a + b

result = add(5, 7)
print(f"The sum of 5 and 7 is: {result}")

# Practical example: calculator

def calculator(num1, num2, operation):
    if operation == "add":
        return num1 + num2
    elif operation == "subtract":
        return num1 - num2
    elif operation == "multiply":
        return num1 * num2
    elif operation == "divide":
        if num2 != 0:
            return num1 / num2
        else:
            return "Error: Division by zero"
    else:
        return "Error: Invalid operation"
    
print("Calculator Examples:")
print("5 + 3 =", calculator(5, 3, "add"))
print("10 - 4 =", calculator(10, 4, "subtract"))
print("6 * 7 =", calculator(6, 7, "multiply"))
print("20 / 5 =", calculator(20, 5, "divide"))
print("10 / 0 =", calculator(10, 0, "divide"))
print("Invalid operation:", calculator(10, 5, "modulus"))