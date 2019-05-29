#!/usr/bin/env bash

build_image() {
  echo "build_image(): begin"
  local commit_hash="$1"
  echo "commit_hash:$commit_hash"

  git diff-tree --no-commit-id --name-only -r "$commit_hash"

  echo "build_image(): end"
}

update_baseimage() {
  echo "update_baseimage(): begin"
  local supported_tags="$(cat ./supported-tags.txt)"

  for tag in ${supported_tags}; do
    local image="ibaiborodine/dockerhub-test:${tag/'/'/'-'}"
    echo "Building image: $image"
    docker build --pull --tag "$image" "$tag"

    echo "Pushing image: $image"
    # assuming successful docker login before executing this script
    docker push "$image"
  done

  echo "update_baseimage(): begin"
}

main() {
  # dump to console
  exec 2>&1

  # be quite
  # exec 1> /dev/null 2>&1

  if [[ -n "$1" ]]; then
    # build images based on Git commit hash provided
    build_image "$1"
  else
    update_baseimage
  fi
}

main "$@"
