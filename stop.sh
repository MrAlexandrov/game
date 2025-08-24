#!/bin/bash

# Script to stop the entire game stack

echo "Stopping game stack..."

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found!"
    exit 1
fi

# Stop the entire stack
docker-compose down

echo "Game stack stopped."