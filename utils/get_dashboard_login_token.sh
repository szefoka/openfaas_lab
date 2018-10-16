#!/bin/bash
DASH_ADDR=$(ifconfig eno49 | grep "inet addr:" | awk '{print $2}' | cut -c6-):$(kubectl get services -n kube-system | grep kubernetes-dashboard | awk '{ print $5 }' | cut -d ':' -f 2 | cut -d '/' -f 1)

echo "Kubernetes dashboard is running on https://$DASH_ADDR"
echo "Token:"
kubectl get secret -n kube-system | grep k8sadmin | cut -d " " -f1 | xargs -n 1 | xargs kubectl get secret  -o 'jsonpath={.data.token}' -n kube-system | base64 --decode
echo
