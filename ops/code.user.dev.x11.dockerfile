FROM user
ENV UID=1000
ENV GID=1000

RUN mkdir -p /java/ide /java/jdk /java/workspace  /usr/local/ide/ /mnt/workspace 
COPY . /usr/local/ide/
RUN chown $UID:$GID -R /java /home/developer /usr/local/ide /mnt/workspace
RUN cd /usr/local/ide \
    && chmod 755 /usr/local/ide/vscode.ide.sh
CMD ["bash"]