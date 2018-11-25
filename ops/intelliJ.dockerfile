FROM x11docker/xfce
ARG jdkDir
ARG ideDir
ARG DISPLAY
ARG UID
ARG GID

ENV UID ${UID}
ENV GID ${GID}
ENV DISPLAY=${DISPLAY}
RUN apt-get update
RUN apt-get install -y bash sudo git net-tools tcpdump
## for test only
#RUN apt-get install -y --no-install-recommends x11-apps 

RUN mkdir -p /java/ide /java/jdk /java/workspace 
ADD $jdkDir /java/jdk/
ADD $ideDir /java/ide/
ADD ./ops/ide.sh /java/ide.sh
RUN chown $UID:$GID -R /java
CMD ["bash","/java/ide.sh"]

## for test only
#CMD xclock
