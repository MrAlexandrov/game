# Показать справку
.PHONY: help
help:
	@echo "🎮 Game Project - Управление сервисами"
	@echo ""
	@echo "Доступные команды:"
	@echo "  make up              - Запустить все сервисы (backend + bot + postgres)"
	@echo "  make down            - Остановить все сервисы"
	@echo "  make logs            - Показать логи всех сервисов"
	@echo "  make restart         - Перезапустить все сервисы"
	@echo ""
	@echo "  make backend-only    - Запустить только backend + postgres (для тестирования)"
	@echo "  make backend-down    - Остановить backend-only сервисы"
	@echo ""
	@echo "  make clean           - Остановить всё и удалить данные"
	@echo ""
	@echo "Примеры:"
	@echo "  make up              # Запустить всё"
	@echo "  make backend-only    # Только бэкенд для тестирования"
	@echo "  make logs            # Посмотреть логи"

# Запустить все сервисы (полный стек)
.PHONY: up
up:
	@echo "🚀 Запускаю все сервисы..."
	docker compose up -d
	@echo "✅ Сервисы запущены!"
	@echo "📊 Статус:"
	@docker compose ps
	@echo ""
	@echo "💡 Полезные команды:"
	@echo "   make logs          - Посмотреть логи"
	@echo "   make down          - Остановить сервисы"

# Остановить все сервисы
.PHONY: down
down:
	@echo "🛑 Останавливаю сервисы..."
	docker compose down
	@echo "✅ Сервисы остановлены"

# Показать логи
.PHONY: logs
logs:
	docker compose logs -f

# Перезапустить все сервисы
.PHONY: restart
restart:
	@echo "🔄 Перезапускаю сервисы..."
	docker compose restart
	@echo "✅ Сервисы перезапущены"

# Запустить только backend + postgres (для тестирования)
.PHONY: backend-only
backend-only:
	@echo "🔧 Запускаю только backend + postgres..."
	docker compose -f docker-compose.backend.yml up -d
	@echo "✅ Backend сервисы запущены!"
	@echo "📊 Статус:"
	@docker compose -f docker-compose.backend.yml ps
	@echo ""
	@echo "🌐 Backend доступен на:"
	@echo "   HTTP API: http://localhost:8080"
	@echo "   gRPC:     localhost:8081"
	@echo ""
	@echo "💡 Тестирование:"
	@echo "   curl http://localhost:8080/ping"
	@echo "   curl http://localhost:8080/packs"

# Остановить backend-only сервисы
.PHONY: backend-down
backend-down:
	@echo "🛑 Останавливаю backend сервисы..."
	docker compose -f docker-compose.backend.yml down
	@echo "✅ Backend сервисы остановлены"

# Остановить всё и удалить данные
.PHONY: clean
clean:
	@echo "🧹 Очистка всех данных..."
	docker compose down -v
	docker compose -f docker-compose.backend.yml down -v
	@echo "✅ Все данные удалены"
