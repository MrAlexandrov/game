# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a multiplayer quiz game system with a C++ backend (userver framework) and Python Telegram bot frontend. The project uses Git submodules for backend and frontend components.

### Repository Structure
- `backend/` - C++ game backend service (submodule: game_userver)
- `frontend/telegram_bot/` - Python Telegram bot client (submodule: game_bot)
- Root contains Docker Compose orchestration for the full stack

## Common Commands

### Full Stack Operations

```bash
# Start all services (postgres + backend + telegram bot)
make up

# Stop all services
make down

# View logs
make logs

# Restart all services
make restart

# Clean all data and stop services
make clean
```

### Backend-Only Testing

```bash
# Start only backend + postgres (useful for API testing)
make backend-only

# Stop backend services
make backend-down

# Test backend API
curl http://localhost:8080/ping
curl http://localhost:8080/packs
```

### Backend Development (in backend/ directory)

```bash
cd backend

# Build
make build-debug          # Debug build
make build-release        # Release build

# Test
make test-debug           # Run all tests in debug mode
make test-release         # Run all tests in release mode

# Format code
make format               # Format C++ sources with clang-format

# Start locally (macOS)
make start-debug          # Starts postgres in Docker, runs binary locally
make start-release

# Clean
make dist-clean           # Remove all build artifacts

# Docker operations
make docker-build         # Build Docker image
make docker-start-debug   # Run debug build in container
make docker-clean-data    # Stop and remove volumes
```

### Running Single Tests (Backend)

```bash
cd backend

# Build and run specific test file
cmake --build build_debug -j $(nproc)
cd build_debug
ctest -R test_name -V  # Replace test_name with specific test

# Example: Run only pack CRUD tests
ctest -R test_pack_crud -V
```

### Telegram Bot Development

```bash
cd frontend/telegram_bot

# Install dependencies
poetry install

# Run bot
poetry run python bot.py
# or
poetry shell
python bot.py

# Configure bot token in .env file
cp .env.example .env
# Edit .env and set TELEGRAM_BOT_TOKEN
```

## Architecture

### High-Level System Architecture

The system follows a three-tier architecture:

```
Telegram Bot (Python) → HTTP REST API → Backend (C++/userver) → PostgreSQL
                         (port 8080)      (GameService)
                         gRPC (port 8081)
```

### Backend Architecture (C++ userver)

The backend follows a layered architecture:

1. **Presentation Layer** (`src/handlers/`)
   - HTTP and gRPC handlers
   - Thin layer for request validation and routing
   - Game handlers: `game/{create_game_session, add_player, start_game, get_game_state, submit_answer, get_game_results}.cpp`
   - Content handlers: `content_handling/{pack, question, variant}/`

2. **Business Logic Layer** (`src/logic/`)
   - **GameService** (`logic/game/game.cpp`) - Core game session management
   - **Observer Pattern** - Event-driven architecture for game events
     - `GameSessionCreatedEvent`, `PlayerAddedEvent`, `GameStartedEvent`
     - `AnswerSubmittedEvent`, `QuestionAdvancedEvent`, `GameFinishedEvent`
   - **Validator Factory** - Polymorphic answer validation for different question types

3. **Data Access Layer** (`src/storage/`)
   - Repository pattern for database access
   - Separate repositories: `game_sessions`, `players`, `player_answers`, `packs`, `questions`, `variants`
   - SQL queries stored in `src/queries/*.sql`

4. **Domain Models** (`src/models/`)
   - Core entities: `GameSession`, `Player`, `PlayerAnswer`, `Pack`, `Question`, `Variant`
   - Enum types: `QuestionType`

### Component System (userver)

**GameServiceComponent** (`src/components/game_service/game_service_component.hpp`):
- Singleton component providing single GameService instance across the server
- Preserves state between requests
- Registered in `src/main.cpp` and configured in `configs/static_config.yaml`

**Dependency Injection Pattern**:
```cpp
// Handlers receive GameService via DI:
auto& game_service = context.FindComponent<GameServiceComponent>().GetGameService();
```

### Key Design Patterns

- **Observer Pattern**: GameService notifies observers about game events
  - `LoggingObserver` - logs game events
  - `NotificationObserver` - sends real-time notifications
  - `StatisticsObserver` - tracks game statistics

- **Repository Pattern**: All database access goes through storage layer

- **Factory Pattern**: ValidatorFactory creates appropriate validators for question types

