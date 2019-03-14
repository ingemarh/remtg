#! /bin/bash
### EISCAT rtg software / data overview animation
### (C) Ingemar Häggström ingemar@eiscat.se
###
### Docker version
### Carl-Fredrik Enell 2019 carl-fredrik.enell@eiscat.se
###
### Usage example for running the Docker container version
##########################################################

DOCKER_IMAGE=eiscat/remtg_volume:latest
WORKDIR=$(pwd)
CONTAINERDIR=/var/tmp

# Run the container
# docker pull $DOCKER_IMAGE
docker run --rm --name remtg \
       --mount type=bind,source=$WORKDIR,destination=$CONTAINERDIR \
       $DOCKER_IMAGE

# Dirac expects exit status
exit $?


