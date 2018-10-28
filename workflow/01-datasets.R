library(tidyverse)
library(fs)
library(processx)
library(certigo)

#   ____________________________________________________________________________
#   Run all dataset modules                                                 ####
dataset_modules <- tibble(
  script_location = fs::dir_ls(recursive = TRUE, regexp = "modules/datasets/[^/]*/[^/]*/workflow.R")
) %>%
  mutate(
    folder = fs::path_dir(script_location),
    id = fs::path_dir(script_location) %>% fs::path_rel("modules/datasets"),
    datasets_directory = str_glue("data/datasets/{id}/")
  )

# call the workflow of every dataset module
dataset_module <- as.list(dataset_modules[1, ])

datasets_oi <- load_call(
  dataset_module$script_location,
  derived_file_directory = dataset_module$datasets_directory,
  id = dataset_module$id
)

datasets <- datasets_oi %>% call_collection("datasets", .)