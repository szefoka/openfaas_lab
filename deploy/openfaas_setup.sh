sudo git clone https://github.com/openfaas/faas-netes
sudo kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
cd faas-netes

#enabling basic auth on gateway
PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)
kubectl -n openfaas create secret generic basic-auth \
--from-literal=basic-auth-user=admin \
--from-literal=basic-auth-password="$PASSWORD"
sudo kubectl apply -f ./yaml
cd ..
