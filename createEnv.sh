#! /bin/bash
# Dockerized Java Eclipse IDE

##### Configurable parameters
# JDK 11
#JDKURL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz"
# JDK 8
JDKURL="https://download.java.net/java/jdk8u192/archive/b04/binaries/jdk-8u192-ea-bin-b04-linux-x64-01_aug_2018.tar.gz"

#IntelliJURL="https://download.jetbrains.com/idea/ideaIU-2018.2.6.tar.gz"
IntelliJURL="https://download.jetbrains.com/idea/ideaIU-2018.3-no-jdk.tar.gz"

# EclipseSPS 201809
ECLIPSEURL="http://download.springsource.com/release/ECLIPSE/2018-09/eclipse-jee-2018-09-linux-gtk-x86_64.tar.gz"
#ECLIPSEURL="https://download.jetbrains.com/idea/ideaIU-2018.2.5.tar.gz"
STS="http://download.springsource.com/release/STS4/4.0.1.RELEASE/dist/e4.9/spring-tool-suite-4-4.0.1.RELEASE-e4.9.0-linux.gtk.x86_64.tar.gz"


## Ubuntu https://docs.docker.com/compose/install/#master-builds
COMPOSE_VERSION="1.23.1"








################################################
usage(){
cat <<EOF
Creates the Eclipse & JEE environment on docker

    arguments:
	 eclipse <envName>	creates a default eclipse version into the <envName> folder.
	 intellij <envName>	creates a default eclipse version into the <envName> folder.
	 installDocker		tries to uninstall & install docker & compose. (Debian & Ubuntu)
EOF
}

[ $(id -u) -eq 0 ] && exit 1 && echo "Can not be executed as root"

SUDO="sudo "


#### Downloads
download(){
local url="$1"
local file="$2"
local urlHash=$(echo -n "$url"| sha1sum | cut -d' ' -f 1)
local cacheDir="$PWD/cache"
mkdir -p "$cacheDir"
 if ! [ -f "$cacheDir/$urlHash" ]; then
	 echo "Downloading $file to cache $cacheDir/$urlHash" 
	 curl -fSL -C - "${url}" -o "$cacheDir/$urlHash"
 fi
 cp "$cacheDir/$urlHash" "${file}" 
}


## ubuntu & debian
ubuntuDistInstallRepo(){
$SUDO apt-get install -y \
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
$SUDO apt-get install -y \
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
$SUDO rm /usr/local/bin/docker-compose
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

template(){
local envName="$1"
local template="$2"

	! [ -d "${envName}/ops/" ] && mkdir -p "${envName}/ops/"
	if [ ${template} = "eclipse" ] ; then
		for dir in workspace developer ; do 
			! [ -d "${envName}/${dir}" ] && mkdir -p "${envName}/${dir}";  
		done ; 
		cp eclipse-compose.yml "${envName}"/docker-compose.yml
		cp -r ops/eclipse.dockerfile "${envName}/ops/Dockerfile"
		cp -r ops/eclipse.ide.sh "${envName}/ops/ide.sh"
	fi
	if [ ${template} = "intelliJ" ] ; then
		for dir in IdeaProjects developer ; do 
			! [ -d "${envName}/${dir}" ] && mkdir -p "${envName}/${dir}";  
		done ;
		cp intelliJ-compose.yml "${envName}"/docker-compose.yml
		cp -r ops/intelliJ.dockerfile "${envName}/ops/Dockerfile"
		cp -r ops/intelliJ.ide.sh "${envName}/ops/ide.sh"
		ln -fs "$(basename $(ls -1d "${envName}"/idea* | egrep -v 'idea$|\.tar' | head -1) )" "${envName}/idea"
	fi

}

create(){
local envName="$1"
local JDKURL="$2"
local ideURL="$3"
local template=$4

	echo "creating dir ${envName}"
	! [ -d "${envName}" ] && mkdir -p "${envName}"
	download "${JDKURL}" "${envName}/"jdk.tar.gz && (cd "${envName}"; tar xzf jdk.tar.gz )
	download "${ideURL}" "${envName}/"ide.tar.gz && (cd "${envName}"; tar xzf ide.tar.gz )
	ln -fs $(basename $(ls -1d "${envName}/"jdk* | egrep -v 'jdk$|\.tar' | head -1)) "${envName}/"jdk ; 

	template "${envName}" "${template}"
	 
	echo "DISPLAY=$DISPLAY" > "${envName}/.env"  
	echo "UID=$(id -u)" >> "${envName}/.env"  
	echo "GID=$(id -u)" >> "${envName}/.env"  
	echo "BUILDTAG=$(basename $(ls -1d "${envName}"/jdk* | egrep -v 'jdk$|\.tar' | head -1) )" >>  "${envName}/.env"  

	runCompose "${envName}"
}

downloadGitIgnore(){
  mkdir -p ./gitignore
  download "https://raw.githubusercontent.com/github/gitignore/master/Global/JetBrains.gitignore" "./gitignore/intellyJ"
  download "https://raw.githubusercontent.com/github/gitignore/master/Global/Eclipse.gitignore" "./gitignore/eclipse"
  download "https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore" "./gitignore/vim"
}

runCompose(){
local envName="$1"
	export TMPDIR="${envName}/tmp" ; 
	mkdir -p "$TMPDIR" ; 
	(cd "${envName}" ; docker-compose build --no-cache --force-rm ) 
	rm -r "$TMPDIR" ; 
	unset TMPDIR ;  
}


case $1 in
	intellij|intelliJ)
		# Environment Name
		[ "$2"x = x ] || envName="$2"
		[ "$envName"x = x ] && envName="../IdeEnvironment-"$(date +%s)
		create "${envName}" "${JDKURL}" "${IntelliJURL}" "intelliJ"
		;;
	eclipse)
		# Environment Name
		[ "$2"x = x ] || envName="$2"
		[ "$envName"x = x ] && envName="../IdeEnvironment-"$(date +%s)
		create "${envName}" "${JDKURL}" "${ECLIPSEURL}" "eclipse"
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
