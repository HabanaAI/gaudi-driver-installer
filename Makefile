# Copyright (C) 2025 Intel Corporation.  All rights reserved.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the Lic

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Example usage:
# make build ARTIFACTORY_URL=http://your.artifactory.url HABANALABS_INSTALL_SCRIPT=install_script.sh
# make push IMAGE_NAME=your_image_name TAG=your_tag

# Default values for arguments
ARTIFACTORY_URL ?= artifactory-kfs.iil.labsad.intel.com
RELEASE_VERSION ?= master
RELEASE_BUILD_ID ?= no_release_build_id
BUILD_OS ?= generic
DOCKER_REPO ?= docker-local
# Add _ after the OS name to match the Docker image name.
# Needed for the driver daemonset.
# DriverBuildOs = $(shell echo $(BUILD_OS) | sed -E 's/([a-zA-Z]+)([0-9]+)/\1_\2/')
IMAGE_NAME ?= $(ARTIFACTORY_URL)/$(DOCKER_REPO)/$(RELEASE_VERSION)/$(BUILD_OS)/habanalabs/driver-installer
TAG ?= $(RELEASE_VERSION)-$(RELEASE_BUILD_ID)

INSTALL_SCRIPT ?= hl-generic-prod-local/$(RELEASE_VERSION)/$(RELEASE_BUILD_ID)/installer/habanalabs-installer.sh
SCRIPT_URL="https://${ARTIFACTORY_URL}/artifactory/${INSTALL_SCRIPT}"

# Makefile targets
.PHONY: build push test

docker-build-%: ## Build your project for a specific OS and architecture (e.g., build-linux-arm64)
	$(eval SUFFIX=$(word 1,$(subst production,,$*)))
	wget -Y off ${SCRIPT_URL} -O ./scripts/habanalabs-installer.sh
	docker build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VERSION="$(RELEASE_VERSION)-${RELEASE_BUILD_ID}" \
		--tag $(IMAGE_NAME):$(TAG)$(SUFFIX) \
		--file $(BUILD_OS)/Dockerfile \
		--target $* \
		.

build: docker-build-production docker-build-ubi9
	echo $(ARTIFACTORY_URL)
	echo $(HABANALABS_INSTALL_SCRIPT)

docker-push-%:
	$(eval SUFFIX=$(word 1,$(subst production,,$*)))
	docker push $(IMAGE_NAME):$(TAG)$(SUFFIX)

push: docker-push-production docker-push-ubi9

test:
	IMAGE=$(IMAGE_NAME):$(TAG) ./scripts/tests.sh
