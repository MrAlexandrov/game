# Game Project

This is a unified game project with a backend service and multiple frontend clients.

## Project Structure

- `backend/` - The quiz game backend service built with userver framework
- `frontend/` - All frontend clients
  - `telegram_bot/` - Telegram bot client for the quiz game

## Backend

The backend is a C++ service built with the [userver framework](https://github.com/userver-framework/userver) that provides:

- Quiz pack management (create, list, etc.)
- Question and answer management
- Game session management
- Player management
- gRPC API for frontend clients

### Features

- PostgreSQL database storage
- gRPC API for communication with frontend clients
- Docker support for easy deployment
- Comprehensive test suite

## Frontend

### Telegram Bot

A Telegram bot client that allows users to play quiz games directly in Telegram.

Features:
- Create and join quiz games
- Play with multiple players
- Real-time game progress
- Score tracking

## Development

### Prerequisites

- Docker and Docker Compose
- Python 3.7+ (for Telegram bot development)
- C++ compiler (for backend development)

### Running the Full Stack

To run both the backend and Telegram bot:

```bash
cd backend
docker-compose -f docker-compose.dev.yml up
```

This will start:
1. PostgreSQL database
2. Backend service
3. Telegram bot service

### Backend Development

See [backend/README.md](backend/README.md) for detailed backend development instructions.

### Telegram Bot Development

See [frontend/telegram_bot/README.md](frontend/telegram_bot/README.md) for detailed Telegram bot development instructions.

## Configuration

### Backend

The backend service can be configured through environment variables:

- `DB_CONNECTION` - PostgreSQL connection string
- `CPU_LIMIT` - CPU limit for the service

### Telegram Bot

The Telegram bot requires the following environment variables:

- `TELEGRAM_BOT_TOKEN` - Your Telegram bot token
- `BACKEND_GRPC_ADDRESS` - Address of the backend gRPC service

## License

This project is licensed under the Apache-2.0 License - see the [LICENSE](LICENSE) file for details.