#!/bin/sh

set -e

pushd docs

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "wouter.saelens@gmail.com"
git config --global user.name "Wouter Saelens"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
cp -r ../rendered/* ./
git add --all *
git commit -m "Automated book deployment through travis" || true
git push -q origin gh-pages

popd