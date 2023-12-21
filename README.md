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

### Setup kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

### Setup minikube

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start

### Setup kompose

curl -L https://github.com/kubernetes/kompose/releases/download/v1.31.2/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose

### deploy last update

from local: cap production deploy
