"""
String Utilities Module
Demonstrates another custom module with string operations
"""

def to_uppercase(text):
    """Convert text to uppercase"""
    return text.upper()

def to_lowercase(text):
    """Convert text to lowercase"""
    return text.lower()

def reverse_string(text):
    """Reverse a string"""
    return text[::-1]

def count_words(text):
    """Count words in a string"""
    return len(text.split())

def capitalize_words(text):
    """Capitalize first letter of each word"""
    return text.title()
