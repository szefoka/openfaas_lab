# openfaas_lab
openfaas laboratory exercise for university students

## Deploying the cluster
The OpenFaaS cluster can be deployed by running faas_lab_setup.sh, located in the deploy directory.

Before running faas_lab_setup.sh set the nodes.conf by adding the hostnames of the desired Kubernetes worker nodes.

This installs an OpenFaaS cluster on top of Kubernetes and several utilites like Grafana, Elasticsearch, Istio, Weavescope.

## Gaining access to OpenFaaS
In the utils directory one can get the information to log in to OpenFaaS ui by executing the get_openfaas_login_info.sh file.

For students: to create a function in OpenFaaS create_function.sh should be executed. This script requires two parameters, the function name and its return value.

```
./create_function.sh myfunc Hello
```

The script that outputs the required information to access to Kubernetes dashboard is also located in the utils directory.
To get the login information run get_dashboard_login_token.sh

## TODO:
* Create a config file which enables to install the system on other kind of architectures
* To install run faas_lab_setup in the deploy directory
* To gain access to the installed services or create functions, run the scripts under utils