### Database Schema

PostgreSQL database with tables:
- `packs` - Quiz question packs
- `questions` - Questions with types (multiple choice, free text)
- `variants` - Answer variants for questions
- `game_sessions` - Active game sessions
- `players` - Players in games
- `player_answers` - Player responses and scores
- `text_answers` - Free text answers

Initial schema: `backend/postgresql/schemas/db_1.sql`

### API Endpoints

**Content Management**:
- `GET /packs` - Get all question packs
- `POST /packs` - Create pack
- `GET /packs/{pack_id}` - Get pack by ID
- `POST /packs/{pack_id}/questions` - Create question
- `GET /questions/{question_id}` - Get question
- `POST /questions/{question_id}/variants` - Create answer variant

**Game Management**:
- `POST /games` - Create game session
- `POST /games/{game_id}/players` - Add player
- `POST /games/{game_id}/start` - Start game
- `GET /games/{game_id}/state` - Get current question
- `POST /games/{game_id}/answers` - Submit answer
- `GET /games/{game_id}/results` - Get final results

## Technology Stack

### Backend
- **Language**: C++23
- **Framework**: userver (async HTTP/gRPC server)
- **Database**: PostgreSQL 14+
- **Build**: CMake 3.12+, gcc-13/g++-13
- **Testing**: pytest + userver testsuite, Google Test

### Frontend
- **Language**: Python 3.7+
- **Framework**: python-telegram-bot
- **Package Manager**: Poetry
- **HTTP Client**: aiohttp

## Development Notes

### Working with Submodules

```bash
# Update submodules after cloning
git submodule update --init --recursive

# Pull latest changes in submodules
cd backend && git pull origin main
cd ../frontend/telegram_bot && git pull origin main

# Commit submodule updates in parent repo
git add backend frontend/telegram_bot
git commit -m "Update submodules"
```

### Backend Build System

- **Presets**: `debug` or `release` (can add custom in `CMakeUserPresets.json`)
- **Makefile targets** use pattern `<action>-<preset>` (e.g., `build-debug`, `test-release`)
- **macOS-specific**: Special CMake flags for Homebrew dependencies (see `backend/Makefile`)
- **Docker**: Multi-stage build in `backend/Dockerfile`, runs with `run_as_user.sh` for proper permissions

### Testing Strategy

**Backend Tests** (`backend/tests/`):
- `basic/` - Basic HTTP, gRPC, and PostgreSQL connectivity tests
- `crud/` - End-to-end CRUD operations for packs, questions, variants
- `handlers/` - API endpoint integration tests
- `unit/` - C++ unit tests using Google Test

**Test Configuration**:
- Uses userver testsuite with PostgreSQL fixtures
- Only uses `db_1` schema (configured in `conftest.py`)
- Fixtures for creating test packs, questions, variants

### Configuration Files

- `configs/static_config.yaml` - Static userver configuration (components, handlers)
- `configs/config_vars.yaml` - Configuration variables (ports, connection strings)
- `configs/config_vars.docker.yaml` - Docker-specific overrides
- `configs/config_vars.testing.yaml` - Test environment settings

### Known Issues and TODOs

From `backend/docs/BACKEND_ARCHITECTURE.md`:

1. **Transaction Safety**: Critical operations in `SubmitAnswer()` lack transaction wrapping
   - Multiple DB operations without atomicity can lead to inconsistent state
   - Need to wrap in `pg_cluster_->Begin()` transactions

2. **Race Conditions**: "All players answered" check has race condition
   - Use PostgreSQL advisory locks or `SELECT FOR UPDATE`

3. **Horizontal Scaling**: GameService is singleton per instance
   - For multi-instance deployment, need Redis for shared state
   - Observers don't work across instances without pub/sub

### Port Configuration

- `5432` - PostgreSQL
- `8080` - Backend HTTP API
- `8081` - Backend gRPC API

### Environment Variables

Create `.env` from `.env.example` in project root and `frontend/telegram_bot/`:
- `TELEGRAM_BOT_TOKEN` - Telegram bot token from @BotFather
- `API_BASE_URL` - Backend URL (default: http://localhost:8080)
- Database credentials in `docker-compose.yml` environment section

## Code Style

- **C++**: Follow `.clang-format` configuration, run `make format` in backend
- **Python**: Follow PEP 8, uses pycodestyle in test suite
- **SQL**: Stored in separate `.sql` files in `src/queries/`
