#!/usr/bin/env bash

add_dockerfile() {
  local versions=( "$1" )
  if [[ ${#versions[@]} -eq 0 ]]; then
    versions=( */ )
  fi
  versions=( "${versions[@]%/}" )

  local travis_env=

  for version in "${versions[@]}"; do
    local release_version="${version%%/*}"
    local variant="$(basename "$version")"
    local java_variant="${variant%%-*}"

    if [[ "$java_variant" != jdk* ]]; then
      echo >&2 "not sure what to do with $version/$java_variant re: base_image; skipping"
      continue
    fi

    local sub_variant="${variant#$java_variant-}"

    echo "Version {
      release_version: $release_version
      variant: $variant
      java_variant: $java_variant
      sub_variant: $sub_variant
    }"

    if [[ ! -d "$release_version/$variant" ]]; then
      echo "Adding Dockerfile for $release_version/$variant ..."
      mkdir -p "$release_version/$variant"

      local base_image=
      case "$sub_variant" in
        alpine|slim)
          base_image="openjdk:${java_variant:3}-${java_variant:0:3}${sub_variant:+-$sub_variant}" # ":8-jdk-alpine", ":11-jdk-slim"
          echo "base_image:$base_image"
          ;;
        *)
          echo >&2 "not sure what to do with $version/$sub_variant re: base_image; skipping"
          continue
          ;;
      esac

      sed -r \
          -e 's/^(ENV APP_VERSION) .*/\1 '"$release_version"'/' \
          -e 's/^(FROM) .*/\1 '"$base_image"'/' \
          "Dockerfile${sub_variant:+-$sub_variant}.template" \
          > "$release_version/$variant/Dockerfile"

      cp -a docker-entrypoint.sh "$release_version/$variant/"
    fi

    travis_env='\n  - '"VERSION=$release_version VARIANT=$variant$travis_env"
  done

  local travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travis_env"'" } { printf "%s%s", $0, RS }' .travis.yml)"
  echo "$travis" > .travis.yml
}

remove_dockerfile() {
  echo "Removing dockerfile files..."
# ls -d */ | tr -d '/'
}

main() {
  add_dockerfile "$1"
  remove_dockerfile
}

main "$@"
