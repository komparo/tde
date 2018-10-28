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
    scores_directory = str_glue("data/scores/{id}/")
  )

# call the workflow of every metric module
metric_module <- as.list(metric_modules[1, ])

scores_oi <- load_call(
  metric_module$script_location,
  derived_file_directory = metric_module$scores_directory,
  id = metric_module$id,
  models = models
)

scores <- scores_oi %>% call_collection("metrics", .)
