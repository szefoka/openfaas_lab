ORIG_DIR=$PWD
git clone https://github.com/openfaas-incubator/faas-idler.git
cd faas-idler
sed -i 's/\        image: openfaas\/faas-idler:0.1.7/\        image: openfaas\/faas-idler:0.2.0/' faas-idler-dep.yml
sed -i 's/\          secretName: basic-auth/\          secretName: gateway-basic-auth/' faas-idler-dep.yml
kubectl create -f faas-idler-dep.yml
cd ORIG_DIR
