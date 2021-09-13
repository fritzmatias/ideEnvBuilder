FROM commoncode

RUN cd /usr/local/ide/ \
&& sudo -u developer -- /usr/local/ide/vscode.ide.sh install pycode commoncode  
CMD ["bash"]