kubectl create -f redis/redis_master_dep.yaml
kubectl create -f redis/redis_master_svc.yaml
kubectl create -f redis/redis_slave_dep.yaml
kubectl create -f redis/redis_slave_svc.yaml
