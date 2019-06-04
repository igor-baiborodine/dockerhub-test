#!/usr/bin/env bash

set -e

REPO_URL='https://github.com/igor-baiborodine/dockerhub-test'

replace_field() {
  local targetFile="$1"
  local field="$2"
  local content="$3"

  local extraSed="${4:-}"
  local sed_escaped_value
  sed_escaped_value="$(echo "$content" | sed 's/[\/&]/\\&/g')"
  sed_escaped_value="${sed_escaped_value//$'\n'/\\n}"
  sed -ri -e "s/${extraSed}%%${field}%%${extraSed}/$sed_escaped_value/g" "$targetFile"
}

main() {
  local supported_tag="$1"
  local commit_hash="$2"
  echo "supported_tag: $supported_tag, commit_hash: $commit_hash"

  sed -i 's,'"$supported_tag"','"$supported_tag:$commit_hash"',g' ./supported-tags
  local tags_content=

  for t in $(cat ./supported-tags); do
    local tag="${t%%:*}"
    local commit="${t#*:}"
    echo "tag: $tag, commit: $commit"

    tags_content='-  [`'"${tag/\//-}"'` (*'"${tag}/Dockerfile"'*)]('"${REPO_URL}/blob/${commit}/${tag}/Dockerfile"$')\n'"$tags_content"
  done
  echo "tags_content: $tags_content"

  cat ./template.md > ./README.md
  replace_field ./README.md 'TAGS' "$tags_content"
}

main "$@"
