## update-dockerfile.sh

### Assumptions
- update.sh is executed on the dev branch
- Max number of supported releases for each major version: 1
- Available variants for each supported release: alpine, slim
- Available LTS JDK versions for each variant: 8 (alpine/slim), 11 (slim)
- Max number of supported tags that can be added at a time to supported-tags.conf: 1

### 1. No supported tags
*Expected*:
- no new release/variant directory created
- existing release/variant directories removed
- .travis.yml/env is empty
- changes committed and pushed to remote
- Travis CI job triggered 
- no new image pushed to Docker HUB

### 2. Add first release with one variant/JDK version
*Expected*:
- release/variant directory created
- release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding values in the newly created Dockerfile
- corresponding VERSION VARIANT added to .travis.yml/env
- changes committed and pushed to remote
- Travis CI job triggered 
- new image built, tagged with VERSION-VARIANT and Git commit hash and pushed to Docker HUB

### 3. Add another variant/JDK version for an existing release
*Expected*:
- release/variant directory created
- release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding values in the newly created Dockerfile
- corresponding VERSION VARIANT added to .travis.yml/env
- previous VERSION VARIANT removed from .travis.yml/env
- changes committed and pushed to remote
- Travis CI job triggered 
- new image built, tagged with VERSION-VARIANT and Git commit hash and pushed to Docker HUB

### 4. Remove variant/JDK version for an existing release
*Expected*:
- release/variant directory removed
- corresponding VERSION VARIANT removed from .travis.yml/env
- changes committed and pushed to remote
- Travis CI job triggered 
- no new image pushed to Docker HUB

### 5. Remove all variant for an existing release, add a new release with one variant/JDK version
*Expected*:
- old release directory removed
- new release/variant directory created
- new release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding new release values in the newly created Dockerfile
- corresponding VERSION VARIANT added to .travis.yml/env
- previous VERSION VARIANT removed from .travis.yml/env
- changes committed and pushed to remote
- Travis CI job triggered 
- new image built, tagged with VERSION-VARIANT and Git commit hash and pushed to Docker HUB
