FROM x11

RUN env DEBIAN_FRONTEND=noninteractive apt-get update --allow-releaseinfo-change \
    && apt-get install -y --no-install-recommends \
       gnupg2 ca-certificates bash sudo git net-tools tcpdump maven gradle \
    && apt-get install -y --no-install-recommends \
       fuse postgresql-client default-mysql-client mongo-tools \
    && apt-get install -y --no-install-recommends \
       vim curl wget apt-transport-https npm nodejs \
    && apt-get clean

RUN echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' >/etc/apt/sources.list.d/vscode.list
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - 
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common apt-transport-https firefox-esr \
    && apt-get clean
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    && apt-get update --allow-releaseinfo-change \
    && apt-get install -y --no-install-recommends code \
    && apt-get clean 

CMD ["bash"]