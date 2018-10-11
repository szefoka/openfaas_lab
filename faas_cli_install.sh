curl -sSL https://cli.openfaas.com | sudo sh
git clone https://github.com/openfaas/faas-cli.git
$ROOT_DIR=$PWD
cd faas-cli
faas-cli template pull
faas-cli deploy stack.yml --gateway localhost:31112
cd $ROOT_DIR
mkdir functions
