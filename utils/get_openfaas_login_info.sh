echo OpenFaaS dashboard running on $(curl -s ipinfo.io/ip):31112
echo Username: $(kubectl get secrets -n openfaas-fn basic-auth-user -o yaml | grep basic-auth-user: | awk '{print $2}' | base64 --decode)
echo Password: $(kubectl get secrets -n openfaas-fn basic-auth-password -o yaml | grep basic-auth-password: | awk '{print $2}' | base64 --decode)
