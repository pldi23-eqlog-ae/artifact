FROM rust:1.66.1
ENV PROJECT_NAME=eqlog
WORKDIR /usr/src/pldi23-eqlog-artifact
ENV CARGO_HOME=/usr/src/pldi23-eqlog-artifact/.cargo-docker

# COPY eqlog eqlog
# COPY micro-benchmark micro-benchmark
# COPY steensgaard-analysis-benchmark steensgaard-analysis-benchmark
# COPY Makefile Makefile

COPY herbie-eqlog herbie-eqlog

RUN apt-get update
RUN apt-get install racket -y
RUN cd herbie-eqlog && make install


ENTRYPOINT [ "bash", "-c" ]
