#!/usr/bin/env bash

main() {
  local supported_tag="$1"
  echo "supported_tag: $supported_tag"

  if [[ -d "$supported_tag" ]]; then
    echo "Already supported tag: $supported_tag"
    exit 1
  fi

  local version="$supported_tag"
  local release_version="${version%%/*}"
  local variant="$(basename "$version")"
  local java_variant="${variant%%-*}"

  if [[ "$java_variant" != jdk* ]]; then
    echo "Not supported Java variant: $java_variant"
    exit 1
  fi

  local sub_variant="${variant#$java_variant-}"

  if [[ ! (${sub_variant} == alpine || ${sub_variant} == slim) ]] ; then
    echo "Not supported sub-variant: $sub_variant"
    exit 1
  fi

  echo "Version {
    release_version: $release_version
    variant: $variant
    java_variant: $java_variant
    sub_variant: $sub_variant
  }"

  echo "Adding Dockerfile for $release_version/$variant"
  mkdir -p "$release_version/$variant"

  local base_image="openjdk:${java_variant:3}-${java_variant:0:3}${sub_variant:+-$sub_variant}" # ":8-jdk-alpine", ":11-jdk-slim"
  echo "base_image:$base_image"

  sed -r \
      -e 's/^(ENV APP_VERSION) .*/\1 '"$release_version"'/' \
      -e 's/^(FROM) .*/\1 '"$base_image"'/' \
      "Dockerfile${sub_variant:+-$sub_variant}.template" \
      > "$release_version/$variant/Dockerfile"

  cp -a docker-entrypoint.sh "$release_version/$variant/"

  local travis_env='\n  - '"VERSION=$release_version VARIANT=$variant"
  echo "travis_env: $travis_env"

  local travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travis_env"'" } { printf "%s%s", $0, RS }' .travis.yml)"
  echo "Modifying .travis.yml"
  echo "$travis" > .travis.yml

  if grep -q "$release_version" ./supported-tags; then
    echo "Found in supported-tags: release[$release_version]"
    echo "$supported_tag" >> ./supported-tags
  else
    echo "Not found in supported-tags: release[$release_version]"
    echo "$supported_tag" > ./supported-tags
    rm -rf "$release_version"
  fi

  git add .
  git commit -m "Add supported tag[$supported_tag]"
  git push

  echo "add_dockerfile(): end"
}

main "$@"
