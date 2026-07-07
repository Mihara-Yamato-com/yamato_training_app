FROM ruby:3.4.10

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs postgresql-client

WORKDIR /yamato_training_app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]