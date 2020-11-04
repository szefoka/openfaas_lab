GRAFANA_ADDR=$(ip addr sh dev $(ip ro sh | grep default | awk '{print $5}') scope global | grep inet | awk '{split($2,addresses,"/"); print addresses[1]}'):$(kubectl get services | grep kube-grafana | grep pending | awk '{ print $5 }' | cut -d ':' -f 2 | cut -d '/' -f 1)
echo "Grafana is running on http://$GRAFANA_ADDR"
echo username: $(kubectl get secrets kube-grafana -o yaml | grep user |head -n 1 | cut -d " " -f 4 | base64 --decode)
echo password: $(kubectl get secrets kube-grafana -o yaml | grep password |head -n 1 | cut -d " " -f 4 | base64 --decode)
