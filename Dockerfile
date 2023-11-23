FROM ruby:2.7.1-alpine as build
RUN apk --update add build-base git postgresql-dev postgresql-client tzdata imagemagick
WORKDIR /app
COPY Gemfile* ./

RUN gem install bundler && bundle install
ADD . /app
RUN mkdir -p tmp/pids
RUN mkdir -p var/www/sharcst/sharcst_mtail/current

CMD ["bundle","exec","puma","-C","config/puma.rb"]

FROM nginx
COPY ./docker/html/index.html /usr/share/nginx/html
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf
