#!/usr/bin/env bash

main() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"

  mkdir ~/temp
  git clone "https://github.com/igor-baiborodine/$REPO.git" ~/temp
  cp "~/$REPO/README.md" "~/$REPO/supported-tags" "~/temp/$REPO"

  cd "~/temp/$REPO"
  git add README.md supported-tags
  git status
  git commit -m "$TRAVIS_COMMIT_MESSAGE [skip travis]"
  git push "https://${TRAVIS_GITHUB_TOKEN}@${REPO}" master > /dev/null 2>&1
}

main "$@"
