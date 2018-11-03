#!/bin/sh

set -ev

cd docs

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook', output_dir = 'rendered')"

touch rendered/.nojekyll

cp -Rf assets rendered/
cp -Rf figures rendered/

cd ..