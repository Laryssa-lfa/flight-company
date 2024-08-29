# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION

WORKDIR /app
RUN apt-get update

COPY Gemfile Gemfile.lock ./
RUN bundle install

ENTRYPOINT ["./bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
