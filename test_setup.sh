#!/bin/bash

# Script to test the unified project setup

echo "Testing unified game project setup..."

# Check if required directories exist
if [ ! -d "backend" ]; then
    echo "Error: backend directory not found!"
    exit 1
fi

if [ ! -d "frontend" ]; then
    echo "Error: frontend directory not found!"
    exit 1
fi

if [ ! -d "frontend/telegram_bot" ]; then
    echo "Error: frontend/telegram_bot directory not found!"
    exit 1
fi

# Check if required files exist
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found!"
    exit 1
fi

if [ ! -f "run.sh" ]; then
    echo "Error: run.sh not found!"
    exit 1
fi

if [ ! -f "stop.sh" ]; then
    echo "Error: stop.sh not found!"
    exit 1
fi

if [ ! -f "README.md" ]; then
    echo "Error: README.md not found!"
    exit 1
fi

if [ ! -f "DEVELOPMENT.md" ]; then
    echo "Error: DEVELOPMENT.md not found!"
    exit 1
fi

# Check backend files
if [ ! -f "backend/docker-compose.dev.yml" ]; then
    echo "Error: backend/docker-compose.dev.yml not found!"
    exit 1
fi

if [ ! -f "backend/README.md" ]; then
    echo "Error: backend/README.md not found!"
    exit 1
fi

# Check frontend files
if [ ! -f "frontend/telegram_bot/README.md" ]; then
    echo "Error: frontend/telegram_bot/README.md not found!"
    exit 1
fi

if [ ! -f "frontend/telegram_bot/requirements.txt" ]; then
    echo "Error: frontend/telegram_bot/requirements.txt not found!"
    exit 1
fi

echo "✅ All required files and directories are present!"
echo "✅ Unified project setup is correct!"

echo ""
echo "Next steps:"
echo "1. Set your TELEGRAM_BOT_TOKEN environment variable"
echo "2. Run './run.sh' to start the full stack"
echo "3. Test the Telegram bot in your Telegram client"