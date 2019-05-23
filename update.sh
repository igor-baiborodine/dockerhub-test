#!/usr/bin/env bash
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [[ ${#versions[@]} -eq 0 ]]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

travisEnv=
for version in "${versions[@]}"; do
    releaseVersion="${version%%/*}"
    echo "releaseVersion:$releaseVersion"

    variant="$(basename "$version")"
    echo "variant:$variant"

    javaVariant="${variant%%-*}"
    echo "javaVariant:$javaVariant"

    if [[ "$javaVariant" != jdk* ]]; then
        echo >&2 "not sure what to do with $version/$javaVariant re: baseImage; skipping"
        continue
    fi

    subVariant="${variant#$javaVariant-}"
    echo "subVariant:$subVariant"

    case "$subVariant" in
        alpine|slim)
            baseImage="openjdk:${javaVariant:3}-${javaVariant:0:3}${subVariant:+-$subVariant}" # ":8-jdk-alpine", ":11-jdk-slim"
            echo "baseImage:$baseImage"
            ;;
        *)
            echo >&2 "not sure what to do with $version/$subVariant re: baseImage; skipping"
            continue
            ;;
    esac

    sed -r \
        -e 's/^(ENV APP_VERSION) .*/\1 '"$releaseVersion"'/' \
        -e 's/^(FROM) .*/\1 '"$baseImage"'/' \
        "Dockerfile${subVariant:+-$subVariant}.template" \
        > "$releaseVersion/$variant/Dockerfile"

    cp -a docker-entrypoint.sh "$releaseVersion/$variant/"

    travisEnv='\n  - '"VERSION=$releaseVersion VARIANT=$variant$travisEnv"
done

travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
