setup: ## run app
	@docker-compose build

start: ## run app service given a port, ex: make start port=3000
	@docker-compose run \
		--rm \
		-p ${port}:${port} \
		app \
		bash -c "bundle exec rails s -p ${port} --binding 0.0.0.0"

bash: ## run bash app
	@docker-compose run --rm --service-ports app bash

test:
	@docker-compose run --rm --service-ports app bash -c "bundle exec rspec"

rubocop:
	rubocop
