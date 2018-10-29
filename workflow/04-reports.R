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
    reports_directory = str_glue("reports/{id}/")
  )

# call the workflow of every metric module
report_module <- as.list(report_modules[1, ])

reports_oi <- load_call(
  report_module$script_location,
  derived_file_directory = report_module$reports_directory,
  id = report_module$id,
  datasets = datasets,
  models = models,
  scores = scores
)

reports <- reports_oi %>% call_collection("reports", .)






# Generate report overview

report_thumbnails <- rscript_call(
  "report_thumbnails",
  design = reports$design %>% 
    mutate(
      script = list(script_file("scripts/report_overview/create_thumbnail.R")),
      thumbnail = str_glue("reports/assets/screenshots/{id}/screenshot.png") %>% map(derived_file)
    ),
  inputs = exprs(script, rendered),
  outputs = exprs(thumbnail)
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
  inputs = exprs(script, style, reports),
  outputs = exprs(rendered)
)


report_overview <- call_collection(
  "report_overview",
  report_thumbnails,
  report_render_overview
)
