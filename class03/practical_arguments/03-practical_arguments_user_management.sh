#!/bin/bash

# Practical Example: User Management Tool
# Demonstrates: Action-based arguments, role validation, interactive prompts

set -euo pipefail

# Default values
ACTION=""
USERNAME=""
ROLE=""
EMAIL=""
INTERACTIVE=false
FORCE=false

# Available roles
VALID_ROLES=("admin" "developer" "viewer" "operator")

usage() {
    cat << 'EOF'
User Management Tool

Usage: ./03-practical_arguments_user_management.sh ACTION [OPTIONS]

Actions:
    create          Create a new user
    delete          Delete an existing user
    update          Update user information
    list            List all users

Options for 'create' action:
    -u, --username USER     Username (required)
    -r, --role ROLE         User role: admin, developer, viewer, operator (required)
    -e, --email EMAIL       User email address (optional)
    -i, --interactive       Interactive mode with prompts

Options for 'delete' action:
    -u, --username USER     Username to delete (required)
    -f, --force             Force deletion without confirmation

Options for 'update' action:
    -u, --username USER     Username to update (required)
    -r, --role ROLE         New role (optional)
    -e, --email EMAIL       New email (optional)

General Options:
    -h, --help              Show this help message

Examples:
    # Create user with role
    ./03-practical_arguments_user_management.sh create -u john -r developer -e john@example.com

    # Create user interactively
    ./03-practical_arguments_user_management.sh create -i

    # Delete user with confirmation
    ./03-practical_arguments_user_management.sh delete -u john

    # Force delete without confirmation
    ./03-practical_arguments_user_management.sh delete -u john -f

    # Update user role
    ./03-practical_arguments_user_management.sh update -u john -r admin

    # List all users
    ./03-practical_arguments_user_management.sh list

EOF
    exit 0
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

validate_role() {
    local role=$1
    if [[ ! " ${VALID_ROLES[@]} " =~ " ${role} " ]]; then
        echo "Error: Invalid role '$role'"
        echo "Valid roles: ${VALID_ROLES[*]}"
        exit 1
    fi
}

validate_email() {
    local email=$1
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Error: Invalid email format: $email"
        exit 1
    fi
}

create_user() {
    if [ "$INTERACTIVE" = true ]; then
        echo "=== Interactive User Creation ==="
        echo ""
        
        read -p "Enter username: " USERNAME
        echo "Available roles: ${VALID_ROLES[*]}"
        read -p "Enter role: " ROLE
        read -p "Enter email (optional): " EMAIL
        echo ""
    fi
    
    # Validate inputs
    if [ -z "$USERNAME" ]; then
        echo "Error: Username is required"
        exit 1
    fi
    
    if [ -z "$ROLE" ]; then
        echo "Error: Role is required"
        exit 1
    fi
    
    validate_role "$ROLE"
    
    if [ -n "$EMAIL" ]; then
        validate_email "$EMAIL"
    fi
    
    # Simulate user creation
    log "Creating user: $USERNAME"
    log "Role: $ROLE"
    [ -n "$EMAIL" ] && log "Email: $EMAIL"
    
    # Simulated creation
    echo "  → Validating username availability..."
    sleep 0.3
    echo "  → Creating user account..."
    sleep 0.3
    echo "  → Assigning role: $ROLE"
    sleep 0.3
    echo "  → Setting up permissions..."
    sleep 0.3
    
    log "User '$USERNAME' created successfully!"
    
    # Display user info
    echo ""
    echo "User Details:"
    echo "  Username: $USERNAME"
    echo "  Role: $ROLE"
    echo "  Email: ${EMAIL:-N/A}"
    echo "  Created: $(date)"
}

delete_user() {
    if [ -z "$USERNAME" ]; then
        echo "Error: Username is required for deletion"
        exit 1
    fi
    
    log "Preparing to delete user: $USERNAME"
    
    if [ "$FORCE" = false ]; then
        echo ""
        read -p "Are you sure you want to delete user '$USERNAME'? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            log "Deletion cancelled"
            exit 0
        fi
    fi
    
    # Simulate deletion
    echo "  → Revoking user permissions..."
    sleep 0.3
    echo "  → Removing user data..."
    sleep 0.3
    echo "  → Cleaning up user sessions..."
    sleep 0.3
    
    log "User '$USERNAME' deleted successfully!"
}

update_user() {
    if [ -z "$USERNAME" ]; then
        echo "Error: Username is required for update"
        exit 1
    fi
    
    if [ -z "$ROLE" ] && [ -z "$EMAIL" ]; then
        echo "Error: At least one field (role or email) must be provided for update"
        exit 1
    fi
    
    log "Updating user: $USERNAME"
    
    if [ -n "$ROLE" ]; then
        validate_role "$ROLE"
        echo "  → Updating role to: $ROLE"
        sleep 0.3
    fi
    
    if [ -n "$EMAIL" ]; then
        validate_email "$EMAIL"
        echo "  → Updating email to: $EMAIL"
        sleep 0.3
    fi
    
    log "User '$USERNAME' updated successfully!"
}

list_users() {
    log "Listing all users..."
    echo ""
    printf "%-15s %-15s %-30s %-20s\n" "USERNAME" "ROLE" "EMAIL" "CREATED"
    echo "--------------------------------------------------------------------------------"
    
    # Simulated user data
    printf "%-15s %-15s %-30s %-20s\n" "alice" "admin" "alice@example.com" "2024-01-15"
    printf "%-15s %-15s %-30s %-20s\n" "bob" "developer" "bob@example.com" "2024-02-20"
    printf "%-15s %-15s %-30s %-20s\n" "charlie" "viewer" "charlie@example.com" "2024-03-10"
    printf "%-15s %-15s %-30s %-20s\n" "david" "operator" "david@example.com" "2024-04-05"
    
    echo ""
    log "Total users: 4"
}

# Parse action (first argument)
if [ $# -eq 0 ]; then
    usage
fi

ACTION=$1
shift

# Validate action
case $ACTION in
    create|delete|update|list)
        ;;
    -h|--help)
        usage
        ;;
    *)
        echo "Error: Unknown action '$ACTION'"
        echo "Valid actions: create, delete, update, list"
        exit 1
        ;;
esac

# Parse remaining arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--username)
            USERNAME="$2"
            shift 2
            ;;
        -r|--role)
            ROLE="$2"
            shift 2
            ;;
        -e|--email)
            EMAIL="$2"
            shift 2
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Execute action
echo "=== User Management Tool ==="
echo ""

case $ACTION in
    create)
        create_user
        ;;
    delete)
        delete_user
        ;;
    update)
        update_user
        ;;
    list)
        list_users
        ;;
esac

echo ""
echo "Operation completed at $(date)"
