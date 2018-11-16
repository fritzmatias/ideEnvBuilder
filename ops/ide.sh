#!/bin/bash

ln -fs ../jdk /java/eclipse/jre
[ ${1}x != x ] && UID=$1
[ ${2}x != x ] && GID=$2
[ ${UID}x == x ] && UID=1000
[ ${GID}x == x ] && GID=1000

echo $@ $UID $GID $DISPLAY

export JAVA_HOME=/java/jdk
export PATH=$PATH:$JAVA_HOME/bin

mkdir -p /home/developer
echo "developer:x:"$UID":"$GID":Developer,,,:/home/developer:/bin/sh" >> /etc/passwd
echo "developer:x:"$UID":" >> /etc/group
echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod 0440 /etc/sudoers
chown -R $UID:$GID /home/developer

sudo -u developer -- /java/eclipse/eclipse -data /java/workspace
