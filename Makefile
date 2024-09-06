setup: ## run app
	@docker-compose build

start: ## run app service given a port, ex: make start port=3000
	@docker-compose run \
		--name flight_app \
		--rm \
		-p ${port}:${port} \
		app \
		bash -c "bin/setup && bundle exec rails s -p ${port} --binding 0.0.0.0"

bash: ## run bash app
	@docker-compose run \
		--name flight_app \
		--rm \
		--service-ports \
		app \
		bash

exec: ## run docker interactive
	@docker exec -it flight_app bash

test:
	@docker-compose run \
		--name flight_app \
		--rm \
		--service-ports \
		app \
		bash -c "bin/setup && bundle exec rspec"

rubocop:
	@docker-compose run \
		--name flight_app \
		--rm \
		--service-ports \
		app \
		bash -c "bin/setup && rubocop"
