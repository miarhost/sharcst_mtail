FROM ruby:2.7.1-alpine
RUN apk --update add build-base git postgresql-dev postgresql-client tzdata imagemagick
WORKDIR /app
COPY Gemfile* ./

RUN gem install bundler && bundle install
ADD . /app

CMD ["rails", "server"]
EXPOSE 3000
