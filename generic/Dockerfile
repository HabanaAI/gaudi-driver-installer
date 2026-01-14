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

FROM busybox:1.37.0
ARG BUILD_DATE=""
ARG SCRIPT_URL=""
ARG VERSION=""

COPY ./scripts/manage_network_ifs.sh /etc/manage_network_ifs.sh
COPY ./LICENSE /licenses/LICENSE
RUN wget -Y off ${SCRIPT_URL} -O /usr/bin/habanalabs-installer.sh \
    && chmod +x /usr/bin/habanalabs-installer.sh

LABEL org.opencontainers.image.vendor="Intel Corp."
LABEL org.opencontainers.image.title="Intel Gaudi Driver Installer for Kubernetes"
LABEL org.opencontainers.image.description="Intel Gaudi Driver Installer automates driver installation on node."
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.source=https://github.com/HabanaAI/gaudi-driver-installer
LABEL org.opencontainers.image.licenses="Apache-2.0"
