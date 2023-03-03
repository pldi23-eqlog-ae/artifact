FROM racket/racket:8.6
ENV PROJECT_NAME=eqlog
SHELL ["bash", "-c"]

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.66.1 -y
WORKDIR /usr/src/pldi23-eqlog-artifact

# COPY eqlog eqlog
# COPY micro-benchmark micro-benchmark
# COPY steensgaard-analysis-benchmark steensgaard-analysis-benchmark
# COPY Makefile Makefile

RUN apt-get install -y build-essential
COPY herbie-eqlog herbie-eqlog
ENV PATH="$PATH:/root/.cargo/bin"
RUN cd herbie-eqlog && make install
RUN cd herbie-eqlog && cargo build --release --manifest-path=egg-herbie/Cargo.toml
#RUN cd herbie-eqlog && make install

ENV CARGO_HOME=/usr/src/pldi23-eqlog-artifact/.cargo-docker


ENTRYPOINT [ "bash", "-c" ]
