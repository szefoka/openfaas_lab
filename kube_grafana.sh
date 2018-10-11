#!/bin/bash

#Install HELM
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init
helm init --upgrade

#
#By default you don't have permission to deploy tiller, add an account for it
#https://github.com/helm/helm/issues/3130
#

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}' 
sleep 20
helm repo update

helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
helm install coreos/kube-prometheus --name kube-prometheus --set global.rbacEnable=true --namespace monitoring

sleep 40

kubectl port-forward -n monitoring prometheus-kube-prometheus-0 9090 &
kubectl port-forward $(kubectl get  pods --selector=app=kube-prometheus-grafana -n  monitoring --output=jsonpath="{.items..metadata.name}") -n monitoring  3000 &
kubectl port-forward -n monitoring alertmanager-kube-prometheus-0 9093 &

#Forward localhost ports to external IP, kubectl port worward only forwards to localhost ¯\_(ツ)_/¯
sudo sysctl -w net.ipv4.conf.all.route_localnet=1
sudo iptables -t nat -I PREROUTING -p tcp --dport 9090 -j DNAT --to 127.0.0.1:9090
sudo iptables -t nat -I PREROUTING -p tcp --dport 3000 -j DNAT --to 127.0.0.1:3000
sudo iptables -t nat -I PREROUTING -p tcp --dport 9093 -j DNAT --to 127.0.0.1:9093
