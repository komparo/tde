#!/bin/sh

set -ev
pushd docs
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook', output_dir = 'rendered')"
popd