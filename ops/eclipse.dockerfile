FROM x11docker/xfce
ARG jdkDir
ARG ideDir
#ARG DISPLAY
ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}
ENV DISPLAY=${DISPLAY}
ENV container docker
ENV PATH /snap/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates bash sudo git net-tools tcpdump maven gradle && \
    apt-get install -y --no-install-recommends snapd fuse postgresql-client default-mysql-client mongo-tools && apt-get clean

## for test only
#RUN apt-get install -y --no-install-recommends x11-apps bash sudo
RUN groupadd -f --gid 999 docker
RUN groupadd -f --gid ${GID} developer
RUN useradd --uid ${UID} -G docker -g developer -d /home/developer -p developer developer

RUN mkdir -p /java/ide /java/jdk /java/workspace 
ADD $jdkDir /java/jdk/
ADD $ideDir /java/ide/
ADD ./ops/ide.sh /java/ide.sh
RUN chown $UID:$GID -R /java
CMD ["bash","/java/ide.sh"]

## for test only
#CMD xclock
