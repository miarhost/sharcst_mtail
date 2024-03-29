FROM ruby:2.7.1-alpine as build
RUN apk --update add build-base git postgresql-dev postgresql-client tzdata imagemagick
WORKDIR /app
COPY Gemfile* ./

RUN gem install bundler -v 2.4.22 && bundle install
ADD . /app

CMD ["bundle","exec","puma","-C","config/puma.rb"]
