echo OpenFaaS dashboard is running on http://$(curl -s ipinfo.io/ip):31112
echo Username: $(kubectl get secrets -n openfaas basic-auth -o yaml | grep basic-auth-user: | awk '{print $2}' | head -n 1 | base64 --decode)
echo -n
echo Password: $(kubectl get secrets -n openfaas basic-auth -o yaml | grep basic-auth-password: | awk '{print $2}' | head -n 1 | base64 --decode)
echo -n
