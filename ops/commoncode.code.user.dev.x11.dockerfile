FROM code

RUN cd /usr/local/ide/ \
&& sudo -u developer -- /usr/local/ide/vscode.ide.sh install commoncode  
CMD ["bash"]