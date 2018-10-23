library(tidyverse)
library(fs)
library(processx)

#   ____________________________________________________________________________
#   Run all metric modules                                                 ####
metric_modules <- tibble(
  script_location = fs::dir_ls(recursive = TRUE, regexp = "modules/metrics/[^/]*/[^/]*/workflow.R")
) %>%
  mutate(
    folder = fs::path_dir(script_location),
    id = fs::path_dir(script_location) %>% fs::path_rel("modules/metrics"),
    scores_folder = str_glue("data/scores/{id}/")
  )

# call the workflow of every metric module
metric_module <- as.list(metric_modules[1, ])

module_environment <- new.env()
source(metric_module$script_location, local = module_environment)

metrics <- get("generate_metric_calls", module_environment)(
  workflow_folder = metric_module$folder,
  scores_folder = metric_module$scores_folder,
  methods = methods
)
