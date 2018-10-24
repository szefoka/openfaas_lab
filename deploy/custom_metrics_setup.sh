#curl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -o /usr/local/bin/cfssl
#curl https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -o /usr/local/bin/cfssljson
#chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson

curl -s -L -o /bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -s -L -o /bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
curl -s -L -o /bin/cfssl-certinfo https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x /bin/cfssl*

git clone https://github.com/coreos/prometheus-operator.git
PROM_URL=$(kubectl get services -n monitoring kube-prometheus | awk '{print $3 ":" $5}'|cut -d "/" -f 1 | tail -n 1)
ORIG_DIR=$PWD
cd prometheus-operator/contrib/kube-prometheus/experimental/custom-metrics-api/

sed -i "s/- --prometheus-url=http:\/\/prometheus-k8s.monitoring.svc:9090/\- --prometheus-url=http:\/\/${PROM_URL}/" custom-metrics-apiserver-deployment.yaml

sed -i '18d' gencerts.sh

./gencerts.sh
./deploy.sh
cd $ORIG_DIR

