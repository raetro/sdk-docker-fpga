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
ADD ${INTEL_CDN}/17.0std/595/ib_installers/cyclone-17.0.0.595.qdz                .
ADD ${INTEL_CDN}/17.0std/595/ib_installers/cyclone10lp-17.0.0.595.qdz            .
ADD ${INTEL_CDN}/17.0std/595/ib_installers/cyclonev-17.0.0.595.qdz               .
ADD ${INTEL_CDN}/17.0std/595/ib_installers/max10-17.0.0.595.qdz                  .
ADD ${INTEL_CDN}/17.0std/595/ib_installers/QuartusLiteSetup-17.0.0.595-linux.run .
ADD ${INTEL_CDN}/17.0std.2/602/update/QuartusSetup-17.0.2.602-linux.run          .

# Fix file permissions
RUN chmod a+x QuartusLiteSetup-17.0.0.595-linux.run                                        && \
    chmod a+x QuartusSetup-17.0.2.602-linux.run                                            && \
    ./QuartusLiteSetup-17.0.0.595-linux.run --mode unattended --installdir /opt/intelFPGA  && \
    rm -rf /opt/intelFPGA/uninstall/

################################################################################

# Create clean distribution image
FROM raetro/quartus:base

# Copy out Quartus instalation files to the image
COPY --from=install /opt/intelFPGA/ /opt/intelFPGA/

# Load the library from the host system.
ENV LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4:/usr/lib/x86_64-linux-gnu/libstdc++.so.6

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
