
![komparo / Trajectory Differential Expression](docs/figures/logo.png)

**Disclaimer**: This repository is an attempt to create a workflow for
continuous and collaborative benchmarking, applied on trajectory
differential expression methods. It’s still **a big work in progress**,
and is currently only meant to explore the possibilities of such a
benchmarking strategy. This is not a serious benchmark yet, but stay
tuned\!

-----

The benchmark has three main components:

  - Common **file formats** for interchanging data
  - **Modules** which generate datasets, run a method, evaluate the
    output, and generate a report
  - **Benchmark workflow**, which runs the modules, validate their
    output, and ultimately generate a set of reports published at
    [tde.netlify.com](https://tde.netlify.com)

These different components are all discussed in the contributors guide:
[komparo.github.io/tde](https://komparo.github.io/tde)
