#!/bin/bash
#. corelib.sh

usage(){
exec cat <<EOF
    install <alias> [dependency1 dependency2] #installs the alias and extension 
EOF
}

installExtensions(){
local root=./vscode
local aliasName=$1; shift
local dependencies=$@
local extensionsPath=""
local extensionsList=""

    for dependency in ${dependencies}; do
        extensionsPath="${extensionsPath}:${dependency}/extensions.list"        
    done
    #debug "extensionsPath: ${extensionsPath}"

    for extension in $(echo "${extensionsPath}"|tr ':' '\n'|sort -u); do 
        local extensions=$(cat ${root}/${extension}|sed -e 's/#.*//g'|grep -v '^$'|sort -u)
        if echo $extensions|grep '#'; then
            echo "Error on getting data on: $extensions">&2;
            exit 1;
        fi
        extensionsList="${extensionsList} ${extensions}"
    done
#    debug "extensionsList: ${extensionsList}"

    for ext in $extensionsList; do
    echo "Installing in $aliasName: ...${ext}"
        $HOME/.${aliasName}/${aliasName} --install-extension "${ext}" >/dev/null 2>&1
    done
}

installExtensions2(){
local srcroot=./vscode
local aliasName=$1; shift
#local dstroot=$1; shift ;[ "$dstroot"x = x ] && dstroot=$HOME; 
local dstroot=$HOME; 
local dependencies="${@}"
local extensionsPath="${aliasName}/extensions.list"
local extensionsList=""
    #debug "extensionsPath: ${extensionsPath}"
    for extension in $(echo "${extensionsPath}"|tr ':' '\n'|sort -u); do 
        local extensions=$(cat ${srcroot}/${extension}|sed -e 's/#.*//g'|grep -v '^$'|sort -u)
        if echo $extensions|grep '#'; then
            echo "Error on getting data on: $extensions">&2;
            exit 1;
        fi
        extensionsList="${extensionsList} ${extensions}"
    done
#    debug "extensionsList: ${extensionsList}"
    for dependency in ${dependencies}; do
        if [ ${dependency} != ${aliasName} ]; then
            for dep in $(cat ${srcroot}/${dependency}/extensions.list|sed -e 's/#.*//g'|grep -v '^$'|sort -u); do
                echo ln -s "${dstroot}/.${dependency}/extensions/${dep}"* "${dstroot}/.${aliasName}/extensions/"
                ln -s "${dstroot}/.${dependency}/extensions/${dep}"* "${dstroot}/.${aliasName}/extensions/"
            done
        else
            echo "skiping $dependency ln "
        fi
    done
    for ext in $extensionsList; do
        echo "Installing in $aliasName: ...${ext}"
        echo ${dstroot}/.${aliasName}/${aliasName} --install-extension "${ext}" 
        ${dstroot}/.${aliasName}/${aliasName} --install-extension "${ext}" >/dev/null 2>&1 || echo exit 1
    done
}

installBin(){
local srcroot=./vscode; 
local aliasName=$1; shift
#local dstroot=$1;shift; [ "$dstroot"x = x ] && dstroot=$HOME; 
local dstroot=$HOME; 
local binpath=/usr/local/bin/
#        debug "installing alias ${aliasName}" 
        mkdir -p  $dstroot/.${aliasName}/user-data ${dstroot}/.${aliasName}/extensions
        cp "${srcroot}/${aliasName}/${aliasName}" ${dstroot}/.${aliasName}/
        #ln -s ${dstroot}/.${aliasName}/${aliasName} ${binpath}/${aliasName} 
        chmod 755 ${dstroot}/.${aliasName}/${aliasName} #${binpath}/${aliasName} 
}

DOCKERTAG=ide
cmd=$1;shift
case $cmd in
    install)
        installBin $1
        installExtensions2 $1 $@
    ;;
    installall)
        installBin commoncode
        installExtensions2 commoncode
        for ide in $(ls -1 vscode/|grep -v commoncode);do
            installBin $ide
            installExtensions2 $ide commoncode
        done
    ;;
    build)
        docker build --build-arg "UID=1000" --build-arg "GID=1000" $@ -f vscode.dockerfile -t $DOCKERTAG .
    ;;
    buildX11)
        docker build $@ -f x11.dockerfile -t x11 .
    ;;
    builddev)
        docker build $@ -f dev.x11.dockerfile -t dev .
    ;;
    builduser)
        docker build $@ -f user.dev.x11.dockerfile -t user .
    ;;
    buildcode)
        docker build $@ -f code.user.dev.x11.dockerfile -t code .
    ;;
    buildall)
        docker build $@ -f all.code.user.dev.x11.dockerfile -t allcode .
    ;;
    buildcommoncode)
        docker build $@ -f commoncode.code.user.dev.x11.dockerfile -t commoncode .
    ;;
    buildpycode)
        docker build $@ -f pycode.commoncode.code.user.dev.x11.dockerfile -t pycode .
    ;;
    run)
        docker run -i -t -v /tmp/.X11-unix:/tmp/.X11-unix --env "DISPLAY=:0" $DOCKERTAG sudo -u developer -- /vscode/${@}/$@ --no-sandbox --wait
    ;;
    test)
        docker run -i -t -v /tmp/.X11-unix:/tmp/.X11-unix --env "DISPLAY=:0" $DOCKERTAG sudo -u developer -- $@
    ;;
    *)
        usage
esac

#sudo -u developer -- /usr/bin/code --no-sandbox --wait