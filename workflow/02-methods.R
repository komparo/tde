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
    models_folder = str_glue("data/models/{id}/")
  )

# call the workflow of every method module
method_module <- as.list(method_modules[1, ])

module_environment <- new.env()
source(method_module$script_location, local = module_environment)

methods <- get("generate_method_calls", module_environment)(
  workflow_folder = method_module$folder,
  models_folder = method_module$models_folder,
  datasets = datasets
) %>% call_collection("methods/", .)

workflow(methods)$run()
