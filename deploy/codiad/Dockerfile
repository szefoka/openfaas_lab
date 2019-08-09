FROM bitnami/codiad:latest

#INSTALL DOCKER CLI
RUN apt update
RUN apt install -y git
RUN apt install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt update
RUN apt install -y docker-ce-cli

#ADD FAAS-CLI
ADD faas-cli/faas-cli /usr/bin

#ADD CODIAD PLUGINS
RUN git clone https://github.com/szefoka/Codiad-plugins.git
RUN mv Codiad-plugins/create_function /opt/bitnami/codiad/plugins
#RUN mv Codiad-plugins/build /opt/bitnami/codiad/plugins


