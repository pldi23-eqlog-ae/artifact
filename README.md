# PLDI 2023 Artifact: "Better Together: Unifying Datalog and Equality Saturation"

This is the artifact for PLDI 2023 paper #129, artifact #54, titled 
"Better Together: Unifying Datalog and Equality Saturation".

## Claims

This artifact provides support for the following claims made in the paper:

1. `EqLog` is a tool that provides support for both Datalog and equality saturation.
2. `EqLog` is more efficient than the `egg` equality saturation tool on 
    `egg`'s "math" benchmark (Section 5.3).
3. `EqLog` outperforms the `cclyzer++` pointer anaylsis 
    tool build on top of the `Souffle` Datalog system (Section 6.1).
4. `EqLog` can replace `egg` as the equality saturation engine in the Herbie floating-point optimization tool, achieving similar accuracy performance.


## Artifact Layout

At the top level, the artifact contains this README, a Dockerfile to install dependencies, and a Makefile to orchestrate running the artifact.

The `EqLog` tool itself is in the `eqlog` folder.
This folder has been stripped down from the version that lives on Github for anonymity.

The other folders each containing supporting infrastructure and data for the evaluation of `EqLog` in support of the above claims.

## Installing and running the artifact

The provided Dockerfile will supply the necessary dependencies to run the artifact. Run the following from this directory to be dropped into a Bash shell with all the dependencies installed.

```shell
docker build -t pldi23-eqlog-artifact .
docker run --name running-artifact --rm -itp 8080:8080 pldi23-eqlog-artifact:latest bash
```

This may take a few minutes the first time, as it has to build the Docker image. We recommend using an x86 machine to run our artifact.

Once in the container shell, you can then run invoke the `Makefile` to run the various parts of the artifact. To just "kick the tires" and ensure things are working, run the following to just build and test the `EqLog` tool:

```shell
make test
```

## Validating Claims


Run the `Makefile` inside the Docker container to run all components of the artifact in order:

```shell
make
```

You may inspect the `Makefile` to see the individual targets, but simply invoking `make` will generate everything needed to validate the claims.

To view the generated plots, you can run `python3 -m http.server 8080 &` in the docker and visit `localhost:8080`, which allows you to view and download data and plots generated in your browser.

### Claim #1

Invoking `make test` (as above) will build and run the `EqLog` tool.

Among the tests run are `eqlog/tests/path.egg`, a classic Datalog program to compute reachability in a graph, and `eqlogl/tests/eqsat-basic`, a simple equality saturation program to prove two arithmetic expressions equivalent.

### Claim #2

Invoking `make micro-benchmark`  will build and run the `math` micro-benchmarks. This may take more than two hour, and when it finishes, it will generate a plot at `micro-benchmarks/benchmarks.pdf`.
Alternatively, you can run `make micro-benchmark-small` to generate a plot for a smaller micro-benchmark at `micro-benchmarks/benchmarks-small.pdf`, which should finish within seconds.

The generated plot may look slightly different than Figure 7 in the submitted version.
This is because, during the deadline push, we disabled a fast-forwarding optimization for the BackOff scheduler when comparing with egg.
For artifact evaluation, we implemented fast-forwarding for eqlog and reverted our changes to egg. 
This should reflect a more accurate comparison using the default BackOff scheduler.
Because of the fast-forwarding, egg and EqLogNI avoids searching for rules known to not produce any matches in certain cases (EqLog is able to avoid these cases any way thanks to the semi-naive evaluation).
As a result, the curves for EqLogNI and egg in the new plot do not have the long horizontal segments (which means take a long time but make no progress).

In the updated plot, our claim about EqLog and EqLogNI being faster than egg stills hold. 
Moreover, the detailed data shows that EqLog still explores a slightly larger program space than EqLogNI and egg.

### Claim #3

Invoking `make pointer-analysis-benchmark`  will build and run the Steensgaard analysis benchmark and compare against the Souffle baselines. This may take more than an hour, and when it finishes, it will generate a plot at `pointer-analysis-benchmark/plot.pdf`.
Alternatively, you can run `make pointer-analysis-benchmark-small` to generate a plot for a smaller pointer-analysis benchmark at `pointer-analysis-benchmark/plot_small.pdf`, which should finish within minutes.

The generated plot should look similar to Figure 8, showing EqLog is faster than all the Souffle baselines.

### Claim #4

Invoking `make herbie` will run the Herbie floating-point optimization tool, once with `EqLog` as the equality saturation engine and once with `egg` as the equality saturation engine. This may take more than two hours, and when it finishes, it will generate plots at `herbie-eqlog/eqlogdata`.

Specifically, we claim that the `herbie-eqlog/eqlogdata/errorhist.pdf` plot should look quite similar to Figure 11 in the paper, demonstrating the `EqLog` achieves similar performance to `egg`.