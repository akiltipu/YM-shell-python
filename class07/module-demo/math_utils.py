"""
Math Utilities Module
A simple module demonstrating custom Python modules
"""

# Module-level variable
PI = 3.14159

def add(a, b):
    """Add two numbers"""
    return a + b

def subtract(a, b):
    """Subtract b from a"""
    return a - b

def multiply(a, b):
    """Multiply two numbers"""
    return a * b

def divide(a, b):
    """Divide a by b"""
    if b == 0:
        return "Error: Division by zero"
    return a / b

def calculate_circle_area(radius):
    """Calculate the area of a circle"""
    return PI * radius * radius

class Calculator:
    """A simple calculator class"""
    
    def __init__(self):
        self.result = 0
    
    def add(self, value):
        self.result += value
        return self.result
    
    def subtract(self, value):
        self.result -= value
        return self.result
    
    def clear(self):
        self.result = 0
        return self.result

if __name__ == "__main__":
    # This code runs only when the module is executed directly
    print("Testing math_utils module...")
    print(f"5 + 3 = {add(5, 3)}")
    print(f"10 - 4 = {subtract(10, 4)}")
    print(f"Circle area (radius=5): {calculate_circle_area(5)}")
