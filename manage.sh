#!/bin/bash

# Nginx Reverse Proxy Management Script

set -e

COMPOSE_FILE="docker-compose.yml"

show_help() {
    echo "Nginx Reverse Proxy Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start all services"
    echo "  stop      Stop all services"
    echo "  restart   Restart all services"
    echo "  status    Show service status"
    echo "  logs      Show logs for all services"
    echo "  logs-ui   Show Nginx UI logs"
    echo "  logs-proxy Show Nginx proxy logs"
    echo "  config    Validate configuration"
    echo "  clean     Stop and remove all containers and volumes"
    echo "  help      Show this help message"
    echo ""
    echo "Access URLs:"
    echo "  Reverse Proxy: http://localhost"
    echo "  Nginx UI:      http://localhost:8080"
    echo "  Admin Panel:   http://localhost/admin"
}

start_services() {
    echo "🚀 Starting Nginx Reverse Proxy services..."
    docker-compose up -d
    echo ""
    echo "✅ Services started successfully!"
    echo ""
    echo "Access URLs:"
    echo "  🌐 Reverse Proxy: http://localhost"
    echo "  ⚙️  Nginx UI:      http://localhost:8080"
    echo "  🔧 Admin Panel:   http://localhost/admin"
    echo ""
    echo "Default Nginx UI credentials:"
    echo "  Username: admin"
    echo "  Password: admin"
    echo ""
    echo "💡 Remember to change the default password on first login!"
}

stop_services() {
    echo "🛑 Stopping Nginx Reverse Proxy services..."
    docker-compose down
    echo "✅ Services stopped successfully!"
}

restart_services() {
    echo "🔄 Restarting Nginx Reverse Proxy services..."
    docker-compose restart
    echo "✅ Services restarted successfully!"
}

show_status() {
    echo "📊 Service Status:"
    docker-compose ps
    echo ""
    echo "🔍 Health Checks:"
    echo "  Proxy Health: curl -s http://localhost/health"
    echo "  UI Health:    curl -s http://localhost:8080"
}

show_logs() {
    echo "📋 Showing logs for all services (Ctrl+C to exit):"
    docker-compose logs -f
}

show_ui_logs() {
    echo "📋 Showing Nginx UI logs (Ctrl+C to exit):"
    docker-compose logs -f nginx-ui
}

show_proxy_logs() {
    echo "📋 Showing Nginx Proxy logs (Ctrl+C to exit):"
    docker-compose logs -f nginx-proxy
}

validate_config() {
    echo "🔍 Validating configuration..."
    docker-compose config > /dev/null
    echo "✅ Docker Compose configuration is valid!"
    
    if [ -f "validate-config.sh" ]; then
        echo "🔍 Running additional configuration tests..."
        bash validate-config.sh
    fi
}

clean_all() {
    echo "🧹 Cleaning up all containers and volumes..."
    echo "⚠️  WARNING: This will remove all data including Nginx UI configurations!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v --remove-orphans
        echo "✅ Cleanup completed!"
    else
        echo "❌ Cleanup cancelled."
    fi
}

# Main script logic
case "${1:-help}" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    logs-ui)
        show_ui_logs
        ;;
    logs-proxy)
        show_proxy_logs
        ;;
    config)
        validate_config
        ;;
    clean)
        clean_all
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac