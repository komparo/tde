library(tidyverse)
library(fs)
library(processx)

#   ____________________________________________________________________________
#   Run all report modules                                                 ####
report_modules <- tibble(
  script_location = fs::dir_ls(recursive = TRUE, regexp = "modules/reports/[^/]*/[^/]*/workflow.R")
) %>% 
  mutate(
    folder = fs::path_dir(script_location),
    id = fs::path_dir(script_location) %>% fs::path_rel("modules/reports"),
    reports_folder = str_glue("reports/{id}/")
  )

# call the workflow of every report module
report_module <- as.list(report_modules[1, ])

module_environment <- new.env()
source(report_module$script_location, local = module_environment)

reports <- get("generate_report_calls", module_environment)(
  workflow_folder = report_module$folder,
  reports_folder = report_module$reports_folder,
  datasets = datasets,
  metrics = metrics,
  methods = methods
) %>% call_collection("reports", .)