#!/usr/bin/env python3
"""
Configuration File Generator
Generates environment-specific configuration files
Author: DevOps Training
Date: 2025-11-30
"""

import json
import os
from datetime import datetime

print("=" * 60)
print("        CONFIGURATION FILE GENERATOR")
print("=" * 60)
print()

# Configuration templates
CONFIG_TEMPLATES = {
    "development": {
        "debug": True,
        "log_level": "DEBUG",
        "database": {
            "host": "localhost",
            "port": 5432,
            "name": "devops_dev",
            "pool_size": 5
        },
        "cache": {
            "host": "localhost",
            "port": 6379,
            "ttl": 300
        },
        "api": {
            "rate_limit": 1000,
            "timeout": 30
        }
    },
    "staging": {
        "debug": True,
        "log_level": "INFO",
        "database": {
            "host": "staging-db.company.com",
            "port": 5432,
            "name": "devops_staging",
            "pool_size": 10
        },
        "cache": {
            "host": "staging-cache.company.com",
            "port": 6379,
            "ttl": 600
        },
        "api": {
            "rate_limit": 500,
            "timeout": 30
        }
    },
    "production": {
        "debug": False,
        "log_level": "ERROR",
        "database": {
            "host": "prod-db.company.com",
            "port": 5432,
            "name": "devops_prod",
            "pool_size": 50
        },
        "cache": {
            "host": "prod-cache.company.com",
            "port": 6379,
            "ttl": 3600
        },
        "api": {
            "rate_limit": 100,
            "timeout": 15
        }
    }
}


def generate_config(environment):
    """Generate configuration for specified environment"""
    if environment not in CONFIG_TEMPLATES:
        print(f"Error: Unknown environment '{environment}'")
        print(f"Available environments: {list(CONFIG_TEMPLATES.keys())}")
        return None
    
    config = CONFIG_TEMPLATES[environment].copy()
    config["environment"] = environment
    config["generated_at"] = datetime.now().isoformat()
    config["version"] = "1.0.0"
    
    return config


def save_config(config, filename):
    """Save configuration to JSON file"""
    with open(filename, 'w') as f:
        json.dump(config, f, indent=2)
    print(f"✓ Configuration saved to: {filename}")


def display_config(config):
    """Display configuration in readable format"""
    print(json.dumps(config, indent=2))


# Main execution
environments = ["development", "staging", "production"]

print("Generating configurations for all environments...")
print()

for env in environments:
    print(f"=== {env.upper()} Configuration ===")
    
    config = generate_config(env)
    
    if config:
        # Display configuration
        display_config(config)
        
        # Save to file
        filename = f"config_{env}.json"
        save_config(config, filename)
    
    print()

# Cleanup generated files
print("=== Cleanup ===")
for env in environments:
    filename = f"config_{env}.json"
    if os.path.exists(filename):
        os.remove(filename)
        print(f"✓ Removed: {filename}")

print()
print("=" * 60)
print("        GENERATOR COMPLETE")
print("=" * 60)
