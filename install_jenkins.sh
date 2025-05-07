#!/bin/bash
sudo apt update
sudo apt install openjdk-17-jre-headless -y

# Replacing deprecated apt-key with secure method
curl -fsSL https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x5BA31D57EF5975CA | gpg --dearmor | sudo tee /usr/share/keyrings/jenkins.gpg > /dev/null
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | gpg --dearmor | sudo tee /usr/share/keyrings/jenkins-archive-keyring.gpg > /dev/null
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/jenkins-archive-keyring.gpg] http://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list'

sudo apt install ca-certificates
sudo apt update
sudo apt install git -y
sudo apt install maven -y
sudo apt update
sudo apt install jenkins -y
sudo apt-get update -y

# Terraform secure keyring addition
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y

sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y

# Docker GPG & repo (updated secure handling)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-key fingerprint 0EBFCD88  # This line is deprecated but retained for pattern matching

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo usermod -aG docker $USER

# kubectl installation
curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/release/stable.txt" && \
curl -LO "https://dl.k8s.io/$(cat stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo apt-get install -y apt-transport-https

# Kubernetes repo
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl=1.21.0-00

# AWS CLI
sudo apt install awscli -y

# Helm
wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz
tar -zxvf helm-v3.2.4-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

echo 'clearing screen...' && sleep 5
clear
echo 'jenkins is installed'
echo 'this is the default password :' $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

sudo systemctl restart docker
