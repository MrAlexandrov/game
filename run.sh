#!/bin/bash

# Script to run the backend services (database and backend)

echo "Starting backend services (database and backend)..."

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found!"
    exit 1
fi

# Start the backend services
docker-compose up

echo "Backend services stopped."