## Use cases for executing update.sh

### Assumptions
- update.sh is executed on the master branch
- Max number of supported major versions: 1
- Max number of supported releases for each major version: 1
- Available variants for each supported release: alpine, slim
- Available LTS JDK versions for each variant: 8 (alpine/slim), 11 (slim)
- Max number of supported tags that can be added at a time to supported-tags: 1

### 1. Add first release with one variant/JDK version
*Expected*:
- release/variant directory created
- release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding values in the newly created Dockerfile
- corresponding VERSION VARIANT pair added to .travis.yml/env and supported-tags
- changes committed and pushed to remote
- Travis CI job triggered 
- new image built with VERSION-VARIANT tag and pushed to Docker HUB

### 2. Add another variant/JDK version for an existing release
*Expected*:
- release/variant directory created
- release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding values in the newly created Dockerfile
- corresponding VERSION VARIANT pair added to .travis.yml/env and supported-tags
- previous VERSION VARIANT pair removed from .travis.yml/env
- changes committed and pushed to remote
- Travis CI job triggered 
- new image built with VERSION-VARIANT tag and pushed to Docker HUB

### 3. Remove all variants for an existing release, add a new release with one variant/JDK version
*Expected*:
- old release directory removed
- new release/variant directory created
- new release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding new release values in the newly created Dockerfile
- all previous VERSION VARIANT pairs removed from .travis.yml/env and supported-tags
- corresponding VERSION VARIANT pair added to .travis.yml/env and supported-tags
- changes committed and pushed to remote
- Travis CI job triggered 
- new image built with VERSION-VARIANT tag and pushed to Docker HUB
