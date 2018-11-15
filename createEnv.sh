#! /bin/bash
# Dockerized Java Eclipse IDE

##### Configurable parameters
# JDK 11
#JDKURL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz"
# JDK 8
JDKURL="https://download.java.net/java/jdk8u192/archive/b04/binaries/jdk-8u192-ea-bin-b04-linux-x64-01_aug_2018.tar.gz"

# EclipseSPS 201809
ECLIPSEURL="http://download.springsource.com/release/ECLIPSE/2018-09/eclipse-jee-2018-09-linux-gtk-x86_64.tar.gz"
#ECLIPSEURL="https://download.jetbrains.com/idea/ideaIU-2018.2.5.tar.gz"
STS="http://download.springsource.com/release/STS4/4.0.1.RELEASE/dist/e4.9/spring-tool-suite-4-4.0.1.RELEASE-e4.9.0-linux.gtk.x86_64.tar.gz"
# Environment Name
envName="../EclipseSPS_JDK8"

## Ubuntu https://docs.docker.com/compose/install/#master-builds
COMPOSE_VERSION="1.23.1"
#COMPOSE_VERSION="1.8.0"








################################################
usage(){
cat <<EOF
Creates the Eclipse & JEE environment on docker

	arguments:
	 create
	 installDocker
EOF
}

SUDO="sudo "


#### Downloads
download(){
local url="$1"
local file="$2"
 echo Downloading $file
 curl -fSL -C - "${url}" -o "${file}"
}

clone(){
    git clone "https://gitlab.com/truenorth-token/tap-java-dev-environment.git"
}

template(){
local envName="$1"
    ! [ -d "${envName}" ] && mkdir -p "${envName}"
    ! [ -d "${envName}/ops/" ] && mkdir -p "${envName}/ops/"
    cp docker-compose.yml "${envName}"
    cp -r ops/Dockerfile "${envName}/ops/"
    cp -r ops/ide.sh "${envName}/ops/"
    cd "${envName}"
    echo "DISPLAY=$DISPLAY" > .env
    echo "UID=$(id -u)" >> .env
    echo "GID=$(id -u)" >> .env
    echo "BUILDTAG=$(basename $(ls -1d $PWD/jdk* | egrep -v 'jdk$|\.tar' | head -1) )" >> .env
}

## ubuntu & debian
ubuntuDistInstallRepo(){
$SUDO apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
$SUDO curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
$SUDO add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
$SUDO apt-get update
}
debianDistInstallRepo(){
$SUDO apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
$SUDO curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
$SUDO add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
$SUDO apt-get update
}

debianDistRemove(){
$SUDO apt-get remove -y docker.io docker-compose
}
debianDistInstallDocker(){
$SUDO apt-get install -y docker.io
}
debianDistInstallCompose(){
$SUDO apt-get install -y docker-compose
}

## No Distro
noDistroInstallDocker(){
# https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
# get the last version
[ -f "ops/get-docker.sh" ] && rm "ops/get-docker.sh"
[ "$(docker version 2>/dev/null | grep version)x" != x ] && $SUDO apt-get remove -y docker-ce
download "https://get.docker.com" "ops/get-docker.sh"
$SUDO sh ops/get-docker.sh
}
noDistroInstallCompose(){
## Ubuntu https://docs.docker.com/compose/install/#master-builds
# Compose
local VERCompose="${COMPOSE_VERSION}"
$SUDO curl -L https://github.com/docker/compose/releases/download/${VERCompose}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$SUDO chmod +x /usr/local/bin/docker-compose

docker-compose --version
echo RUN "docker run hello-world" to test
}


create(){
local envName=$1
local JDKURL=$2
local ECLIPSEURL=$3

	template "${envName}"
	cd "${envName}"
	download "${JDKURL}" jdk.tar.gz && tar xzf jdk.tar.gz 
	download "${ECLIPSEURL}" eclipse.tar.gz && tar xzf eclipse.tar.gz 
	ln -fs $(basename $(ls -1d $PWD/jdk* | egrep -v 'jdk$|\.tar' | head -1)) jdk
	for dir in workspace developer; do 
		! [ -d "${dir}" ] && mkdir -p "${dir}"
	done
	export TMPDIR=./tmp
	mkdir ./tmp
	docker-compose build --no-cache --force-rm
	rm -r ./tmp
	unset TMPDIR
}

case $1 in
	create)
		create "${envName}" "${JDKURL}" "${ECLIPSEURL}"
		;;
	installDocker)
		#uname -a|grep Ubuntu >/dev/null 2>&1 && distro=ubuntu
		distro=$(. /etc/os-release && echo $ID)
		[ ${distro}x = x ] && distro=noDistro

		echo the evaluated distro is: $distro
		if [ ${distro} = ubuntu ] ; then
			debianDistInstallRepo
			debianDistRemove
			debianDistInstallDocker
			debianDistInstallCompose
		fi
		if [ ${distro} = debian ] ; then
			debianDistInstallRepo
			debianDistRemove
			debianDistInstallDocker
			debianDistInstallCompose
		fi

		;;
	*)
		usage
		exit 1
esac
