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
ARTIFACTORY_URL ?= artifactory-kfs.habana-labs.com
RELEASE_VERSION ?= master
RELEASE_BUILD_ID ?= no_release_build_id
BUILD_OS ?= generic
DOCKER_REPO ?= docker-local
# Add _ after the OS name to match the Docker image name.
# Needed for the driver daemonset.
# DriverBuildOs = $(shell echo $(BUILD_OS) | sed -E 's/([a-zA-Z]+)([0-9]+)/\1_\2/')
IMAGE_NAME ?= $(ARTIFACTORY_URL)/$(DOCKER_REPO)/$(RELEASE_VERSION)/$(BUILD_OS)/habanalabs/driver-installer
TAG ?= $(RELEASE_VERSION)-$(RELEASE_BUILD_ID)

HABANALABS_INSTALL_SCRIPT = hl-generic-prod-local/$(RELEASE_VERSION)/$(RELEASE_BUILD_ID)/installer/habanalabs-installer.sh

# Makefile targets
.PHONY: build push test

build:
ifneq ($(BUILD_OS),generic)
	echo $(ARTIFACTORY_URL)
	echo $(HABANALABS_INSTALL_SCRIPT)
	docker build \
		--build-arg ARTIFACTORY_URL=$(ARTIFACTORY_URL) \
		--build-arg HABANALABS_INSTALL_SCRIPT=$(HABANALABS_INSTALL_SCRIPT) \
		-t $(IMAGE_NAME):$(TAG) \
		-f $(BUILD_OS)/Dockerfile \
		.
else
	docker build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VERSION="$(RELEASE_VERSION)-${RELEASE_BUILD_ID}" \
		--build-arg SCRIPT_URL="https://${ARTIFACTORY_URL}/artifactory/${HABANALABS_INSTALL_SCRIPT}" \
		--tag $(IMAGE_NAME):$(TAG) \
		--file $(BUILD_OS)/Dockerfile \
		.
endif

push:
	docker push $(IMAGE_NAME):$(TAG)

test:
	IMAGE=$(IMAGE_NAME):$(TAG) ./scripts/tests.sh
