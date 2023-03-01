FROM rust:1.67
ENV PROJECT_NAME=eqlog
WORKDIR /usr/src/pldi23-eqlog-artifact

COPY egg-smol egg-smol
COPY micro-benchmark micro-benchmark
COPY steensgaard-analysis-benchmark steensgaard-analysis-benchmark
COPY Makefile Makefile
ENTRYPOINT [ "bash" ]