IP=$1
sed "/ExecStart/ s/$/ --insecure-registry=$IP/" /lib/systemd/system/docker.service > /lib/systemd/system/tmp
mv /lib/systemd/system/tmp /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker.service
docker run -d -p 5000:5000 --restart=always --name registry registry:2
