FROM --platform=linux/x86_64 racket/racket:8.6
ENV PROJECT_NAME=eqlog
SHELL ["bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    software-properties-common \
    git \
    python3-matplotlib

# install souffle
RUN wget --no-check-certificate https://github.com/souffle-lang/souffle/releases/download/2.3/x86_64-ubuntu-2004-souffle-2.3-Linux.deb -O souffle.deb && \
    apt-get install -y ./souffle.deb && rm souffle.deb && souffle --version

## install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.66.1 -y

WORKDIR /usr/src/pldi23-eqlog-artifact

## envs
ENV PATH="$PATH:/root/.cargo/bin"
ENV CARGO_HOME=/usr/src/pldi23-eqlog-artifact/.cargo-docker
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

COPY eqlog eqlog
RUN cd eqlog && cargo build --release

COPY micro-benchmarks micro-benchmarks
COPY pointer-analysis-benchmark pointer-analysis-benchmark
COPY herbie-eqlog herbie-eqlog

# RUN cd micro-benchmarks && cargo build --release

RUN cd herbie-eqlog && make install
RUN cd herbie-eqlog && cargo build --release --manifest-path=egg-herbie/Cargo.toml


# copy makefile last so we can edit it without rebuilding herbie
COPY Makefile Makefile

ENTRYPOINT [ "bash", "-c" ]
