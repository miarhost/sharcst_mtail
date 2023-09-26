# README

* Ruby version 2.7.1

* for running app including  _redis_, local s3 bucket -> _minio_, _open-search_ / open-search dashboard execute:

docker-compose -f docker-compose.yml up

===================
## Another production server installing schedule
## /Amazon EC 2/Amazon Linux 2023 deployed by Capistrano and run by docker-compose
===================
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
### Setup NGINX
cd /etc/nginx

sudo mkdir sites-available
sudo mkdir sites-enabled

sudo nano /etc/nginx/nginx.conf at htto block: include /etc/nginx/sites-enabled/*; # to allow access from symlink to enabled

sudo yum install git
Ready to deploy.
