# Remote FPGA JTAG programming

## Overview

The Remote JTAG Server is part of the Quartus Programmer tools.

It is easy to program a local device in the Quartus with USB Blaster.
In the case of remote network access, it is possible to run jtagd and jtagconfig on a different server and client machine and accomplish programming via SSH tunnel on the network. In practice, this is a simple, cheap alternative to Ethernet Blaster.

In this example the Altera USB Blaster programmer is connected to the SRV host, and the Quartus II development environment runs on the CLNT machine. Both nodes run Linux operating system.

## Prerequisites

- The FPGA connected to the host computer via a USB cable.
- [Quartus Programmer Tool](programmer-download-install.md) installed.
- Network connection to the Server host (LAN/VLAN).

## Steps

1. Run the Quartus Programmer

![](assets/placeholder.png)

2. Select menu Edit > Hardware Setup...

![](assets/placeholder.png)

3. In the Hardware Setup dialogue, click the JTAG Settings tab

![](assets/placeholder.png)

4. Click the button Configure Local JTAG Server

![](assets/placeholder.png)

5. Make sure Enable Remote Clients to Connect to Local JTAG Server is checked

![](assets/placeholder.png)

6. Enter and confirm a password, and click OK

![](assets/placeholder.png)

7. Close down the dialogue boxes

![](assets/placeholder.png)


### Local Machine and Docker

```
 ----------------------------------------------------------
| FPGA <<== USB ==>> Host <<== Virtual Network ==>> Docker | 
 ----------------------------------------------------------
```

### Over the Network

```
 ------------------------------                     --------------------
| FPGA <<== USB ==>>> SRV host | <<== Network ==>> | CLNT host: Quartus |
 ------------------------------                     --------------------
```

```bash
user@HOST:~$ docker run -it --rm raetro/quartus:17.1
root@95fe49e3c0ec:/build$ jtagconfig
No JTAG hardware available
root@95fe49e3c0ec:/build$ jtagconfig --addserver 192.168.1.19 1234
root@95fe49e3c0ec:/build$ jtagconfig
1) DE-SoC on 192.168.1.19 [USB-1]
  4BA00477   SOCVHPS
  02D020DD   5CSEBA6(.|ES)/5CSEMA6/..
```
