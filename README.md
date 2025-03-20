## Development Environment

### Prerequisites
- Ruby version 3.2.1
- Docker and Docker Compose

### Setup
1. For the dev environment, run:


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
