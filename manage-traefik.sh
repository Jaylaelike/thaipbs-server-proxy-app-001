#!/bin/bash

# Traefik Reverse Proxy Management Script

set -e

COMPOSE_FILE="docker-compose.yml"

show_help() {
    echo "Traefik Reverse Proxy Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start Traefik reverse proxy"
    echo "  stop      Stop Traefik reverse proxy"
    echo "  restart   Restart Traefik reverse proxy"
    echo "  status    Show service status"
    echo "  logs      Show Traefik logs"
    echo "  config    Validate configuration"
    echo "  dashboard Open Traefik dashboard"
    echo "  clean     Stop and remove all containers and volumes"
    echo "  help      Show this help message"
    echo ""
    echo "Access URLs:"
    echo "  Reverse Proxy: http://localhost"
    echo "  Traefik Dashboard: http://localhost:8080"
}

start_services() {
    echo "🚀 Starting Traefik Reverse Proxy..."
    docker-compose up -d
    echo ""
    echo "✅ Traefik started successfully!"
    echo ""
    echo "Access URLs:"
    echo "  🌐 Reverse Proxy: http://localhost"
    echo "  📊 Traefik Dashboard: http://localhost:8080"
    echo ""
    echo "Available Routes:"
    echo "  📍 /map → 172.16.116.82:3000"
    echo "  📍 /data → 172.16.116.82:8501"
    echo "  📍 /pm25 → 172.16.116.82:3002"
    echo "  📍 /pm25infuxd → 172.16.116.82:8086"
    echo "  📍 /health → Health check"
    echo ""
    echo "💡 Check the dashboard for real-time routing information!"
}

stop_services() {
    echo "🛑 Stopping Traefik Reverse Proxy..."
    docker-compose down
    echo "✅ Traefik stopped successfully!"
}

restart_services() {
    echo "🔄 Restarting Traefik Reverse Proxy..."
    docker-compose restart
    echo "✅ Traefik restarted successfully!"
}

show_status() {
    echo "📊 Service Status:"
    docker-compose ps
    echo ""
    echo "🔍 Health Checks:"
    echo "  Traefik Health: curl -s http://localhost:8080/ping"
    echo "  Service Health: curl -s http://localhost/health"
}

show_logs() {
    echo "📋 Showing Traefik logs (Ctrl+C to exit):"
    docker-compose logs -f traefik
}

validate_config() {
    echo "🔍 Validating configuration..."
    docker-compose config > /dev/null
    echo "✅ Docker Compose configuration is valid!"
    
    if [ -f "traefik/dynamic.yml" ]; then
        echo "✅ Traefik dynamic configuration found!"
    else
        echo "❌ Traefik dynamic configuration missing!"
        exit 1
    fi
}

open_dashboard() {
    echo "🌐 Opening Traefik Dashboard..."
    if command -v open &> /dev/null; then
        open http://localhost:8080
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:8080
    elif command -v start &> /dev/null; then
        start http://localhost:8080
    else
        echo "📊 Dashboard URL: http://localhost:8080"
        echo "Please open this URL in your browser manually."
    fi
}

clean_all() {
    echo "🧹 Cleaning up all containers and volumes..."
    echo "⚠️  WARNING: This will remove all data!"
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
    config)
        validate_config
        ;;
    dashboard)
        open_dashboard
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