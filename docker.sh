#!/bin/bash

# exit immediately upon first error
set -e -x

if which podman
then
    mountz=":Z"
    docker="podman"
else
    mountz=""
    docker="docker"
fi 

# prefer docker
# docker=$(which podman || which docker)

echo "Using $docker $mountz"

$docker build -t eqlog .
$docker run --rm -it -v $(pwd):/usr/src/pldi23-eqlog-artifact${mountz} eqlog $@
