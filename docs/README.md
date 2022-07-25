# Intel Quartus Prime Synthesis Engine for Docker

![QuartusDocker](https://github.com/raetro/sdk-docker-fpga/blob/master/docs/assets/quartus-prime.png?raw=true)

## What is Quartus?

[Intel® Quartus® Prime] is programmable logic device design software for analysis and synthesis of HDL designs, enabling developers to compile their designs, perform timing analysis, examine RTL diagrams, simulate a design's reaction to different stimuli, and configure the target device with the programmer.

Quartus Prime includes an implementation of VHDL and Verilog for hardware description, visual editing of logic circuits, and vector waveform simulation.

## Quick reference

- Where to get help: [Rætro Discord] or [GitHub discussions].
- GitHub repo: [raetro/sdk-docker-fpga]
- Where to file issues: [https://github.com/raetro/sdk-docker-fpga/issues]

## What's in this image?

Quartus® Lite Edition for Intel's low-cost FPGA devices families.

These images are built from official installation files provided by Intel (specifically, [FPGA Software Download Center]).

## Supported tags, hardware and respective `Dockerfile` links
- Cyclone® II, III, IV
    - [`13.0`, `13.0sp1`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus13.0sp1) v13.0.1.232 (sp1)
- Cyclone® III, IV, V
    - [`13.1`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus13.1) v13.1.4.182
- Cyclone® IV, V, 10LP and MAX® 10
    - [`17.0`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus17.0) v17.0.2.602
    - [`17.1`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus17.1) v17.1.1.593
    - [`18.1`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus18.1) v18.1.1.646
    - [`19.1`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus19.1) v19.1.0.670
    - [`20.1`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus20.1) v20.1.0.711
    - [`21.1`, `21.1.1`](https://github.com/raetro/sdk-docker-fpga/tree/master/quartus21.1) v21.1.1.850

### Supported tag alias for specific FPGA projects

| Project               | Version | Alias        | Architecture  | Model           |
|-----------------------|---------|--------------|---------------|-----------------|
| MiMiC NSX             | `17.1`  | `mimic`      | Various       | Various         |
| MiST                  | `13.1`  | `mist`       | Cyclone III   | EP3C25E144C8    |
| MiSTer                | `17.0`  | `mister`     | Cyclone V SE  | 5CSEBA6U23I7    |
| Atlas                 | `17.1`  | `atlas`      | Cyclone 10 LP | 10CL025YU256C8G |
| MultiCore             | `13.1`  | `mc`         | Cyclone IV E  | EP4CE10E22C8    |
| MultiCore2            | `13.1`  | `mc2`        | Cyclone IV E  | EP4CE22F17C8    |
| MultiCore2 Plus       | `13.1`  | `mcp`        | Cyclone IV E  | EP4CE55F23C8    |
| NeptUNO               | `13.1`  | `neptuno`    | Cyclone IV E  | EP4CE55F23C8    |
| SiDi                  | `13.1`  | `sidi`       | Cyclone IV E  | EP4CE22F17C8    |
| Turbo Chameleon 64 v1 | `13.1`  | `tc64v1`     | Cyclone III   | EP3C25E144C8    |
| Turbo Chameleon 64 v2 | `18.1`  | `tc64v2`     | Cyclone 10 LP | 10CL025YU256C8G |
| Unamiga Reloaded      | `13.1`  | `uareloaded` | Cyclone IV E  | EP4CE55F23C8    |

> MiMiC Supported Boards: DE10-Nano, SoCKit, Deca, C10LP-RefKit, CYC1000, Chameleon96.

Usage: `docker run -it --rm raetro/quartus:<alias>`. E.g.: `docker run -it --rm raetro/quartus:mimic`

## How to use this image

The images are published on the [Docker Hub] as `raetro/quartus:<version>` and [GitHub Container Registry] as `ghcr.io/raetro/quartus:<version>`.

While the images works fine on desktops, the primary purpose is to be used in a continuous integration and continuous deployment (CI/CD) pipeline.

### GitHub actions workflow

#### Running compilation flow

```yml
name: Test Build

on:
  push:
    branches:
      - main
    paths-ignore:
      - '**.md'
  pull_request:
    branches:
      - main
    paths-ignore:
      - '**.md'

jobs:
  synthesis:
    runs-on: ubuntu-latest
    container: raetro/quartus:17.1
    steps:
      # 1 - Checkout repository
      - name: Checkout repository
        uses: actions/checkout@v2
      # 2 - RTL synthesis
      - name: Run compilation flow
        run: quartus_sh --flow compile my_project.qpf
      # 3 - Upload artifacts
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: OutputFiles.zip
          path: output_files/
```

For more examples and full workflow look inside the [examples] folder

### Desktop

#### Install the image

```bash
docker pull raetro/quartus:<version> #DockerHub
# or
docker pull ghcr.io/raetro/quartus:<version> #GitHub Packages
```

#### Run the image

```bash
docker run -it --rm -v /path/to/project:/build raetro/quartus:<version> #DockerHub
# or
docker run -it --rm -v /path/to/project:/build ghcr.io/raetro/quartus:<version> #GitHub Packages
```
> Docker will automatically download the image if it's not present locally

#### Run a complete compilation flow

Use the `quartus_sh` executable with the `--flow` option to perform a complete compilation flow with a single command.

##### Linux/Mac Terminal

```bash
docker run -it --rm -v $(pwd):/build raetro/quartus:17.1 quartus_sh --flow compile my_project.qpf
```

##### Windows

Windows Command Line (`cmd`)

```cmd
docker run -it --rm -v %cd%:/build raetro/quartus:17.1 quartus_sh --flow compile my_project.qpf
```

Windows PowerShell/WSL (Debian/Ubuntu)

```powershell
docker run -it --rm -v ${pwd}:/build raetro/quartus:17.1 quartus_sh --flow compile my_project.qpf
```

> WSL Users: Make sure to enable WSL Integration on Docker Desktop at `Settings > Resources > WSL Integration`

Where:

- `docker run` spins up the container from the image
- `-it` specifies that you want an interactive TTY
- `--rm` tells it to remove this temporary image when it exits
- `-v <cmd>` mounts a volume on the current directory and `:/build` within the container
- `raetro/quartus:17.1` is our Docker Image and
- `quartus_sh --flow compile my_project.qpf` perform a complete compilation flow.

Your project will be synthesized inside the container and exit when it finishes, the output files will be placed in the project directory.

> **Note**: The `--flow` option supports the smart recompile feature and efficiently sets command-line arguments for each executable in the flow.
> You can resume an interrupted compilation with the `-resume` argument of the `--flow` option.

##### Quick Pro Tip

Add an `alias` to your profile:

Mac: `nano ~/.bash_profile`
Linux: `nano ~/.bashrc` or `nano ~/.profile`

```bash
alias qdc='f(){ docker run -it --rm -v "$(pwd)":/build raetro/quartus:17.1 "$@"; unset -f f; }; f'
```

Windows PowerShell: `${Home}\Documents\WindowsPowerShell\Profile.ps1`

```powershell
Function _qdc { docker run -it --rm -v ${pwd}:/build raetro/quartus:17.1 @Args }
Set-Alias -Name qdc -Value _qdc
```

From now on you can simply type `qdc` to log into the container on the current folder,
or just `qdc quartus_sh --flow compile my_project.qpf` to compile your source code.

## Environment Variables

- `GITHUB_TOKEN`: The GitHub token to use with [GitHub CLI].
- `JTAG_SERVER`: JTAG Server `Name/IP address` (eg: host running jtagd/jtagserver).
- `JTAG_PASSWD`: JTAG Server `Password`.
- `LM_LICENSE_FILE`: Specifies the location of a license file. **Note:** Separate multiple license servers and node locking license files with ":"

### Using Docker CLI

```bash
docker run -it -rm \
    -e JTAG_SERVER=192.168.1.10 \
    -e JTAG_PASSWD=1234 \
    -e GITHUB_TOKEN=<GH_PAT> \
    -e LM_LICENSE_FILE=/opt/license.dat \
    -v /path/to/license.dat:/opt/license.dat:ro
    -v ${pwd}:/build \
    raetro/quartus:17.1
```

## Programming the FPGA

- [Download and Install Quartus Prime Programmer]
- [How to use the Quartus Programmer Tool]
- [Remote JTAG Server]

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/raetro/sdk-docker-fpga.git
cd sdk-docker-fpga
./build.sh -v17.1 -b
# or if you wanna change the base image
./build.sh -vbase -o
```

### build.sh

```bash
Quartus Prime Lite Container Builder.

Usage: build.sh [-v] [OPTION...]

  -v    Quartus version to build.
        [13.0, 13.1, 17.0, 17.1, 18.1, 19.1, 20.1, 21.1]

 Main modes of operation:
  -b    Build container using remote files.
  -p    Publish container to registry.
  -g    Publish container to GitHub registry.
  -d    Download files for local build.
  -l    Build container using local files.
  -c    Check local files integrity.
  -o    Build Base OS.

 eg. build.sh -v21.1 -b
     build.sh -vbase -o
```

#### Usage examples

```bash
./build.sh -v17.1 -b # Build container using remote files.
./build.sh -v17.1 -p # Publish container to registry.
./build.sh -v17.1 -g # Publish container to GitHub registry.
./build.sh -v17.1 -d # Download files for local build.
./build.sh -v17.1 -c # Check local files integrity.
./build.sh -v17.1 -l # Build container using local files.
./build.sh -vbase -o # Build Base OS container.
```

## Creating an Image Variant

The Quartus images come in many versions, each designed for a specific use case.

If you need to install any additional packages beyond what comes with the image, you can do so by expanding the container.

For example, if you need to install the `verilator` utility, you can do so by creating a new `Dockerfile` for your project.

```dockerfile
FROM raetro/quartus:17.1

RUN apt-get update                                         && \
    apt-get install -y --no-install-recommends verilator      \
    autoconf g++ flex bison ccache libgoogle-perftools-dev    \
    numactl perl-doc libfl-dev zlibc zlib1g zlib1g-dev     && \
    rm -rf /var/lib/apt/lists/* \

CMD [ "/bin/bash" ]
```

Then, run the commands to build and run the Docker image:

```bash
docker build -t quartus-verilator .
docker run -it --rm quartus-verilator
```

## What's in the Box

![What's in the Box](https://media.giphy.com/media/3otPoPkqjANWVH4SUE/giphy.gif)

- Base image: Debian Stretch (Slim)
- Installed Packages: [Container Manifest](https://github.com/raetro/sdk-docker-fpga/blob/master/docs/manifest.json)
- GitHub CLI: [2.14.2](https://github.com/cli/cli)
- CHANGELOG Generator: [0.15.1](https://github.com/git-chglog/git-chglog)

## Further Reading

- [Intel® FPGA Software Installation and Licensing Manual]

## Intel Legal Notice

Intel® Quartus® Prime Software - Copyright © Intel Corporation. All rights reserved.

Altera, Avalon, Cyclone, Intel, the Intel logo, MAX, Nios, Quartus are trademarks of Intel Corporation or its subsidiaries.

Your use of Intel Corporation's design tools, logic functions and other software and tools, and its AMPP partner logic functions,
and any output files from any of the foregoing (including device programming or simulation files), and any associated documentation or
information are expressly subject to the terms and conditions of the Intel Program License Subscription Agreement, the Intel Quartus
Prime License Agreement, the Intel FPGA IP License Agreement, or other applicable license agreement, including, without limitation,
that your use is for the sole purpose of programming logic devices manufactured by Intel and sold by Intel or its authorized distributors.
Please refer to the applicable agreement for further details.

### FPGA Software License Subscription Agreements

- [Intel® Quartus® Prime Design Software (includes Intel® FPGA IP) License Agreements]

## License

This work is licensed under multiple licenses.

* All original source code is licensed under [MIT-license] unless implicit indicated.
* All documentation is licensed under [Creative Commons Attribution Share Alike 4.0 International] Public License.
* Some configuration and data files are licensed under [Creative Commons Zero v1.0 Universal].

The Rætro authors and contributors or any of its maintainers are in no way associated with or endorsed by Intel® or any other company not implicit indicated.
All other brands or product names are the property of their respective holders.

As with all Docker images, these likely also contain other software which may be under other licenses
(such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image
complies with any relevant licenses for all software contained within.

[MIT-license]: https://spdx.org/licenses/MIT.html
[Creative Commons Attribution Share Alike 4.0 International]: https://spdx.org/licenses/CC-BY-SA-4.0.html
[Creative Commons Zero v1.0 Universal]: https://spdx.org/licenses/CC0-1.0.html

[FPGA Software Download Center]:https://www.intel.com/content/www/us/en/collections/products/fpga/software/downloads.html
[Intel® Quartus® Prime]: https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime.html
[Intel® Quartus® Prime Design Software (includes Intel® FPGA IP) License Agreements]: https://downloadmirror.intel.com/648211/qii_lic.zip
[Intel® FPGA Software Installation and Licensing Manual]: https://www.intel.com/content/www/us/en/docs/programmable/683472/22-2/introduction-to-fpga-software-installation.html
[GitHub CLI]: https://cli.github.com/

[Rætro Discord]: https://chat.raetro.org
[GitHub discussions]: https://github.com/raetro/sdk-docker-fpga/discussions
[raetro-sigs/sdk-docker-fpga]: https://github.com/raetro/sdk-docker-fpga
[https://github.com/raetro/sdk-docker-fpga/issues]: https://github.com/raetro/sdk-docker-fpga/issues

[Docker Hub]: https://hub.docker.com/r/raetro/quartus/tags/
[GitHub Container Registry]: https://github.com/orgs/raetro/packages/container/package/quartus
[examples]: https://github.com/raetro/sdk-docker-fpga/blob/master/examples
[Download and Install Quartus Prime Programmer]: https://github.com/raetro/sdk-docker-fpga/blob/master/docs/programmer-download-install.md
[How to use the Quartus Programmer Tool]: https://github.com/raetro/sdk-docker-fpga/blob/master/docs/programmer-tool.md
[Remote JTAG Server]: https://github.com/raetro/sdk-docker-fpga/blob/master/docs/programmer-remote-jtag.md
