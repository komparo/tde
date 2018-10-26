#!/bin/sh

set -ev

cd docs

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook', output_dir = 'rendered')"

touch .nojekyll

cd ..