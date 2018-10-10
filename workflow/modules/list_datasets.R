library(tidyverse)

inputs <- snakemake@input %>% as.character()

write_csv(tibble(input = inputs), snakemake@output[[1]])
