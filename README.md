# GOAL
Isolate the IDE environment between updates, dependencies test, plugins compatibilities, so you can use multiple configurations of the same IDE with minimal memory overhead. 
Run the application (from your IDE) with the custom environment required.

### Dockerized Eclipse IDE
All the ide environment is encapsulated inside a docker.

 - Inside the docker all the data is at /java & /home/developer
 - On the host all the data is at the ../${envName}
 - A map between folders are managed by docker volume parameters.
 - don't forget to map the ports between your host and the docker after the setup.

### Dockerized IntelliJ Idea IDE
All the ide environment is encapsulated inside a docker.

 - Inside the docker all the data is at /java & /home/developer
 - On the host all the data is at the ../${envName}
 - A map between folders are managed by docker volume parameters.
 - don't forget to map the ports between your host and the docker after the setup.

### Install
 - Modify the internal variables of createEnv if you want different JDK & eclipse versions
 - ` /bin/bash createEnv.sh `

#### Downloads
 - [JDK](https://openjdk.java.net/install/)
   - [JDK11](https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz)
   - [JDK8](https://download.java.net/java/jdk8u192/archive/b04/binaries/jdk-8u192-ea-bin-b04-linux-x64-01_aug_2018.tar.gz)
 - [Eclipse-JEE SPS](https://spring.io/tools3/eclipse)
   -  [latest](http://download.springsource.com/release/ECLIPSE/2018-09/eclipse-jee-2018-09-linux-gtk-x86_64.tar.gz)

