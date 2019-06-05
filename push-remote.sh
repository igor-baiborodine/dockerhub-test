#!/usr/bin/env bash

main() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
  printenv

  git clone "https://github.com/igor-baiborodine/$REPO.git" "~/$REPO"
  ls -al "~/$REPO"
#  cp "$TRAVIS_BUILD_DIR/$REPO/README.md" "$TRAVIS_BUILD_DIR/$REPO/supported-tags" "$TRAVIS_BUILD_DIR/temp"
#
#  cd ~/temp
#  git add README.md supported-tags
#  git status
#  git commit -m "$TRAVIS_COMMIT_MESSAGE [skip travis]"
#  git push "https://${TRAVIS_GITHUB_TOKEN}@${REPO}" master > /dev/null 2>&1
}

main "$@"
