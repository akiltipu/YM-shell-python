import os
import sys
import logging
import random
import time

print("=" * 60)
print("           ERROR HANDLING IN PYTHON")
print("=" * 60)
print()

# ===== 1. BASIC TRY-EXCEPT =====
print("=== 1. Basic Try-Except ===")

try:
    result = 10 / 0
except ZeroDivisionError:
    print("Error: Cannot divide by zero!")
print()

# ===== 2. CATCHING MULTIPLE EXCEPTIONS =====
print("=== 2. Multiple Exceptions ===")

def divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        print("Error: Division by zero")
        return None
    except TypeError:
        print("Error: Invalid types for division")
        return None

print(f"10 / 2 = {divide(10, 2)}")
print(f"10 / 0 = {divide(10, 0)}")
print(f"10 / 'a' = {divide(10, 'a')}")
print()

# ===== 3. TRY-EXCEPT-ELSE-FINALLY =====
print("=== 3. Complete Error Handling Pattern ===")

filename = "test_error.txt"

try:
    # Create file first
    with open(filename, "w") as f:
        f.write("test content")
    
    with open(filename, "r") as file:
        content = file.read()
except FileNotFoundError:
    print(f"Error: File '{filename}' not found")
except PermissionError:
    print(f"Error: Permission denied for '{filename}'")
except Exception as e:
    print(f"Unexpected error: {e}")
else:
    print(f"Successfully read file: {content}")
finally:
    print("Cleanup: Always runs")
    if os.path.exists(filename):
        os.remove(filename)
print()

# ===== 4. RAISING EXCEPTIONS =====
print("=== 4. Raising Custom Exceptions ===")

def validate_port(port):
    if not isinstance(port, int):
        raise TypeError("Port must be an integer")
    if port < 1 or port > 65535:
        raise ValueError(f"Port must be between 1 and 65535, got {port}")
    return True

try:
    validate_port(8080)
    print("Port 8080 is valid")
    
    validate_port(70000)
except ValueError as e:
    print(f"Validation error: {e}")
except TypeError as e:
    print(f"Type error: {e}")
print()

# ===== 5. CUSTOM EXCEPTION CLASSES =====
print("=== 5. Custom Exception Classes ===")

class DevOpsError(Exception):
    """Base exception for DevOps operations"""
    pass

class ServerNotFoundError(DevOpsError):
    """Raised when server is not found"""
    def __init__(self, server_name):
        self.server_name = server_name
        super().__init__(f"Server '{server_name}' not found")

class ConnectionFailedError(DevOpsError):
    """Raised when connection fails"""
    def __init__(self, host, port):
        self.host = host
        self.port = port
        super().__init__(f"Cannot connect to {host}:{port}")

def connect_to_server(server_name, port):
    servers = {"web01": "192.168.1.10", "db01": "192.168.1.20"}
    
    if server_name not in servers:
        raise ServerNotFoundError(server_name)
    
    # Simulate connection failure
    if port > 10000:
        raise ConnectionFailedError(servers[server_name], port)
    
    return f"Connected to {server_name} ({servers[server_name]}:{port})"

try:
    print(connect_to_server("web01", 8080))
    print(connect_to_server("unknown", 8080))
except ServerNotFoundError as e:
    print(f"Server error: {e}")
except ConnectionFailedError as e:
    print(f"Connection error: {e}")
print()

# ===== 6. CONTEXT MANAGERS FOR CLEANUP =====
print("=== 6. Context Managers ===")

class ServerConnection:
    def __init__(self, server_name):
        self.server_name = server_name
        self.connected = False
    
    def __enter__(self):
        print(f"Connecting to {self.server_name}...")
        self.connected = True
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Disconnecting from {self.server_name}...")
        self.connected = False
        if exc_type is not None:
            print(f"Error occurred: {exc_val}")
        return False  # Don't suppress exceptions

with ServerConnection("web-server-01") as conn:
    print(f"Connected: {conn.connected}")
    print("Performing operations...")
print()

# ===== 7. LOGGING ERRORS =====
print("=== 7. Error Logging ===")

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

def process_server(server_name):
    try:
        if not server_name:
            raise ValueError("Server name cannot be empty")
        
        logger.info(f"Processing server: {server_name}")
        # Simulate processing
        logger.debug("Server processed successfully")
        return True
    except ValueError as e:
        logger.error(f"Validation error: {e}")
        return False
    except Exception as e:
        logger.critical(f"Unexpected error: {e}")
        raise

process_server("web01")
process_server("")
print()

# ===== 8. RETRY PATTERN =====
print("=== 8. Retry Pattern ===")

def unreliable_operation():
    """Simulates an operation that fails randomly"""
    if random.random() < 0.7:  # 70% failure rate
        raise Exception("Operation failed")
    return "Success"

def retry_operation(func, max_retries=3, delay=0.1):
    """Retry a function with exponential backoff"""
    for attempt in range(1, max_retries + 1):
        try:
            result = func()
            print(f"  Attempt {attempt}: {result}")
            return result
        except Exception as e:
            print(f"  Attempt {attempt}: Failed - {e}")
            if attempt < max_retries:
                wait_time = delay * (2 ** (attempt - 1))
                print(f"  Retrying in {wait_time}s...")
                time.sleep(wait_time)
    
    raise Exception(f"All {max_retries} attempts failed")

try:
    retry_operation(unreliable_operation, max_retries=5, delay=0.1)
except Exception as e:
    print(f"Final failure: {e}")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
