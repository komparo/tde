library(tidyverse)
library(fs)
library(processx)

source("workflow/01-datasets.R")
source("workflow/02-methods.R")
source("workflow/03-metrics.R")
source("workflow/04-reports.R")

workflow <- workflow(
  datasets,
  models,
  scores,
  reports,
  report_overview
)

workflow$reset()
workflow$run()

