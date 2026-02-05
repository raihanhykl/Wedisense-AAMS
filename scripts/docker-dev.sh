#!/bin/bash

# WediSense AMS - Docker Development Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

case "$1" in
    up)
        print_status "Starting development environment..."
        docker-compose up -d
        print_status "Waiting for services to be ready..."
        sleep 5
        print_status "Running database migrations..."
        docker-compose exec backend npx prisma migrate deploy
        print_status "Development environment is ready!"
        print_status "Frontend: http://localhost:3000"
        print_status "Backend:  http://localhost:4000"
        print_status "Database: localhost:5432"
        ;;
    down)
        print_status "Stopping development environment..."
        docker-compose down
        print_status "Development environment stopped."
        ;;
    restart)
        print_status "Restarting development environment..."
        docker-compose restart
        print_status "Development environment restarted."
        ;;
    logs)
        docker-compose logs -f ${2:-}
        ;;
    db-migrate)
        print_status "Running database migrations..."
        docker-compose exec backend npx prisma migrate dev
        print_status "Migrations completed."
        ;;
    db-studio)
        print_status "Opening Prisma Studio..."
        docker-compose exec backend npx prisma studio
        ;;
    db-reset)
        print_warning "This will reset the database. All data will be lost!"
        read -p "Are you sure? (y/N) " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            docker-compose exec backend npx prisma migrate reset --force
            print_status "Database reset completed."
        else
            print_status "Database reset cancelled."
        fi
        ;;
    shell)
        service=${2:-backend}
        print_status "Opening shell in $service..."
        docker-compose exec $service sh
        ;;
    clean)
        print_warning "This will remove all containers, volumes, and images for this project."
        read -p "Are you sure? (y/N) " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            docker-compose down -v --rmi local
            print_status "Cleanup completed."
        else
            print_status "Cleanup cancelled."
        fi
        ;;
    *)
        echo "WediSense AMS - Docker Development Script"
        echo ""
        echo "Usage: $0 {command}"
        echo ""
        echo "Commands:"
        echo "  up          Start development environment"
        echo "  down        Stop development environment"
        echo "  restart     Restart all services"
        echo "  logs [svc]  View logs (optionally for specific service)"
        echo "  db-migrate  Run database migrations"
        echo "  db-studio   Open Prisma Studio"
        echo "  db-reset    Reset database (WARNING: deletes all data)"
        echo "  shell [svc] Open shell in container (default: backend)"
        echo "  clean       Remove all containers and volumes"
        ;;
esac