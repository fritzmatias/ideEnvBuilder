FROM x11
ARG jdkDir
ARG ideDir
ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}
ENV DISPLAY=${DISPLAY}
ENV container docker
ENV PATH /snap/bin:$PATH

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


## for test only
#RUN apt-get install -y --no-install-recommends x11-apps bash sudo
RUN groupadd -f --gid 999 docker
RUN groupadd -f --gid ${GID} developer
RUN useradd -m --uid ${UID} -s /bin/bash -G docker -g developer -d /home/developer -p developer developer
RUN mkdir -p /java/ide /java/jdk /java/workspace  /usr/local/ide/
#ADD $jdkDir /java/jdk/
#ADD $ideDir /java/ide/
COPY . /usr/local/ide/
RUN chown $UID:$GID -R /java /home/developer /usr/local/ide
RUN cd /usr/local/ide \
    && chmod 755 /usr/local/ide/vscode.ide.sh \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install javacode commoncode \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install pycode commoncode \ 
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install sfcode commoncode \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install solcode commoncode \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install tscode commoncode 
CMD ["bash"]