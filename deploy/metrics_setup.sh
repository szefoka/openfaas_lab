git clone https://github.com/kubernetes-incubator/metrics-server.git
sed -i '34i\        command:\' metrics-server/deploy/1.8+/metrics-server-deployment.yaml
sed -i '35i\        - /metrics-server\' metrics-server/deploy/1.8+/metrics-server-deployment.yaml
sed -i '36i\        - --kubelet-insecure-tls\' metrics-server/deploy/1.8+/metrics-server-deployment.yaml
kubectl create -f metrics-server/deploy/1.8+/
