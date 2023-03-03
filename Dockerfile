FROM ubuntu:latest
ENV PROJECT_NAME=eqlog
SHELL ["bash", "-c"]

# INSTALL DEPENDENCIES
RUN apt update
RUN apt-get install software-properties-common -y
## install racket
RUN add-apt-repository ppa:plt/racket -y
RUN apt update -y
RUN apt-get install racket -y
RUN apt install curl -y
## install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.66.1 -y
## build-essential
RUN apt-get install build-essential -y
## pip3
RUN apt-get install python3-pip -y
RUN pip3 install matplotlib
## envs
ENV PATH="$PATH:/root/.cargo/bin"
ENV CARGO_HOME=/usr/src/pldi23-eqlog-artifact/.cargo-docker

WORKDIR /usr/src/pldi23-eqlog-artifact
COPY eqlog eqlog
COPY micro-benchmarks micro-benchmarks
COPY pointer-analysis-benchmark pointer-analysis-benchmark
COPY herbie-eqlog herbie-eqlog
COPY Makefile Makefile


RUN cd herbie-eqlog && make install
RUN cd herbie-eqlog && cargo build --release --manifest-path=egg-herbie/Cargo.toml
#RUN cd herbie-eqlog && make install



ENTRYPOINT [ "bash", "-c" ]
