# README

* Ruby version 2.7.1

* on dev environment run dev compose config:

docker-compose -f docker-compose.dev.yml up

also for local env locally run rails s -p 3001 and sidekiq, for all the rest run docker-compose up


### New production server installing schedule

sudo mkdir -p /var/www

sudo chown ec2-user /var/www

sudo yum install nginx

### Setup Docker and compose

sudo yum install docker

sudo service docker start

sudo usermod -a -G docker ec2-user

reload instance

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose version

### deploy last update

from local: cap production deploy
