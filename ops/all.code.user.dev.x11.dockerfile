FROM commoncode
RUN cd /usr/local/ide \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install javacode commoncode \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install pycode commoncode \ 
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install sfcode commoncode \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install solcode commoncode \
    && sudo -u developer -- /usr/local/ide/vscode.ide.sh install tscode commoncode 
CMD ["bash"]