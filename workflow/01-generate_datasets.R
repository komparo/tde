library(tidyverse)
library(fs)
library(processx)


#   ____________________________________________________________________________
#   Run all dataset modules                                                 ####
dataset_modules <- tibble(
  snakefile_location = fs::dir_ls("modules/datasets", recursive = TRUE, regexp = "/Snakefile")
) %>% 
  mutate(
    source = str_replace(snakefile_location, "modules/datasets/(.*)/Snakefile", "\\1"),
    folder = str_glue("data/datasets/{source}/")
  )

# create output folders if they do not exist
fs::dir_create(dataset_modules$folder)

# call the workflow of every dataset module
dataset_module <- as.list(dataset_modules[1, ])
processx::run(
  "snakemake",
  c(
    "--use-singularity",
    "--snakefile",
    dataset_module$snakefile_location,
    "--directory",
    dataset_module$folder
  ),
  echo_cmd = T
)


#   ____________________________________________________________________________
#   List all datasets and the objects they created                          ####

datasets <- tibble(
  meta_location = fs::dir_ls("data/datasets/", regexp = "/meta.yml")
)
