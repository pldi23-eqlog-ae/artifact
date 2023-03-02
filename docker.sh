#!/bin/bash

# exit immediately upon first error
set -e -x

docker build -t eqlog .
docker run --rm -it -v $(pwd):/usr/src/pldi23-eqlog-artifact eqlog $@