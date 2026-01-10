# Game Project

Проект игры-викторины с бэкендом на C++ (userver) и Telegram ботом на Python.

## Структура проекта

```
game/
├── backend/              # Бэкенд-сервис (submodule: game_userver)
├── frontend/
│   └── telegram_bot/     # Telegram бот (submodule: game_bot)
├── docker-compose.yml    # Полный стек (postgres + backend + bot)
├── docker-compose.backend.yml  # Только backend + postgres (для тестирования)
└── Makefile             # Удобные команды для управления
```

## Быстрый старт

### 1. Клонирование с подмодулями

```bash
git clone --recurse-submodules <repository-url>
cd game
```

Если уже склонировали без подмодулей:
```bash
git submodule update --init --recursive
```

### 2. Настройка

Создайте `.env` файл:
```bash
cp .env.example .env
```

Добавьте токен Telegram бота (получите у [@BotFather](https://t.me/botfather)):
```bash
TELEGRAM_BOT_TOKEN=your_bot_token_here
```

### 3. Запуск

**Запустить всё (рекомендуется):**
```bash
make up
# или
docker compose up -d
```

**Только бэкенд для тестирования:**
```bash
make backend-only
# или
docker compose -f docker-compose.backend.yml up -d
```

## Команды управления

```bash
make help           # Показать все доступные команды

# Полный стек
make up             # Запустить всё (postgres + backend + bot)
make down           # Остановить всё
make logs           # Показать логи
make restart        # Перезапустить

# Только бэкенд (для тестирования)
make backend-only   # Запустить только backend + postgres
make backend-down   # Остановить backend сервисы

# Очистка
make clean          # Остановить всё и удалить данные
```

## Тестирование API

После запуска бэкенда:

```bash
# Проверка работоспособности
curl http://localhost:8080/ping

# Получить список паков
curl http://localhost:8080/packs

# Создать пак
curl -X POST http://localhost:8080/packs \
  -H "Content-Type: application/json" \
  -d '{"title": "Тестовый квиз"}'
```

## API Endpoints

### Управление контентом
- `GET /packs` - Получить все паки
- `POST /packs` - Создать пак
- `GET /packs/{pack_id}` - Получить пак по ID
- `POST /packs/{pack_id}/questions` - Создать вопрос
- `GET /questions/{question_id}` - Получить вопрос
- `POST /questions/{question_id}/variants` - Создать вариант ответа

### Управление игрой
- `POST /games` - Создать игровую сессию
- `POST /games/{game_id}/players` - Добавить игрока
- `POST /games/{game_id}/start` - Начать игру
- `GET /games/{game_id}/state` - Получить текущее состояние
- `POST /games/{game_id}/answers` - Отправить ответ
- `GET /games/{game_id}/results` - Получить результаты

## Использование Telegram бота

1. Найдите вашего бота в Telegram
2. Отправьте `/start`
3. Используйте `/newgame` для создания игры
4. Выберите пак вопросов
5. Играйте!

## Разработка

### Изменения в бэкенде

```bash
cd backend
# Внесите изменения
cd ..
docker compose up -d --build backend
```

### Изменения в боте

```bash
cd frontend/telegram_bot
# Внесите изменения
cd ../..
docker compose up -d --build telegram_bot
```

## Порты

- `5432` - PostgreSQL
- `8080` - Backend HTTP API
- `8081` - Backend gRPC

## Troubleshooting

### Бэкенд не запускается

```bash
# Проверьте логи
docker compose logs backend

# Проверьте статус postgres
docker compose ps postgres

# Перезапустите
make restart
```

### Бот не отвечает

```bash
# Проверьте токен в .env
cat .env

# Проверьте логи бота
docker compose logs telegram_bot

# Проверьте доступность бэкенда
docker compose exec telegram_bot curl http://backend:8080/ping
```

### Сброс базы данных

```bash
make clean
make up
```

## Архитектура

```
┌─────────────────┐
│  Telegram Bot   │
│   (Python)      │
└────────┬────────┘
         │ HTTP REST API
         │ (port 8080)
         ▼
┌─────────────────┐
│  Backend        │
│  (C++/userver)  │
└────────┬────────┘
         │ PostgreSQL
         │ (port 5432)
         ▼
┌─────────────────┐
│  PostgreSQL     │
│  (Database)     │
└─────────────────┘
```

## Лицензия

Apache-2.0 License