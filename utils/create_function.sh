mkdir -p functions
cd functions
faas-cli new --lang python $1
IP=$(ip addr sh dev $(ip ro sh | grep default | awk '{print $5}') scope global | grep inet | awk '{split($2,addresses,"/"); print addresses[1]}')
sed -i '$ d' $1.yml && echo "    image: $IP:5000/$1" >> $1.yml

printf 'def handle(req):\n    return req + " " + str("%s")\n' $2 > ./$1/handler.py

faas-cli build -f $1.yml
faas-cli push -f $1.yml
faas-cli deploy -f $1.yml --gateway localhost:31112


