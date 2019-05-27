#!/usr/bin/env bash

add_dockerfile() {
  echo "add_dockerfile(): begin"
  local versions=( "$(cat ./supported-tags.txt)" )

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
      echo "not sure what to do with $version/$java_variant re: base_image; skipping"
      continue
    fi

    local sub_variant="${variant#$java_variant-}"

    echo "version {
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
          echo "not sure what to do with $version/$sub_variant re: base_image; skipping"
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
  awk -v content="Hello, world 2" 'BEGIN { printf "%s", content }' > .travis.yml
#  awk -v travis="$travis" 'BEGIN { printf "%s", travis }'
#  awk 'BEGIN { printf "%s", travis }' .travis.yml
#  echo "$travis" > .travis.yml > .travis.yml
  echo "add_dockerfile(): end"
}

remove_dockerfile() {
  echo "remove_dockerfile(): begin"
  local supported_tags="$(cat ./supported-tags.txt)"

  for release_path in $(ls -d */); do
    if [[ ${supported_tags} = *"$release_path"* ]]; then
      echo "release[$release_path] found in supported tags"
      cd "$release_path"

      for variant_path in $(ls -d */); do
        local tag="$release_path${variant_path::-1}"

        if [[ ${supported_tags} = *"$tag"* ]]; then
          echo "variant[$tag] found in supported tags"
        else
          echo "Removing directory for variant[$tag]"
          rm -rf "$variant_path"
        fi
      done

      cd ..
    else
      echo "Removing directory for release[$release_path]"
      rm -rf "$release_path"
    fi
  done
}

main() {
  if [[ "$1" = 'debug' ]]; then
    exec 2>&1 # dump to console
  else
    exec 1> /dev/null 2>&1 # be quite
  fi

  add_dockerfile
#  remove_dockerfile
}

main "$@"
