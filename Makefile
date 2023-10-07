.PHONY: start stop destroy help

provision:
	@make help

pull:
	@docker-compose pull

build:
	@docker-compose build

start-prod:
	@echo Starting prod containers
	@docker-compose up -d

stop-prod:
	@echo Stopping prod instances
	@docker-compose stop

destroy-prod:
	@echo Destroying prod instances
	@docker-compose rm -vfs

start-dev:
	@echo Starting dev containers
	@sh ./bin/dev-mode.sh up -d

stop-dev:
	@echo Stopping dev instances
	@sh ./bin/dev-mode.sh down

start-dev-xdebug:
	@echo Starting dev containers with xdebug
	@XDEBUG_MODE=debug sh ./bin/dev-mode.sh up -d --build

stop-dev-xdebug:
	@echo Stopping dev containers with xdebug
	@XDEBUG_MODE=debug sh ./bin/dev-mode.sh down

destroy-dev:
	@echo Destroying wpt instances
	@docker-compose rm -vfs

help:
	@echo  'Targets:'
	@echo  '  pull                   - Download'
	@echo  '  start-prod             - Start'
	@echo  '  stop-prod              - Stop'
	@echo  '  destroy-prod           - Destroy'
	@echo  '  start-dev              - Start'
	@echo  '  start-dev-xdebug       - Start with xdebug'
	@echo  '  stop-dev               - Stop'
	@echo  '  destroy-dev            - Destroy'
	@echo  '  help              - Print this help'
	@echo  ''