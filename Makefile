.PHONY: test
test:
	cd eqlog && cargo test --release

# build: build-egg-smol build-micro-benchmark build-steensgaard-analysis-benchmark

# build-egg-smol:
# 	cd egg-smol && cargo build --release

# build-micro-benchmark
# 	cd micro-benchmark && cargo build --release

# build-steensgaard-analysis-benchmark
# 	cd steensgaard-analysis-benchmark && cargo build --release

# micro-benchmarks: build-micro-benchmark

