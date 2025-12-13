#!/bin/bash

# Practical Example: Docker Wrapper
# Demonstrates: Complex command building, option passthrough, container management

set -euo pipefail

ACTION=""
IMAGE=""
CONTAINER_NAME=""
PORTS=()
VOLUMES=()
ENV_VARS=()
DETACHED=false
INTERACTIVE=false
REMOVE=false
NETWORK=""

usage() {
    cat << 'EOF'
Docker Wrapper - Simplified Docker Container Management

Usage: ./05-practical_arguments_docker_wrapper.sh ACTION [OPTIONS]

Actions:
    run IMAGE           Run a new container
    start NAME          Start an existing container
    stop NAME           Stop a running container
    logs NAME           View container logs
    exec NAME CMD       Execute command in container
    rm NAME             Remove a container
    ps                  List containers

Options for 'run':
    -n, --name NAME         Container name
    -p, --port HOST:CONT    Port mapping (can be used multiple times)
    -v, --volume HOST:CONT  Volume mapping (can be used multiple times)
    -e, --env KEY=VALUE     Environment variable (can be used multiple times)
    -d, --detach            Run in detached mode
    -i, --interactive       Run in interactive mode
    --rm                    Remove container on exit
    --network NET           Connect to network

Examples:
    # Run nginx with port mapping
    ./05-practical_arguments_docker_wrapper.sh run nginx -n web -p 8080:80 -d

    # Run with volume and environment
    ./05-practical_arguments_docker_wrapper.sh run postgres \
        -n db -p 5432:5432 \
        -v /data:/var/lib/postgresql/data \
        -e POSTGRES_PASSWORD=secret -d

    # Interactive shell
    ./05-practical_arguments_docker_wrapper.sh run ubuntu -i --rm

    # Start existing container
    ./05-practical_arguments_docker_wrapper.sh start web

    # View logs
    ./05-practical_arguments_docker_wrapper.sh logs web

    # Execute command
    ./05-practical_arguments_docker_wrapper.sh exec web ls -la

EOF
    exit 0
}

log() {
    echo "[DOCKER] $*"
}

build_docker_command() {
    local cmd="docker run"
    
    if [ "$DETACHED" = true ]; then
        cmd="$cmd -d"
    fi
    
    if [ "$INTERACTIVE" = true ]; then
        cmd="$cmd -it"
    fi
    
    if [ "$REMOVE" = true ]; then
        cmd="$cmd --rm"
    fi
    
    if [ -n "$CONTAINER_NAME" ]; then
        cmd="$cmd --name $CONTAINER_NAME"
    fi
    
    if [ -n "$NETWORK" ]; then
        cmd="$cmd --network $NETWORK"
    fi
    
    for port in "${PORTS[@]}"; do
        cmd="$cmd -p $port"
    done
    
    for volume in "${VOLUMES[@]}"; do
        cmd="$cmd -v $volume"
    done
    
    for env in "${ENV_VARS[@]}"; do
        cmd="$cmd -e $env"
    done
    
    cmd="$cmd $IMAGE"
    
    echo "$cmd"
}

run_container() {
    if [ -z "$IMAGE" ]; then
        echo "Error: Image name is required"
        exit 1
    fi
    
    log "Preparing to run container from image: $IMAGE"
    
    local docker_cmd=$(build_docker_command)
    
    echo ""
    echo "Docker command:"
    echo "  $docker_cmd"
    echo ""
    
    log "Pulling image if needed..."
    sleep 0.3
    log "Creating container..."
    sleep 0.3
    
    if [ "$DETACHED" = true ]; then
        log "Starting container in detached mode..."
        echo "Container ID: abc123def456"
        echo ""
        log "Container started successfully!"
        [ -n "$CONTAINER_NAME" ] && echo "Container name: $CONTAINER_NAME"
    else
        log "Starting container in foreground mode..."
        echo "(Container would run here)"
    fi
}

