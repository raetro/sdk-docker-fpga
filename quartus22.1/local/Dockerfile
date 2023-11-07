################################################################################
# SPDX-License-Identifier: MIT
# SPDX-FileType: SOURCE
# SPDX-FileCopyrightText: (c) 2022, Marcus Andrade
################################################################################

# Install Quartus on a separated layer of the Docker image to shrink the image size.
FROM raetro/quartus:base as install

# Change the working directory
WORKDIR /tmp

# Add Quartus installation files
ADD files/cyclone-22.1std.2.922.qdz                 .
ADD files/cyclone10lp-22.1std.2.922.qdz             .
ADD files/cyclonev-22.1std.2.922.qdz                .
ADD files/max10-22.1std.2.922.qdz                   .
ADD files/QuartusLiteSetup-22.1std.2.922-linux.run  .

# Fix file permissions
RUN chmod a+x QuartusLiteSetup-22.1std.2.922-linux.run                                                        && \
    ./QuartusLiteSetup-22.1std.2.922-linux.run --mode unattended --accept_eula 1 --installdir /opt/intelFPGA  && \
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
