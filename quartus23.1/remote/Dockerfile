################################################################################
# SPDX-License-Identifier: MIT
# SPDX-FileType: SOURCE
# SPDX-FileCopyrightText: (c) 2022, Marcus Andrade
################################################################################

# Install Quartus on a separated layer of the Docker image to shrink the image size.
FROM raetro/quartus:base as install

# Change the working directory
WORKDIR /tmp

# Intel CDN URL
ARG INTEL_CDN="https://downloads.intel.com/akdlm/software/acdsinst"

# Add Quartus installation files
ADD ${INTEL_CDN}/23.1std/991/ib_installers/cyclone-23.1std.0.991.qdz                .
ADD ${INTEL_CDN}/23.1std/991/ib_installers/cyclone10lp-23.1std.0.991.qdz            .
ADD ${INTEL_CDN}/23.1std/991/ib_installers/cyclonev-23.1std.0.991.qdz               .
ADD ${INTEL_CDN}/23.1std/991/ib_installers/cyclonev-23.1std.0.991.qdz
ADD ${INTEL_CDN}/23.1std/991/ib_installers/max10-23.1std.0.991.qdz                  .
ADD ${INTEL_CDN}/23.1std/991/ib_installers/QuartusLiteSetup-23.1std.0.991-linux.run .

# Fix file permissions
RUN chmod a+x QuartusLiteSetup-23.1std.0.991-linux.run                                                        && \
    ./QuartusLiteSetup-23.1std.0.991-linux.run --mode unattended --accept_eula 1 --installdir /opt/intelFPGA  && \
    rm -rf /opt/intelFPGA/uninstall/

################################################################################

# Create clean distribution image
FROM raetro/quartus:base

# Copy out Quartus instalation files to the image
COPY --from=install /opt/intelFPGA/ /opt/intelFPGA/

# Load the library from the host system.
ENV LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4

# Metadata Params
ARG BUILD_DATE
ARG BUILD_VERSION

# Metadata
LABEL \
    org.opencontainers.image.vendor="Raetro.org"                                     \
    org.opencontainers.image.title="raetro/quartus"                                  \
    org.opencontainers.image.description="Intel Quartus Prime Synthesis Engine"      \
    org.opencontainers.image.authors="sigs+fpga@raetro.org"                          \
    org.opencontainers.image.url="https://github.com/raetro/sdk-docker-fpga"         \
    org.opencontainers.image.source="https://github.com/raetro/sdk-docker-fpga.git"  \
    org.opencontainers.image.created=$BUILD_DATE                                     \
    org.opencontainers.image.version=$BUILD_VERSION
