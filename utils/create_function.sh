mkdir -p functions
cd functions
faas-cli new --lang python $1
IP=$(ifconfig $(route | grep '^default' | grep -o '[^ ]*$') | grep "inet addr:" | awk '{print $2}' | cut -c6-)
sed -i '$ d' $1.yml && echo "    image: $IP:5000/$1" >> $1.yml

printf 'def handle(req):\n    return req + " " + str("%s")\n' $2 > ./$1/handler.py

faas-cli build -f $1.yml
faas-cli push -f $1.yml
faas-cli deploy -f $1.yml --gateway localhost:31112


