git clone https://github.com/szefoka/faas-cli.git
cd faas-cli
bash build.sh
cd ..
docker build -t openfaas_codiad .
