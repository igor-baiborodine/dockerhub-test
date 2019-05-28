## update-dockerfile.sh

### Assumptions
- Max number of supported releases for each major version: 1
- Available variants for each supported release: alpine, slim
- Available LTS JDK versions for each variant: 8 (alpine/slim), 11 (slim)

### 1. No supported tags
*Expected*:
- no new release/variant directory created
- existing release/variant directories removed
- .travis.yml/env is empty

### 2. Add first release with one variant/JDK version
*Expected*:
- release/variant directory created
- release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding values in the newly created Dockerfile
- corresponding VERSION VARIANT added to .travis.yml/env

### 3. Add another variant/JDK version for an existing release
*Expected*:
- release/variant directory created
- release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding values in the newly created Dockerfile
- corresponding VERSION VARIANT added to .travis.yml/env
- existing VERSION VARIANT not removed in .travis.yml/env

### 4. Remove variant/JDK version for an existing release
*Expected*:
- release/variant directory removed
- corresponding VERSION VARIANT removed from .travis.yml/env

### 5. Remove an existing release, add a new release
*Expected*:
- old release directory removed
- old release corresponding VERSION VARIANT removed from .travis.yml/env
- new release/variant directory created
- new release/variant directory contains Dockerfile and docker-entrypoint.sh files
- placeholders replaced with corresponding new release values in the newly created Dockerfile
- new release corresponding VERSION VARIANT added to .travis.yml/env
