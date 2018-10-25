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







report_thumbnails <- rscript_call(
  "report_thumbnails",
  design = reports$design %>% 
    mutate(
      script = list(script_file("scripts/report_overview/create_thumbnail.R")),
      thumbnail = str_glue("reports/assets/screenshots/{id}/screenshot.png") %>% map(derived_file)
    ),
  inputs = c("script", "rendered"),
  outputs = c("thumbnail")
)

report_render_overview <- rmd_call(
  "report_overview",
  design = list(
    reports = bind_cols(reports$design, report_thumbnails$design) %>% 
      select(rendered, thumbnail) %>% 
      map(object_set) %>% 
      object_set(),
    script = script_file("scripts/report_overview/report_overview.Rmd"),
    style = raw_file("scripts/report_overview/style.css"),
    rendered = derived_file("reports/index.html")
  ),
  inputs = c("script", "style", "reports"),
  outputs = c("rendered")
)


report_overview <- call_collection(
  "report_overview",
  report_thumbnails,
  report_render_overview
)
