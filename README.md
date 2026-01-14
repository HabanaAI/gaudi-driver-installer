# Intro
Builds driver installer images for Intel Gaudi Base Kubernetes operator.


## Building examples:
```bash
docker build \
			--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
			--build-arg VERSION="${RELEASE_VERSION}-${RELEASE_BUILD_ID}" \
			--build-arg SCRIPT_URL="https://vault.habana.ai/artifactory/gaudi-installer/${RELEASE_VERSION}/habanalabs-installer.sh" \
			--tag "docker.io/intel/gaudi-driver-installer:${RELEASE_VERSION}-${RELEASE_BUILD_ID}" \
			--file generic/Dockerfile \
			.
```
