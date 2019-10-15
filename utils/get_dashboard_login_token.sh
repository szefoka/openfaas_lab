#!/bin/bash
DASH_ADDR=$(ip addr sh dev $(ip ro sh | grep default | awk '{print $5}') scope global | grep inet | awk '{split($2,addresses,"/"); print addresses[1]}'):$(kubectl get services -n kube-system | grep kubernetes-dashboard | awk '{ print $5 }' | cut -d ':' -f 2 | cut -d '/' -f 1)

echo "Kubernetes dashboard is running on https://$DASH_ADDR"
#echo "Token:"
#kubectl get secret -n kube-system | grep k8sadmin | cut -d " " -f1 | xargs -n 1 | xargs kubectl get secret  -o 'jsonpath={.data.token}' -n kube-system | base64 --decode
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep token:
echo
