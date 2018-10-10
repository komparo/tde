library(dyntoy)
library(readr)
library(dplyr)

# read parameters
params <- jsonlite::fromJSON(snakemake@input[[1]])
testthat::expect_true(all(names(params) %in% c("seed", names(formals(dyntoy::generate_dataset)))))
set.seed(params$seed)

# generate datasets
dataset <- purrr::invoke(dyntoy::generate_dataset, params[intersect(names(params), names(formals(dyntoy::generate_dataset)))])

# write dataset
write.csv(dataset$expression, snakemake@output[["expression"]])
