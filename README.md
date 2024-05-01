# GOAL
Isolate the IDE environment between host, updates, dependencies test, plugins compatibilities, so you can use multiple configurations of the same IDE with minimal memory overhead. 
Run the application (from your IDE) with the custom environment required.

# Usage
 - `./createEnv.sh -h`
 - ` /bin/bash createEnv.sh create <projectTarget> <imageEnv> <imageServices>`

    ```
      $ ./createProject.sh create ~/test docker-images/00_envs/debian.stable.env intellij_ce postgres firebase
      $ cd ~/test
      $ docker-compose up ide &
      $ rdesktop -u user -p user -g 1920x1040 localhost &
      $ # ... coppy serviceApplicationKey.json to firebase credential's dir
      $ docker-compose run firebase start

    ``` 
### Host dependencies
#### pacakges 
 - [yq](https://packages.debian.org/bookworm/yq)
 - [docker-compose](https://packages.debian.org/bookworm/docker-compose)

#### repos
 - [docker-image](https://github.com/fritzmatias/docker-images)

 ### Docker compose commands
  - `docker compose up/down` start/stop all the instances & networks related to the ./docker-compose.yml.
  - `docker compose run` runs/stop all the instances & networks related to the ./docker-compose.yml.
  - `docker compose ps` gives the list of current running instances related to the ./docker-compose.yml.
  - `docker compose stop/start <name>` stop/start only the instance related to the ./docker-compose.yml (useful to restart a service but not the ide)
  - `docker ps` list running docker image
  - `docker exec -it <name/image> /bin/sh` attachs to a docker image
