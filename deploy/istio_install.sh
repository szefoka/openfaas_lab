helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.3.4/charts/
git clone https://github.com/istio/istio.git
cd istio
kubectl create namespace istio-system
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | kubectl apply -f -
sleep 30
helm template install/kubernetes/helm/istio --name istio --namespace istio-system | kubectl apply -f -
cd ..
wget https://github.com/istio/istio/releases/download/1.3.4/istio-1.3.4-linux.tar.gz
tar -xvf istio-1.3.4-linux.tar.gz
cp istio-1.3.4/bin/istioctl /usr/bin


