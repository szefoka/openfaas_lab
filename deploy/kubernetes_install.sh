#!/bin/bash

CLIENT=$1
IP=$2
TOKEN=$3
HASH=$4

#Installing Docker
DOCKER_INSTALLED=$(which docker)
if [ "$DOCKER_INSTALLED" = "" ]
then
	export DEBIAN_FRONTEND=noninteractive
	sudo apt-get remove docker docker-engine docker.io
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update -y
	sudo apt-get install -y docker-ce
fi

#Installing Kubernetes
KUBERNETES_INSTALLED=$(which kubeadm)
if [ "$KUBERNETES_INSTALLED" = "" ]
then
	export DEBIAN_FRONTEND=noninteractive
	sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo touch /etc/apt/sources.list.d/kubernetes.list
	sudo chmod 666 /etc/apt/sources.list.d/kubernetes.list
	sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update -y
	sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
fi

#Starting Kubernetes and installing faas-netes
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo swapoff -a

if [ -z "$CLIENT" ]
then
	sudo kubeadm init --ignore-preflight-errors=SystemVerification
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config

elif [ "$CLIENT" = "true" ]
then
	kubeadm join $IP --token $TOKEN --discovery-token-ca-cert-hash $HASH --ignore-preflight-errors=SystemVerification
	echo "Client joined to Master"
else
	echo "Invalid argument"
fi

