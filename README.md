A Docker container with very basic provisioning of Ubuntu + nginx + PHP7.0 + MySQL

# Usage
## OSX / Ubuntu:
`docker run -it --rm --name lemp -p 80:80 --mount type=bind,source=$(PWD),target=/var/www/html/ kmrd/lemp`

## Windows:
`docker run -it --rm --name lemp -p 80:80 --mount type=bind,source="%cd%",target=/var/www/html/ kmrd/lemp`

## Cheatsheet
List docker containers
`docker ps`

SSH into container
`docker exec -it <container_id> /bin/bash`
