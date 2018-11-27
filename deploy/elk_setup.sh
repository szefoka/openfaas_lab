sysctl -w vm.max_map_count=262144
ssh node2 -o "StrictHostKeyChecking no" sysctl -w vm.max_map_count=262144
elk/kubectl create -f elasticsearch_dep.yaml
elk/kubectl create -f elasticsearch_svc.yaml
elk/kubectl create -f kibana_dep.yaml
elk/kubectl create -f kibana_svc.yaml
ELASTIC_SEARCH_IP=$(kubectl get services | grep elasticsearch | awk '{print $3}')
curl https://raw.githubusercontent.com/elastic/beats/master/deploy/kubernetes/filebeat-kubernetes.yaml > elk/filebeat-kubernetes.yaml
sed -i "s/value: elasticsearch/value: $ELASTIC_SEARCH_IP/" elk/filebeat-kubernetes.yaml
kubectl create -f elk/filebeat-kubernetes.yaml
