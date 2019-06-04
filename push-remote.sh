#!/usr/bin/env bash

main() {
  local github_repo="@1"
  echo "github_repo: $github_repo"
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
  git add .
  git commit -m "Update README.md [skip travis]"
  git push "https://${TRAVIS_GITHUB_TOKEN}@${github_repo}" HEAD:master > /dev/null 2>&1
}

main "$@"
