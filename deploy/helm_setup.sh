#!/bin/bash

function wait_for_tiller {
  while [[ "$(kubectl get pods -n kube-system | grep tiller | grep Running | wc -l)" -lt 1 ]];
  do
    sleep 1
  done
}

#Install HELM
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh --version v2.14.0
#helm init
helm init --upgrade
wait_for_tiller
#
#By default you don't have permission to deploy tiller, add an account for it
#https://github.com/helm/helm/issues/3130
#
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}' 
wait_for_tiller
helm repo update

