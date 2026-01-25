#!/usr/bin/env python3
"""
Module Demo - Demonstrating Python Module Usage
This script shows how to import and use custom modules
"""

# Standard library imports
import sys
import os
from datetime import datetime

# Import our custom modules
import math_utils
from string_utils import to_uppercase, reverse_string, count_words

# Import with alias
import math_utils as mu

def demonstrate_math_module():
    """Demonstrate math_utils module"""
    print("\n" + "="*50)
    print("MATH UTILITIES MODULE DEMO")
    print("="*50)
    
    # Using individual functions
    print(f"\nBasic Operations:")
    print(f"  10 + 5 = {math_utils.add(10, 5)}")
    print(f"  10 - 5 = {math_utils.subtract(10, 5)}")
    print(f"  10 * 5 = {math_utils.multiply(10, 5)}")
    print(f"  10 / 5 = {math_utils.divide(10, 5)}")
    
    # Using module constant
    print(f"\nUsing module constant PI: {math_utils.PI}")
    print(f"Circle area (radius=7): {math_utils.calculate_circle_area(7):.2f}")
    
    # Using Calculator class from module
    print(f"\nUsing Calculator class:")
    calc = math_utils.Calculator()
    print(f"  Initial result: {calc.result}")
    print(f"  Add 10: {calc.add(10)}")
    print(f"  Add 5: {calc.add(5)}")
    print(f"  Subtract 3: {calc.subtract(3)}")
    print(f"  Clear: {calc.clear()}")

def demonstrate_string_module():
    """Demonstrate string_utils module"""
    print("\n" + "="*50)
    print("STRING UTILITIES MODULE DEMO")
    print("="*50)
    
    text = "hello python modules"
    
    print(f"\nOriginal text: '{text}'")
    print(f"Uppercase: '{to_uppercase(text)}'")
    print(f"Reversed: '{reverse_string(text)}'")
    print(f"Word count: {count_words(text)}")

def demonstrate_standard_modules():
    """Demonstrate standard library modules"""
    print("\n" + "="*50)
    print("STANDARD LIBRARY MODULES DEMO")
    print("="*50)
    
    # datetime module
    print(f"\nCurrent date/time: {datetime.now()}")
    
    # os module
    print(f"Current directory: {os.getcwd()}")
    print(f"Python version: {sys.version}")
    
    # sys module - module search path
    print(f"\nPython module search paths (first 3):")
    for i, path in enumerate(sys.path[:3], 1):
        print(f"  {i}. {path}")

def demonstrate_module_attributes():
    """Demonstrate module introspection"""
    print("\n" + "="*50)
    print("MODULE ATTRIBUTES")
    print("="*50)
    
    print(f"\nmath_utils module name: {math_utils.__name__}")
    print(f"math_utils module file: {math_utils.__file__}")
    print(f"math_utils docstring: {math_utils.__doc__}")
    
    print(f"\nAvailable functions in math_utils:")
    functions = [item for item in dir(math_utils) if not item.startswith('_')]
    for func in functions:
        print(f"  - {func}")

def main():
    """Main function to run all demos"""
    print("\n" + "="*60)
    print("PYTHON MODULE DEMONSTRATION")
    print("="*60)
    
    demonstrate_math_module()
    demonstrate_string_module()
    demonstrate_standard_modules()
    demonstrate_module_attributes()
    
    print("\n" + "="*60)
    print("MODULE DEMO COMPLETE!")
    print("="*60)
    print("\nKey Takeaways:")
    print("1. Import modules with: import module_name")
    print("2. Import specific items with: from module import item")
    print("3. Use aliases with: import module as alias")
    print("4. Modules can contain functions, classes, and variables")
    print("5. Create your own modules by creating .py files")

if __name__ == "__main__":
    main()
