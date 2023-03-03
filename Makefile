.PHONY: test build-eqlog micro-benchmark-small micro-benchmark pointer-analysis-benchmark
test:
	cd eqlog && cargo test --release

# build: build-egg-smol build-micro-benchmark build-steensgaard-analysis-benchmark

build-eqlog:
	cd eqlog && cargo build --release

micro-benchmark-small:
	cd micro-benchmarks && cargo run --release -- --repeat 1 --iter-size 40 --csvfile benchmarks-small.csv
	cd micro-benchmarks && python3 plot.py --no-viz --csvfile benchmarks-small.csv --pdffile benchmarks-small.pdf

micro-benchmark:
	cd micro-benchmarks && cargo run --release -- --repeat 3 --iter-size 100 --csvfile benchmarks.csv
	cd micro-benchmarks && python3 plot.py --no-viz --csvfile benchmarks.csv --pdffile benchmarks.pdf

pointer-analysis-benchmark-small:
	cd pointer-analysis-benchmark && python3 run.py --build-egglog --disable-naive --disable-buggy

pointer-analysis-benchmark:
	cd pointer-analysis-benchmark && python3 run.py --build-egglog

herbie:
	cd herbie-eqlog && bash evalegglog.sh

# build-steensgaard-analysis-benchmark
# 	cd steensgaard-analysis-benchmark && cargo build --release

# micro-benchmarks: build-micro-benchmark

