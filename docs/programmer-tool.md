# How to use the Quartus Programmer Tool

## Overview

This guide demonstrates how to program the FPGA by using the Quartus Programmer tool.

> Make sure it's [already installed for your system](programmer-download-install.md).

The instructions are for the Cyclone V SoC Development kit, but a similar flow can also be used for other boards.

> Note: Before re-programming the FPGA fabric, make sure that the FPGA2HPS bridges (f2sdram, axi) are disabled, and that there is no software on HPS that may access the FPGA.
> This includes shutting down applications that access soft IP and also unloading any soft IP Linux kernel modules.
> Failure to do so will cause the system to behave in a non-deterministic way and most likely it will crash.

## Prerequisites

## Steps

1. Start the Quartus Programmer Tool

![](assets/placeholder.png)

2. In Quartus Programmer, click the Hardware Setup button. This will open the Hardware Setup window.

![](assets/placeholder.png)

3. In the Hardware Setup window Select the USB Blaster device instance in the window that appears, by double-clicking it then click Close

![](assets/placeholder.png)

4. In Quartus Programmer, click the Autodetect button. This will open the Select Device window.

![](assets/placeholder.png)

5. Select the device and click OK to close the window.

![](assets/placeholder.png)

6. In Quartus Programmer select the line showing the FPGA device.

![](assets/placeholder.png)

7. Right-click the line with the FPGA device and select Change File from the menu.

![](assets/placeholder.png)

8. Browse to `/path/to/your/project/output_files/<project>.sof` and click Open

![](assets/placeholder.png)

9. Check the Program/Configure checkbox .

![](assets/placeholder.png)

10. Click the Start button. This will configure the FPGA.

![](assets/placeholder.png)

11. The top right corner will display the status of the operation.

![](assets/placeholder.png)
