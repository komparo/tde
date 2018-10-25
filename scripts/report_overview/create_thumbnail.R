library(tidyverse)
library(webdriver)

report <- inputs[["rendered"]]

# webdriver::install_phantomjs()

phantomjs <- run_phantomjs()
ses <- Session$new(port = phantomjs$port)
ses$go(report)

screenshot <- ses$takeScreenshot(outputs[["thumbnail"]])

