library(tidyverse)
library(fs)
library(processx)

#   ____________________________________________________________________________
#   Run all dataset modules                                                 ####
dataset_modules <- tibble(
  script_location = fs::dir_ls(recursive = TRUE, regexp = "modules/datasets/[^/]*/[^/]*/workflow.R")
) %>%
  mutate(
    folder = fs::path_dir(script_location),
    id = fs::path_dir(script_location) %>% fs::path_rel("modules/datasets"),
    datasets_folder = str_glue("data/datasets/{id}/")
  )

# call the workflow of every dataset module
dataset_module <- as.list(dataset_modules[1, ])

module_environment <- new.env()
source(dataset_module$script_location, local = module_environment)

datasets <- get("generate_dataset_calls", module_environment)(
  workflow_folder = dataset_module$folder,
  datasets_folder = dataset_module$datasets_folder
)

datasets$start_and_wait()