start_container() {
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Error: Container name is required"
        exit 1
    fi
    
    log "Starting container: $CONTAINER_NAME"
    sleep 0.3
    log "Container '$CONTAINER_NAME' started"
}

stop_container() {
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Error: Container name is required"
        exit 1
    fi
    
    log "Stopping container: $CONTAINER_NAME"
    sleep 0.3
    log "Container '$CONTAINER_NAME' stopped"
}

show_logs() {
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Error: Container name is required"
        exit 1
    fi
    
    log "Fetching logs for container: $CONTAINER_NAME"
    echo ""
    echo "--- Container Logs ---"
    echo "[2024-12-01 10:00:00] Application started"
    echo "[2024-12-01 10:00:01] Listening on port 8080"
    echo "[2024-12-01 10:00:05] Received request: GET /"
    echo "[2024-12-01 10:00:06] Response: 200 OK"
    echo "--- End of Logs ---"
}

exec_command() {
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Error: Container name is required"
        exit 1
    fi
    
    local cmd_args=("$@")
    log "Executing command in container: $CONTAINER_NAME"
    log "Command: ${cmd_args[*]}"
    echo ""
    echo "(Command output would appear here)"
}

remove_container() {
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Error: Container name is required"
        exit 1
    fi
    
    log "Removing container: $CONTAINER_NAME"
    sleep 0.3
    log "Container '$CONTAINER_NAME' removed"
}

list_containers() {
    log "Listing containers..."
    echo ""
    printf "%-15s %-20s %-15s %-10s %-15s\n" "CONTAINER ID" "IMAGE" "NAME" "STATUS" "PORTS"
    echo "--------------------------------------------------------------------------------"
    printf "%-15s %-20s %-15s %-10s %-15s\n" "abc123def456" "nginx:latest" "web" "Up" "8080->80"
    printf "%-15s %-20s %-15s %-10s %-15s\n" "def456ghi789" "postgres:13" "db" "Up" "5432->5432"
    printf "%-15s %-20s %-15s %-10s %-15s\n" "ghi789jkl012" "redis:alpine" "cache" "Up" "6379->6379"
}

# Parse action
if [ $# -eq 0 ]; then
    usage
fi

ACTION=$1
shift

# Handle actions that need additional arguments
case $ACTION in
    run)
        if [ $# -gt 0 ] && [[ ! $1 =~ ^- ]]; then
            IMAGE=$1
            shift
        fi
        ;;
    start|stop|logs|rm)
        if [ $# -gt 0 ] && [[ ! $1 =~ ^- ]]; then
            CONTAINER_NAME=$1
            shift
        fi
        ;;
    exec)
        if [ $# -gt 0 ] && [[ ! $1 =~ ^- ]]; then
            CONTAINER_NAME=$1
            shift
        fi
        ;;
esac

# Parse remaining options
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        -p|--port)
            PORTS+=("$2")
            shift 2
            ;;
        -v|--volume)
            VOLUMES+=("$2")
            shift 2
            ;;
        -e|--env)
            ENV_VARS+=("$2")
            shift 2
            ;;
        -d|--detach)
            DETACHED=true
            shift
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        --rm)
            REMOVE=true
            shift
            ;;
        --network)
            NETWORK="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            # For exec command, collect remaining args as command
            if [ "$ACTION" = "exec" ]; then
                break
            fi
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Execute action
echo "=== Docker Wrapper ==="
echo ""

case $ACTION in
    run)
        run_container
        ;;
    start)
        start_container
        ;;
    stop)
        stop_container
        ;;
    logs)
        show_logs
        ;;
    exec)
        exec_command "$@"
        ;;
    rm)
        remove_container
        ;;
    ps)
        list_containers
        ;;
    *)
        echo "Error: Unknown action: $ACTION"
        exit 1
        ;;
esac

echo ""
echo "Operation completed"
