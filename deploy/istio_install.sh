git clone https://github.com/istio/istio.git
cd istio
git checkout release-1.0
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.1.0-snapshot.3/charts
helm dep update install/kubernetes/helm/istio/
helm upgrade --install istio --namespace istio-system install/kubernetes/helm/istio/
cd ..
#wget https://github.com/istio/istio/releases/download/1.1.0-snapshot.3/istio-1.1.0-snapshot.3-linux.tar.gz
wget https://github.com/istio/istio/releases/download/1.0.4/istio-1.0.4-linux.tar.gz
tar -xf istio-1.1.0-snapshot.3-linux.tar.gz
cp istio-1.1.0-snapshot.3/bin/istioctl /usr/bin/
