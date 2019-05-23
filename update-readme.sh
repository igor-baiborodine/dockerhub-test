#!/usr/bin/env bash

# https://ops.tips/blog/inspecting-docker-image-without-pull/

IMAGE='ibaiborodine/dockerhub-test'

get_tags() {
  local image="$1"
  echo "Retrieving image tags.
    IMAGE: $image
  " >&2

  curl \
      --silent \
      --location \
      "https://registry.hub.docker.com/v2/repositories/$image/tags?page_size=1024" \
    | jq -r '.results|=sort_by(.name)|.results[].name' \
    | sed '1!G;h;$!d' \
    | tr '\r\n' ' '
}

get_token() {
  local image="$1"

  echo "Retrieving Docker Hub token.
    IMAGE: $image
  " >&2

  curl \
      --silent \
      "https://auth.docker.io/token?scope=repository:$image:pull&service=registry.docker.io" \
    | jq -r '.token'
}

get_digest() {
  local image="$1"
  local tag="$2"
  local token="$3"

  echo "Retrieving image digest.
    IMAGE:  $image
    TAG:    $tag
    TOKEN:  $token
  " >&2

  curl \
      --silent \
      --header "Accept: application/vnd.docker.distribution.manifest.v2+json" \
      --header "Authorization: Bearer $token" \
      "https://registry-1.docker.io/v2/$image/manifests/$tag" \
    | jq -r '.config.digest'
}

get_image_commit() {
  local image="$1"
  local token="$2"
  local digest="$3"

  echo "Retrieving image Git commit.
    IMAGE:  $image
    TOKEN:  $token
    DIGEST: $digest
  " >&2

  curl \
      --silent \
      --location \
      --header "Authorization: Bearer $token" \
      "https://registry-1.docker.io/v2/$image/blobs/$digest"
#    | jq -r '.container_config.Labels.git_commit'
}

main() {
#  local tags
#  tags="$(get_tags ${IMAGE})"
  tags="7.0.6-ga7-jdk8-slim"
  local token
  token=$(get_token ${IMAGE})

  for tag in ${tags}; do
    local digest
    digest=$(get_digest ${IMAGE} ${tag} ${token})

    get_image_commit ${IMAGE} ${tag} ${digest}
#    local git_commit
#    git_commit="$(get_image_commit ${IMAGE} ${tag} ${digest})"
#    echo "git_commit:$git_commit"
  done
}

main
