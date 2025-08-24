.PHONY: all run stop backend backend-run backend-stop backend-test bot bot-run bot-stop clean

all: run

run:
	./run.sh

stop:
	./stop.sh

backend:
	cd backend && docker-compose -f docker-compose.dev.yml up

backend-run:
	cd backend && docker-compose -f docker-compose.dev.yml up -d

backend-stop:
	cd backend && docker-compose -f docker-compose.dev.yml down

backend-test:
	cd backend && make test-debug

bot:
	cd frontend/telegram_bot && python main.py

bot-run:
	cd frontend/telegram_bot && python main.py &

bot-stop:
	@pkill -f "python main.py" || true

clean:
	docker-compose down -v
	cd backend && make dist-clean