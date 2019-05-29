## update-image.sh

### Assumptions
- update-image.sh is executed in dev branch if the corresponding Travis CI build job is completed with success
- Images for not supported tags are not removed from Docker Hub
- Images for new supported tags are built and published to Docker Hub
- Existing images for supported tags can be rebuilt to update the base image and published to Docker Hub
- Git commit hash should be provided for building and publishing new images
- If no Git commit hash provided, images will be rebuilt to update the base image

### 1. Update base image for all supported tags
*Expected*: 
- All images for supported tags are rebuilt to update the base image and published to Docker Hub
- Supported tags section in README.md file is not updated

### 2. Add a new variant/JDK version to an existing release
*Expected*:
- Based on the newly added Dockerfile file, new image is built and published to Docker Hub
- Supported tags section in README.md file is updated with the new supported tag info
- GitHub link to the Dockerfile file is generated based on the provided Git commit hash 

### 3. Add another variant/JDK version for an existing release
*Expected*:
- Based on the newly added Dockerfile file, new image is built and published to Docker Hub
- Supported tags section in README.md file is updated with the new supported tag info
- GitHub link to the Dockerfile file is generated based on the provided Git commit hash 

### 4. Remove variant/JDK version for an existing release
*Expected*:
- update-image.sh should not be executed

### 5. Remove an existing release, add a new release with multiple variants
*Expected*:
- Based on the newly added Dockerfile files, new images are built and published to Docker Hub
- Supported tags section in README.md file is updated with the new supported tags info
- GitHub links to the Dockerfile files are generated based on the provided Git commit hash 
