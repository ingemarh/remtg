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

# 1. Copy the data to the input directory
# Here are example data for testing:
# DATA_DIR=$PWD/test-input
#
DATA_DIR=$1
[ -z $DATA_DIR] && DATA_DIR=$PWD/test-input

#2. Create a directory for output
# Example
# OUT_DIR=$HOME/tmp/remtg
#
OUT_DIR=$2
[ -z $OUT_DIR] && OUT_DIR=$HOME/tmp/remtg

# Run the container
# docker pull $DOCKER_IMAGE
docker run --rm --name remtg --mount type=bind,source=$DATA_DIR,destination=/srv/data --mount type=bind,source=$OUT_DIR,destination=/var/tmp $DOCKER_IMAGE


