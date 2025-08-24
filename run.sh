#!/bin/bash

# Script to run the entire game stack

echo "Starting game stack..."

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found!"
    exit 1
fi

# Start the entire stack
docker-compose up

echo "Game stack stopped."