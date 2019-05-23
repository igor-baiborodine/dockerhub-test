#!/usr/bin/env bash

IMAGE='ibaiborodine/dockerhub-test'
REPO_URL='https://github.com/igor-baiborodine/dockerhub-test'

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
  local image=$1
  local tag=$2
  local token=$3

  echo "Retrieving image digest.
    IMAGE:  $image
    TAG:    $tag
    TOKEN:  ${token:0:30}...
  " >&2

  curl \
      --silent \
      --header "Accept: application/vnd.docker.distribution.manifest.v2+json" \
      --header "Authorization: Bearer $token" \
      "https://registry-1.docker.io/v2/$image/manifests/$tag" \
    | jq -r '.config.digest'
}

get_image_git_commit() {
  local image=$1
  local token=$2
  local digest=$3

  echo "Retrieving image Git commit.
    IMAGE:  $image
    TOKEN:  ${token:0:30}...
    DIGEST: $digest
  " >&2

  curl \
      --silent \
      --location \
      --header "Authorization: Bearer $token" \
      "https://registry-1.docker.io/v2/$image/blobs/$digest" \
    | jq -r '.container_config.Labels.git_commit'
}

generate_dockerfile_links() {
  local tags="$1"
  local git_commit="$2"
  local supported_tags=""
  local tag='7.1.2-ga3-jdk8-slim'
#  for tag in ${tags}; do
    local release='7.1.2-ga3'
    local variant='jdk8-slim'
    supported_tags='-  [`'"${tag}"'` (*'"${release}/${variant}/Dockerfile"'*)]('"${REPO_URL}/blob/${git_commit}/${release}/${variant}/Dockerfile"$')\n'
#  done

  echo "$supported_tags"

#https://github.com/igor-baiborodine/dockerhub-test/blob/f21d22cb1ec3558411c577ed4b1dd17252c01e15/7.1.2-ga3/jdk8-slim/Dockerfile
#travisEnv='\n  - '"VERSION=$releaseVersion VARIANT=$variant$travisEnv"
#-	[`3.0.22`, `3.0` (*3.0/Dockerfile*)](https://github.com/tianon/docker-bash/blob/38a2a9828a6916afcb05663fd5db950afaf4c17d/3.0/Dockerfile)
#[`8.5.40-jre8-alpine`, `8.5-jre8-alpine`, `8-jre8-alpine`, `jre8-alpine`, `8.5.40-alpine`, `8.5-alpine`, `8-alpine`, `alpine` (*8.5/jre8-alpine/Dockerfile*)](https://github.com/docker-library/tomcat/blob/2d96f919237f0211d39409da5b2d0de7e3d8733b/8.5/jre8-alpine/Dockerfile)
#7.1.2-ga3-jdk8-slim


}

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
  local tags
  tags=( $(get_tags ${IMAGE}) )

#  local token
#  token=$(get_token ${IMAGE})
#
#  local digest
#  digest=$(get_digest ${IMAGE} ${tags[0]} ${token})
#
#  local git_commit
#  git_commit=$(get_image_git_commit ${IMAGE} ${token} ${digest})
  git_commit='f21d22cb1ec3558411c577ed4b1dd17252c01e15'
  echo "git_commit: ${git_commit}"

  local dockerfile_links
  dockerfile_links=$(generate_dockerfile_links ${tags} ${git_commit})

  cat ./template.md > ./README.md
  replace_field 'README.md' 'TAGS' "$dockerfile_links"
}

main
