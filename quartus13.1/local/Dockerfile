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
ADD files/cyclone_web-13.1.0.162.qdz     .
ADD files/cyclonev-13.1.0.162.qdz        .
ADD files/QuartusSetupWeb-13.1.0.162.run .
ADD files/QuartusSetup-13.1.4.182.run    .

# Install Quartus and remove uninstaller
RUN chmod a+x QuartusSetupWeb-13.1.0.162.run                                       && \
    chmod a+x QuartusSetup-13.1.4.182.run                                          && \
    ./QuartusSetupWeb-13.1.0.162.run --mode unattended --installdir /opt/intelFPGA && \
    ./QuartusSetup-13.1.4.182.run --mode unattended --installdir /opt/intelFPGA    && \
    rm -rf /opt/intelFPGA/uninstall/

################################################################################

# Create clean distribution image
FROM raetro/quartus:base

# Copy out Quartus instalation files to the image
COPY --from=install /opt/intelFPGA/ /opt/intelFPGA/

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
