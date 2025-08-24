# Game Project Development Guide

This guide explains how to set up and develop the unified game project.

## Project Structure

```
game/
├── backend/              # Quiz game backend service
├── frontend/             # All frontend clients
│   └── telegram_bot/     # Telegram bot client
├── docker-compose.yml    # Root docker-compose for full stack
├── run.sh                # Script to start full stack
└── stop.sh               # Script to stop full stack
```

## Prerequisites

- Docker and Docker Compose
- Python 3.7+ (for Telegram bot development)
- C++ compiler (for backend development)

## Running the Full Stack

To run the entire game stack (database, backend, and Telegram bot):

```bash
./run.sh
```

This will start all services using Docker Compose.

To stop the stack:

```bash
./stop.sh
```

## Backend Development

### Running Backend Only

To run only the backend service with database:

```bash
cd backend
docker-compose -f docker-compose.dev.yml up
```

### Backend Development Workflow

1. Make changes to the C++ code in `backend/src/`
2. The service will automatically rebuild and restart in development mode
3. Test the changes using gRPC clients or the Telegram bot

### Backend Services

- HTTP API: http://localhost:8080
- gRPC API: localhost:8081
- Database: localhost:15433

## Frontend Development

### Telegram Bot Development

To run only the Telegram bot for development:

```bash
cd frontend/telegram_bot
python main.py
```

### Telegram Bot Configuration

The Telegram bot requires the following environment variables:

- `TELEGRAM_BOT_TOKEN` - Your Telegram bot token
- `BACKEND_GRPC_ADDRESS` - Address of the backend gRPC service (defaults to localhost:8081)

## Testing

### Backend Testing

To run backend tests:

```bash
cd backend
make test-debug
```

## Building

### Backend Building

To manually build the backend service:

```bash
cd backend
make build-debug
```

Or for release build:

```bash
cd backend
make build-release
```

## Adding New Features

### Adding New gRPC Methods

1. Update the proto files in `backend/proto/`
2. Regenerate the proto code: `cd backend && ./generate_proto.sh`
3. Implement the new methods in the service
4. Update the Telegram bot gRPC client if needed

### Adding New Frontend Clients

1. Create a new directory under `frontend/` (e.g., `frontend/web_client/`)
2. Implement the client to communicate with the backend via gRPC
3. Update the root `docker-compose.yml` to include the new service

## Troubleshooting

### Common Issues

1. **Database connection errors**: Make sure the database service is running and the connection string is correct.

2. **gRPC connection errors**: Verify that the backend service is running and the gRPC address is correct.

3. **Proto import errors**: Make sure you've run the proto generation script after making changes to proto files.

### Logs

To view logs for specific services:

```bash
docker-compose logs <service_name>
```

For example:
```bash
docker-compose logs backend
docker-compose logs telegram_bot