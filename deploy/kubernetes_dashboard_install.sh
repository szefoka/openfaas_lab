#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

sleep 10
kubectl patch service -n kubernetes-dashboard kubernetes-dashboard --type=json -p='[{"op":"add", "path": "/spec/type", "value": LoadBalancer}]'

#Gen certificates
#mkdir -p certs
#cd certs
#CERT_DIR=$PWD
#openssl genrsa -des3 -passout pass:x -out dashboard.pass.key 2048
#openssl rsa -passin pass:x -in dashboard.pass.key -out dashboard.key
#rm dashboard.pass.key
#openssl req -new -key dashboard.key -out dashboard.csr -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"
#openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt
#kubectl create secret generic kubernetes-dashboard-certs --from-file=$CERT_DIR -n kube-system
#cd ..

#Deploy the dashboard
#wget https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
#wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml
#sed -i '176i\  type: LoadBalancer' kubernetes-dashboard.yaml
#kubectl apply -f kubernetes-dashboard.yaml

#Token based dashboard authentication
#kubectl create serviceaccount k8sadmin -n kube-system
#kubectl create clusterrolebinding k8sadmin --clusterrole=cluster-admin --serviceaccount=kube-system:k8sadmin
