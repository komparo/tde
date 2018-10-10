library(dplyr)
library(tidyr)
library(purrr)

design <- crossing(
  differentially_expressed_rate = seq(0.1, 0.9, 0.1)
) %>% 
  mutate(
    seed = row_number(),
    id = paste0("dyntoy_", row_number())
  )


design %>% pwalk(function(...) {
  params = list(...)
  jsonlite::write_json(params, gsub("__snakemake_dynamic__", params$id, snakemake@output[[1]]))
})
