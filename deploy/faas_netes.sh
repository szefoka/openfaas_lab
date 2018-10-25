#!/bin/bash

CLIENT=$1

#Installing Docker
DOCKER_INSTALLED=$(which docker)
if [ "$DOCKER_INSTALLED" = "" ]
then
	sudo apt-get remove docker docker-engine docker.io
	sudo apt-get update
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
fi

#Installing Kubernetes
KUBERNETES_INSTALLED=$(which kubeadm)
if [ "$KUBERNETES_INSTALLED" = "" ]
then
	sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo touch /etc/apt/sources.list.d/kubernetes.list
	sudo chmod 666 /etc/apt/sources.list.d/kubernetes.list
	sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
fi

#Starting Kubernetes and installing faas-netes
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo swapoff -a

if [ -z "$CLIENT" ]
then
	sudo kubeadm init
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
	sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
	sudo git clone https://github.com/openfaas/faas-netes
	sudo kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
	cd faas-netes
	#temporary fix, till faas-netes not gets gateway version 0.9.8, issue with autoscaling
	sed -i 's/ image: openfaas\/gateway:0.9.7/ image: openfaas\/gateway:0.9.8/' yaml/gateway-dep.yml
	sudo kubectl apply -f ./yaml
elif [ "$CLIENT" = "true" ]
then
	echo "Client is waiting to join"
else
	echo "Invalid argument"
fi
