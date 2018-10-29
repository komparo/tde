library(tidyverse)
library(fs)
library(processx)

#   ____________________________________________________________________________
#   Run all method modules                                                 ####
method_modules <- tibble(
  script_location = fs::dir_ls(recursive = TRUE, regexp = "modules/methods/[^/]*/[^/]*/workflow.R")
) %>%
  mutate(
    folder = fs::path_dir(script_location),
    id = fs::path_dir(script_location) %>% fs::path_rel("modules/methods"),
    models_directory = str_glue("data/models/{id}/")
  )

# call the workflow of every method module
method_module <- as.list(method_modules[1, ])

models_oi <- load_call(
  method_module$script_location,
  derived_file_directory = method_module$models_directory,
  id = method_module$id,
  datasets = datasets
)

models_oi$design$method_id <- paste0(method_module$id, models_oi$design$method_id)

models <- models_oi %>% call_collection("methods", .)