# Nginx PHP MySQL

Docker running Nginx, PHP-FPM, Composer, MySQL and adminer.

## Overview

1. [Install prerequisites](#install-prerequisites)

   Before installing project make sure the following prerequisites have been met.

2. [Clone the project](#clone-the-project)

   We’ll download the code from its repository on GitHub.

3. [Use Makefile](#use-makefile) [`Optional`]

   When developing, you can use `Makefile` for doing recurrent operations.

4. [Run the application](#run-the-application)

   By this point we’ll have all the project pieces in place.


## Install prerequisites

To run the docker commands without using **sudo** you must add the **docker** group to **your-user**:

```
sudo usermod -aG docker $USER
```

For now, this project has been mainly created for Unix `(Linux/MacOS)`. Perhaps it could work on Windows.

All requisites should be available for your distribution. The most important are :

* [Git](https://git-scm.com/downloads)
* [Docker](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)

Check if `docker-compose` is already installed by entering the following command :

```sh
which docker-compose
```

The following is optional but makes life more enjoyable :

```sh
which make
```

### Images to use

* [Nginx](https://hub.docker.com/_/nginx/)
* [MySQL](https://hub.docker.com/_/mysql/)
* [PHP-FPM](https://hub.docker.com/_/php/) own build by command make build
* [Composer](https://hub.docker.com/_/composer/)
* [Adminer](https://registry.hub.docker.com/_/adminer/)

## Clone the project

Clone repository to the common place

```bash
git clone https://github.com/VitaliyIlinov/docker_compose.git ~/workspace/docker_compose
```

## Use Makefile

When developing, you can use [Makefile](https://en.wikipedia.org/wiki/Make_(software)) for doing the following operations :

| Name          | Description                                  |
|---------------|----------------------------------------------|
| build         | Build docker images                          |
| clean         | Clean directories for reset                  |
| code-sniff    | Check the API with PHP Code Sniffer (`PSR2`) |
| up            | Create and start containers                  |
| down          | Stop and clear all services                  |
| logs [NAME]   | Follow log output                            |
| mysql-dump    | Create database backup                       |
| mysql-restore | Restore database backup                      |
| bash          | Enter to main container                      |
| composer      | Bash to container & Install composer         |

## Run the application

1. Copying the **env** configuration file :

    ```sh
    cp .env.example .env
    ```

2. Build php-fmp application :

    ```sh
    make build
    ```

3. Create folder logs with permissions :

    ```sh
    mkdir -p storage && chmod -R 777 storage
    ```

4. Start the application :

    ```sh
    make up
    ```

   ```sh
    make composer
    ```

   **Please wait this might take a several minutes...**

    ```sh
    make logs -f # Follow log output
    ```

5. Open your favorite browser :

    * [http://localhost:81](http://localhost:81/)
    * [http://localhost:8080](http://localhost:8080/) Adminer (username: root, password: see in **.env**)

5. Stop and clear services

    ```sh
    make down
    ```

5. Clear logs

    ```sh
    make clean
    ```