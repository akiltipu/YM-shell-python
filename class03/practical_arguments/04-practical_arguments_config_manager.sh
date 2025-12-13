#!/bin/bash

# Practical Example: Configuration Manager
# Demonstrates: Subcommands, CRUD operations, JSON/YAML handling

set -euo pipefail

OPERATION=""
CONFIG_FILE="config.json"
KEY=""
VALUE=""
FORMAT="json"

usage() {
    cat << 'EOF'
Configuration Manager - Manage Application Configuration

Usage: ./04-practical_arguments_config_manager.sh OPERATION [OPTIONS]

Operations:
    get KEY             Get configuration value
    set KEY VALUE       Set configuration value
    delete KEY          Delete configuration key
    list                List all configurations
    export FILE         Export configuration to file
    import FILE         Import configuration from file

Options:
    -f, --file FILE     Configuration file (default: config.json)
    --format FORMAT     Output format: json, yaml, env (default: json)
    -h, --help          Show this help message

Examples:
    # Get a value
    ./04-practical_arguments_config_manager.sh get database.host

    # Set a value
    ./04-practical_arguments_config_manager.sh set app.port 8080

    # Delete a key
    ./04-practical_arguments_config_manager.sh delete cache.enabled

    # List all configurations
    ./04-practical_arguments_config_manager.sh list

    # Export to YAML
    ./04-practical_arguments_config_manager.sh export config.yaml --format yaml

EOF
    exit 0
}

log() {
    echo "[CONFIG] $*"
}

get_config() {
    local key=$1
    log "Getting value for key: $key"
    
    # Simulated config retrieval
    case $key in
        "database.host")
            echo "localhost"
            ;;
        "database.port")
            echo "5432"
            ;;
        "app.port")
            echo "3000"
            ;;
        "app.name")
            echo "MyApplication"
            ;;
        *)
            echo "Error: Key '$key' not found"
            exit 1
            ;;
    esac
}

set_config() {
    local key=$1
    local value=$2
    
    log "Setting $key = $value"
    
    # Simulated config update
    echo "  → Validating key format..."
    sleep 0.2
    echo "  → Updating configuration..."
    sleep 0.2
    echo "  → Saving to $CONFIG_FILE..."
    sleep 0.2
    
    log "Configuration updated successfully"
}

delete_config() {
    local key=$1
    
    log "Deleting key: $key"
    
    echo "  → Checking if key exists..."
    sleep 0.2
    echo "  → Removing key from configuration..."
    sleep 0.2
    echo "  → Saving changes..."
    sleep 0.2
    
    log "Key '$key' deleted successfully"
}

list_config() {
    log "Listing all configurations from $CONFIG_FILE"
    echo ""
    
    case $FORMAT in
        json)
            cat << 'EOF'
{
  "app": {
    "name": "MyApplication",
    "port": 3000,
    "environment": "production"
  },
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "appdb"
  },
  "cache": {
    "enabled": true,
    "ttl": 3600
  }
}
EOF
            ;;
        yaml)
            cat << 'EOF'
app:
  name: MyApplication
  port: 3000
  environment: production
database:
  host: localhost
  port: 5432
  name: appdb
cache:
  enabled: true
  ttl: 3600
EOF
            ;;
        env)
            cat << 'EOF'
APP_NAME=MyApplication
APP_PORT=3000
APP_ENVIRONMENT=production
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=appdb
CACHE_ENABLED=true
CACHE_TTL=3600
EOF
            ;;
    esac
}

export_config() {
    local file=$1
    log "Exporting configuration to $file (format: $FORMAT)"
    
    echo "  → Reading current configuration..."
    sleep 0.2
    echo "  → Converting to $FORMAT format..."
    sleep 0.2
    echo "  → Writing to $file..."
    sleep 0.2
    
    log "Configuration exported successfully to $file"
}

import_config() {
    local file=$1
    
    if [ ! -f "$file" ]; then
        echo "Error: File not found: $file"
        exit 1
    fi
    
    log "Importing configuration from $file"
    
    echo "  → Reading $file..."
    sleep 0.2
    echo "  → Validating format..."
    sleep 0.2
    echo "  → Merging with existing configuration..."
    sleep 0.2
    echo "  → Saving changes..."
    sleep 0.2
    
    log "Configuration imported successfully from $file"
}

# Parse operation
if [ $# -eq 0 ]; then
    usage
fi

OPERATION=$1
shift

# Parse remaining arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --format)
            FORMAT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            # Handle operation-specific arguments
            if [ -z "$KEY" ]; then
                KEY="$1"
                shift
            elif [ -z "$VALUE" ]; then
                VALUE="$1"
                shift
            else
                echo "Error: Unknown argument: $1"
                exit 1
            fi
            ;;
    esac
done

# Execute operation
echo "=== Configuration Manager ==="
echo "Config file: $CONFIG_FILE"
echo ""

case $OPERATION in
    get)
        if [ -z "$KEY" ]; then
            echo "Error: Key is required for get operation"
            exit 1
        fi
        RESULT=$(get_config "$KEY")
        echo "$KEY = $RESULT"
        ;;
    set)
        if [ -z "$KEY" ] || [ -z "$VALUE" ]; then
            echo "Error: Key and value are required for set operation"
            exit 1
        fi
        set_config "$KEY" "$VALUE"
        ;;
    delete)
        if [ -z "$KEY" ]; then
            echo "Error: Key is required for delete operation"
            exit 1
        fi
        delete_config "$KEY"
        ;;
    list)
        list_config
        ;;
    export)
        if [ -z "$KEY" ]; then
            echo "Error: Filename is required for export operation"
            exit 1
        fi
        export_config "$KEY"
        ;;
    import)
        if [ -z "$KEY" ]; then
            echo "Error: Filename is required for import operation"
            exit 1
        fi
        import_config "$KEY"
        ;;
    -h|--help)
        usage
        ;;
    *)
        echo "Error: Unknown operation: $OPERATION"
        echo "Valid operations: get, set, delete, list, export, import"
        exit 1
        ;;
esac

echo ""
echo "Operation completed"
