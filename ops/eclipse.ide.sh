#!/bin/bash

[ ${1}x != x ] && UID=$1
[ ${2}x != x ] && GID=$2
[ ${UID}x == x ] && UID=1000
[ ${GID}x == x ] && GID=1000

echo $@ $UID $GID $DISPLAY

export JAVA_HOME=/java/jdk
export PATH=$PATH:$JAVA_HOME/bin

mkdir -p /home/developer
echo "developer:x:"$UID":"$GID":Developer,,,:/home/developer:/bin/bash" >> /etc/passwd
echo "developer:x:"$UID":" >> /etc/group
echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod 0440 /etc/sudoers
chown -R $UID:$GID /home/developer

echo 'export JAVA_HOME=/java/jdk' >> /home/developer/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /home/developer/.bashrc
ln -fs ../jdk /java/ide/jre

sudo -u developer -- /java/ide/eclipse -data /java/workspace
