#!/usr/bin/env python3
"""
System Information Script
Demonstrates basic Python scripting for DevOps
Author: DevOps Training
Date: 2025-11-30
"""

import os
import platform
import datetime

print("=" * 60)
print("           SYSTEM INFORMATION REPORT")
print("=" * 60)
print()

# ===== SYSTEM DETAILS =====
print("=== System Details ===")
print(f"Hostname: {platform.node()}")
print(f"Operating System: {platform.system()}")
print(f"OS Release: {platform.release()}")
print(f"OS Version: {platform.version()}")
print(f"Architecture: {platform.machine()}")
print(f"Processor: {platform.processor()}")
print()

# ===== PYTHON ENVIRONMENT =====
print("=== Python Environment ===")
print(f"Python Version: {platform.python_version()}")
print(f"Python Implementation: {platform.python_implementation()}")
print(f"Python Compiler: {platform.python_compiler()}")
print()

# ===== USER INFORMATION =====
print("=== User Information ===")
print(f"Current User: {os.getenv('USER', 'unknown')}")
print(f"Home Directory: {os.path.expanduser('~')}")
print(f"Current Directory: {os.getcwd()}")
print()

# ===== ENVIRONMENT VARIABLES =====
print("=== Key Environment Variables ===")
env_vars = ['PATH', 'HOME', 'SHELL', 'LANG']
for var in env_vars:
    value = os.getenv(var, 'Not set')
    # Truncate long values
    if len(str(value)) > 50:
        value = str(value)[:50] + "..."
    print(f"  {var}: {value}")
print()

# ===== TIMESTAMP =====
print("=== Report Generated ===")
print(f"Date: {datetime.datetime.now().strftime('%Y-%m-%d')}")
print(f"Time: {datetime.datetime.now().strftime('%H:%M:%S')}")
try:
    print(f"Timezone: {datetime.datetime.now().astimezone().tzname()}")
except Exception:
    print("Timezone: N/A")
print()

print("=" * 60)
print("           REPORT COMPLETE")
print("=" * 60)
