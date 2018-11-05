kubectl create -f redis_master_dep.yaml
kubectl create -f redis_master_svc.yaml
kubectl create -f redis_slave_dep.yaml
kubectl create -f redis_slave_svc.yaml
