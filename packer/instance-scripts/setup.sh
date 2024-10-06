#!/bin/bash

sleep 30

sudo yum update -y

sudo yum install zip -y

# Docker installation
sudo yum install docker -y
sudo curl -SL https://github.com/docker/compose/releases/download/v2.29.6/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo systemctl enable docker.service
sudo systemctl start docker.service

sudo cp /home/ec2-user/app.service /etc/systemd/system/app.service

sudo systemctl enable app.service
sudo systemctl start app.service
