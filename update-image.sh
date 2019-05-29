#!/usr/bin/env bash

build_image() {
  echo "build_image(): begin"
  local commit_hash="$1"
  echo "commit_hash:$commit_hash"

  local diffs=$(git diff-tree --no-commit-id --name-only -r "$commit_hash")
  for diff in ${diffs}; do
    if [[ ${diff} = *Dockerfile* ]]; then
      local path="${diff//'/Dockerfile'}"
      build_push_image "$path" '--pull'
    else
      echo "Skipping diff: $diff"
    fi
  done

  echo "build_image(): end"
}

update_baseimage() {
  echo "update_baseimage(): begin"
  local supported_tags="$(cat ./supported-tags.txt)"

  for path in ${supported_tags}; do
    build_push_image "$path" '--pull'
  done

  echo "update_baseimage(): begin"
}

build_push_image() {
  local path="$1"
  local build_option="$2"
  local local image="ibaiborodine/dockerhub-test:${path/'/'/'-'}"

  echo "Building image: $image $build_option"
  docker build $(echo "$build_option") --tag "$image" "$path"

  echo "Pushing image: $image"
  # assuming successful docker login before executing this script
  docker push "$image"
}

main() {
  set -e
  # dump to console
  exec 2>&1

  # be quite
  # exec 1> /dev/null 2>&1

  local commit_hash="$1"

  if [[ -n "$commit_hash" ]]; then
    local diffs=$(git diff-tree --no-commit-id --name-only -r "$commit_hash")

    for diff in ${diffs}; do
      if [[ ${diff} = *Dockerfile* ]]; then
        local path="${diff//'/Dockerfile'}"
        build_push_image "$path"
      else
        echo "Skipping diff: $diff"
      fi
    done
  else
    for path in "$(cat ./supported-tags.txt)"; do
      build_push_image "$path" '--pull'
    done
  fi
}

main "$@"
