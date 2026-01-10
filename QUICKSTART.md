# Быстрый старт

## Первый запуск

1. **Клонируйте с подмодулями:**
   ```bash
   git clone --recurse-submodules <repo-url>
   cd game
   ```

2. **Настройте окружение:**
   ```bash
   cp .env.example .env
   # Отредактируйте .env и добавьте токен бота
   ```

3. **Запустите:**
   ```bash
   make up
   ```

## Основные команды

```bash
# Запустить всё (postgres + backend + bot)
make up

# Запустить только бэкенд для тестирования
make backend-only

# Посмотреть логи
make logs

# Остановить
make down

# Остановить только бэкенд
make backend-down

# Очистить всё (включая данные БД)
make clean

# Показать все команды
make help
```

## Тестирование

### Тестирование бэкенда

```bash
# Запустите только бэкенд
make backend-only

# Проверьте работу
curl http://localhost:8080/ping
curl http://localhost:8080/packs

# Остановите
make backend-down
```

### Тестирование полного стека

```bash
# Запустите всё
make up

# Откройте Telegram и найдите вашего бота
# Отправьте /start

# Остановите
make down
```

## Структура файлов

- `docker-compose.yml` - Полный стек (всё вместе)
- `docker-compose.backend.yml` - Только бэкенд + postgres
- `Makefile` - Удобные команды
- `.env` - Ваши настройки (создайте из `.env.example`)

## Порты

- `5432` - PostgreSQL
- `8080` - Backend HTTP API
- `8081` - Backend gRPC

## Что дальше?

1. Создайте тестовые данные через API
2. Протестируйте бота в Telegram
3. Смотрите логи: `make logs`
4. Читайте полную документацию в `README.md`