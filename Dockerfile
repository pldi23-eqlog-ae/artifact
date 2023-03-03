FROM ubuntu:latest
ENV PROJECT_NAME=eqlog
SHELL ["bash", "-c"]

# INSTALL DEPENDENCIES
RUN apt update && apt-get install -y \
    software-properties-common \
    wget curl \
    build-essential \
    python3-pip \
    bison \
    build-essential \
    clang \
    cmake \
    doxygen \
    flex \
    g++ \
    git \
    libffi-dev \
    libncurses5-dev \
    libsqlite3-dev \
    make \
    mcpp \
    sqlite \
    zlib1g-dev \
    && pip3 install matplotlib
## install racket
RUN add-apt-repository ppa:plt/racket -y && apt update -y && apt-get install racket=8.6+ppa1-1~jammy1 -y
## install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.66.1 -y
## install souffle
RUN wget https://github.com/souffle-lang/souffle/archive/refs/tags/2.3.tar.gz \
    && tar -xf 2.3.tar.gz \
    && cd souffle-2.3 \
    && cmake -S . -B build \
    && cmake --build build --target install \
    && rm -rf 2.3.tar.gz souffle-2.3
WORKDIR /usr/src/pldi23-eqlog-artifact
## envs
ENV PATH="$PATH:/root/.cargo/bin"
ENV CARGO_HOME=/usr/src/pldi23-eqlog-artifact/.cargo-docker

COPY eqlog eqlog
RUN cd eqlog && cargo build --release

COPY micro-benchmarks micro-benchmarks
COPY pointer-analysis-benchmark pointer-analysis-benchmark
COPY herbie-eqlog herbie-eqlog
COPY Makefile Makefile

# RUN cd micro-benchmarks && cargo build --release

# RUN cd herbie-eqlog && make install
# RUN cd herbie-eqlog && cargo build --release --manifest-path=egg-herbie/Cargo.toml
#RUN cd herbie-eqlog && make install



ENTRYPOINT [ "bash", "-c" ]
