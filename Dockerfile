FROM ruby:3.0.0-alpine

RUN apk add libxml2-dev alpine-sdk libpq postgresql-dev tzdata libc6-compat

WORKDIR /myapp
COPY . /myapp
RUN bundle install

EXPOSE 3000

CMD ["sh", "-c", "rails db:migrate ; rails server -b 0.0.0.0"]
