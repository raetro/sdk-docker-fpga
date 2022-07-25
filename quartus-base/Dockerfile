################################################################################
# SPDX-License-Identifier: MIT
# SPDX-FileType: SOURCE
# SPDX-FileCopyrightText: (c) 2022, Marcus Andrade
################################################################################

FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive

# Bash Settings
RUN { \
		echo "export HISTTIMEFORMAT='%d/%m/%y %T '";                                                    \
		echo "export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;33m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\]\$ '"; \
		echo "alias l='ls -CF'";                                                                        \
		echo "alias la='ls -A'";                                                                        \
		echo "alias ll='ls -lah'";                                                                      \
		echo "alias ls='ls -F --color=auto'";                                                           \
		echo "alias lt='ls --human-readable --size -1 -S --classify'";                                  \
		echo "alias count='find . -type f | wc -l'";                                                    \
		echo "alias cpv='rsync -ah --info=progress2'";                                                  \
		echo "alias update='apt-get -y update && apt-get -y upgrade'";                                  \
		echo "alias meminfo='free -m -l -t'";                                                           \
		echo "alias psmem='ps auxf | sort -nr -k 4'";                                                   \
		echo "alias wget='wget -c'";                                                                    \
		echo "alias gsmu='git submodule update --init --recursive'";                                    \
		echo "alias gfc='quartus_sh --flow compile'";                                                   \
	} | tee -a ~/.bashrc

# Quartus JTAG entrypoint
RUN { \
		echo '#!/bin/sh -e';                                             \
		echo '';                                                         \
		echo 'if [ -n "$GITHUB_TOKEN" ] ; then';                         \
		echo '    gh auth setup-git';                                    \
		echo 'fi';                                                       \
		echo '';                                                         \
		echo 'if [ -n "$JTAG_SERVER" -a -n "$JTAG_PASSWD" ] ; then';     \
		echo '    jtagconfig --addserver "$JTAG_SERVER" "$JTAG_PASSWD"'; \
		echo 'fi';                                                       \
		echo '';                                                         \
		echo 'exec "$@"';                                                \
		echo '';                                                         \
	} | tee /usr/bin/quartus-entrypoint && chmod a+x /usr/bin/quartus-entrypoint

# Add i386 to enable the installation of multiarch binaries (x86-32)
RUN dpkg --add-architecture i386

# Update the image OS
RUN apt-get update                          && \
    apt-get upgrade -y                      && \
    apt-get install -y --no-install-recommends \
                       bc                      \
                       ca-certificates         \
                       curl                    \
                       expect                  \
                       file                    \
                       git                     \
                       iputils-ping            \
                       jq                      \
                       less                    \
                       lib32ncurses5-dev       \
                       lib32z1                 \
                       libc6:i386              \
                       libfontconfig1          \
                       libglib2.0-0            \
                       liblzma-dev             \
                       libncurses5:i386        \
                       libqt5xml5              \
                       libsm6                  \
                       libsm6:i386             \
                       libssl-dev              \
                       libstdc++6:i386         \
                       libtcmalloc-minimal4    \
                       libxext6:i386           \
                       libxft2:i386            \
                       libxrender1             \
                       libzmq3-dev             \
                       locales                 \
                       make                    \
                       nano                    \
                       net-tools               \
                       openjdk-8-jdk           \
                       pkg-config              \
                       python3-pip             \
                       rsync                   \
                       sed                     \
                       squashfs-tools          \
                       sudo                    \
                       tar                     \
                       tcl                     \
                       tree                    \
                       udev                    \
                       unixodbc-dev            \
                       unzip                   \
                       usbutils                \
                       wget                    \
                       xauth                   \
                       xvfb                    \
                       xz-utils             && \
    rm -r /var/lib/apt/lists/*

# Set System Locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Change the working directory
WORKDIR /tmp

# Copy libpng, Github CLI and Changelog generator
ARG GH_VERSION="2.14.2"
ARG CHGLOG_VERSION="0.15.1"
ADD libs/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb .
ADD libs/libpng12-0_1.2.54-1ubuntu1.1_i386.deb .
ADD https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.deb .
ADD https://github.com/git-chglog/git-chglog/releases/download/v${CHGLOG_VERSION}/git-chglog_${CHGLOG_VERSION}_linux_amd64.tar.gz .

# Install libpng, Github CLI and Changelog generator
RUN dpkg -i libpng12-0_1.2.54-1ubuntu1.1_amd64.deb \
            libpng12-0_1.2.54-1ubuntu1.1_i386.deb  \
            gh_${GH_VERSION}_linux_amd64.deb

RUN tar -zxf git-chglog_${CHGLOG_VERSION}_linux_amd64.tar.gz && \
    chmod a+x git-chglog                                     && \
    mv git-chglog /usr/bin/git-chglog                        && \
    rm -rf  /tmp/*

# Set main Quartus variables
ENV QUARTUS_PATH=/opt/intelFPGA

# Set Quartus environment variables
ENV QUARTUS_ROOTDIR=${QUARTUS_PATH}/quartus
ENV SOPC_KIT_NIOS2=${QUARTUS_PATH}/nios2eds
ENV PATH=${QUARTUS_ROOTDIR}/bin/:${QUARTUS_ROOTDIR}/linux64/gnu/:${QUARTUS_ROOTDIR}/sopc_builder/bin/:$PATH
ENV PATH=${SOPC_KIT_NIOS2}/:${SOPC_KIT_NIOS2}/bin/:${SOPC_KIT_NIOS2}/bin/gnu/H-x86_64-pc-linux-gnu/bin/:${SOPC_KIT_NIOS2}/sdk2/bin/:$PATH

# Where we will store our data
VOLUME /build

# Quartus uses the current working directory
WORKDIR /build

# Expose default JTAG server port
EXPOSE 1309/tcp
EXPOSE 1309/udp

# Metadata Params
ARG BUILD_DATE
ARG BUILD_VERSION

# Metadata
LABEL \
    org.opencontainers.image.vendor="Raetro.org"                                      \
    org.opencontainers.image.title="raetro/quartus"                                   \
    org.opencontainers.image.description="Base OS for Quartus Prime Synthesis Engine" \
    org.opencontainers.image.authors="sigs+fpga@raetro.org"                           \
    org.opencontainers.image.url="https://github.com/raetro/sdk-docker-fpga"          \
    org.opencontainers.image.source="https://github.com/raetro/sdk-docker-fpga.git"   \
    org.opencontainers.image.created=$BUILD_DATE                                      \
    org.opencontainers.image.version=$BUILD_VERSION

ENTRYPOINT ["quartus-entrypoint"]

CMD ["/bin/bash"]
