# Game Project

This is a unified game project with a backend service and multiple frontend clients.

## Project Structure

- `backend/` - The quiz game backend service built with userver framework (submodule)
- `frontend/` - All frontend clients
  - `telegram_bot/` - Telegram bot client for the quiz game (submodule)

## Backend

The backend is a C++ service built with the [userver framework](https://github.com/userver-framework/userver) that provides:

- Quiz pack management (create, list, etc.)
- Question and answer management
- Game session management
- Player management
- HTTP REST API for frontend clients

### Features

- PostgreSQL database storage
- HTTP REST API for communication with frontend clients
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

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Telegram Bot Token (get it from [@BotFather](https://t.me/botfather))

### Setup

1. Clone the repository with submodules:
```bash
git clone --recurse-submodules <repository-url>
cd game
```

If you already cloned without submodules:
```bash
git submodule update --init --recursive
```

2. Create a `.env` file from the example:
```bash
cp .env.example .env
```

3. Edit `.env` and add your Telegram bot token:
```bash
TELEGRAM_BOT_TOKEN=your_actual_bot_token_here
```

### Running the Services

Start all services (database, backend, and Telegram bot):

```bash
docker compose up -d
```

This will start:
1. PostgreSQL database on port 5432
2. Backend service on port 8080 (HTTP API) and 8081 (gRPC)
3. Telegram bot (connected to your bot token)

### Viewing Logs

To view logs from all services:
```bash
docker compose logs -f
```

To view logs from a specific service:
```bash
docker compose logs -f backend
docker compose logs -f telegram_bot
docker compose logs -f postgres
```

### Stopping the Services

```bash
docker compose down
```

To also remove volumes (database data):
```bash
docker compose down -v
```

## Development

### Backend Development

The backend is located in the `backend/` directory (submodule). See [backend/README.md](backend/README.md) for detailed backend development instructions.

To rebuild the backend after making changes:
```bash
docker compose up -d --build backend
```

### Telegram Bot Development

The Telegram bot is located in the `frontend/telegram_bot/` directory (submodule). See [frontend/telegram_bot/README.md](frontend/telegram_bot/README.md) for detailed bot development instructions.

To rebuild the bot after making changes:
```bash
docker compose up -d --build telegram_bot
```

### Testing the API

You can test the backend API directly:

```bash
# Get all packs
curl http://localhost:8080/packs

# Create a game session (replace PACK_ID with actual pack ID)
curl -X POST http://localhost:8080/games \
  -H "Content-Type: application/json" \
  -d '{"pack_id": "PACK_ID"}'

# Add a player (replace GAME_ID with actual game ID)
curl -X POST http://localhost:8080/games/GAME_ID/players \
  -H "Content-Type: application/json" \
  -d '{"player_name": "TestPlayer"}'
```

## Configuration

### Backend

The backend service can be configured through environment variables in `docker-compose.yml`:

- `DB_CONNECTION` - PostgreSQL connection string
- `CPU_LIMIT` - CPU limit for the service

### Telegram Bot

The Telegram bot requires the following environment variables:

- `TELEGRAM_BOT_TOKEN` - Your Telegram bot token (required)
- `API_BASE_URL` - Backend API URL (default: http://backend:8080)

## Troubleshooting

### Backend won't start

1. Check if PostgreSQL is healthy:
```bash
docker compose ps
```

2. Check backend logs:
```bash
docker compose logs backend
```

### Telegram bot won't start

1. Verify your bot token is correct in `.env`
2. Check bot logs:
```bash
docker compose logs telegram_bot
```

3. Ensure backend is running:
```bash
curl http://localhost:8080/ping
```

### Database issues

To reset the database:
```bash
docker compose down -v
docker compose up -d
```

## API Documentation

### Content Management

- `GET /packs` - Get all quiz packs
- `POST /packs` - Create a new pack
- `GET /packs/{pack_id}` - Get pack by ID
- `POST /packs/{pack_id}/questions` - Create a question
- `GET /questions/{question_id}` - Get question by ID
- `POST /questions/{question_id}/variants` - Create answer variant

### Game Management

- `POST /games` - Create a game session
- `POST /games/{game_id}/players` - Add a player
- `POST /games/{game_id}/start` - Start the game
- `GET /games/{game_id}/state` - Get current game state
- `POST /games/{game_id}/answers` - Submit an answer
- `GET /games/{game_id}/results` - Get game results

## License

This project is licensed under the Apache-2.0 License - see the [LICENSE](LICENSE) file for details.