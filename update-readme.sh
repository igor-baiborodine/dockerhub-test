#!/usr/bin/env bash

image='ibaiborodine/dockerhub-test'
tag='7.0.6-ga7-jdk8-slim'

main() {
#  local image=$1
#  local tag=$2
    local token=$(get_token $image)

    local digest=$(get_digest $image $tag $token)
    echo "digest:$digest"

    get_image_configuration $image $token $digest
}

get_image_configuration() {
  local image=$1
  local token=$2
  local digest=$3

  echo "Retrieving Image Configuration.
    IMAGE:  $image
    TOKEN:  $token
    DIGEST: $digest
  " >&2

  curl \
    --silent \
    --location \
    --header "Authorization: Bearer $token" \
    "https://registry-1.docker.io/v2/$image/blobs/$digest" \
    | jq -r '.container_config.Labels.git_commit'
}

get_digest() {
  local image=$1
  local tag=$2
  local token=$3

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



#tags="$(
#        curl -L -s 'https://registry.hub.docker.com/v2/repositories/ibaiborodine/dockerhub-test/tags?page_size=1024' \
#        | jq '.results|=sort_by(.name)|.results[].name' \
#        | sed '1!G;h;$!d'
#    )"
#echo "$tags"

main
