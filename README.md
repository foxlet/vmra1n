Checkra1n on KVM + QEMU
=======================

You will need:
- Board with support for AMD-V or VT-x, as well as iommu (VT-d)
- Linux distro with QEMU 3.x or higher

You do not need any additional hardware, unless you don't have USB 2.0 ports or separate on-board controllers.

## Enable BIOS Features
Boot into your firmware settings, and turn on AMD-V/VT-x, as well as iommu/AMD-Vi/VT-d/SR-IOV.

## Get Some Information
Run `./lsiommu.sh` (included in this repo), if successful, you'll get list of PCIe devices and their groups. If there is no output, double check BIOS settings. As an example:
```
IOMMU Group 14 03:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] 300 Series Chipset USB 3.1 xHCI Controller [1022:43bb] (rev 02)
IOMMU Group 14 03:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] 300 Series Chipset SATA Controller [1022:43b7] (rev 02)
IOMMU Group 18 27:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Zeppelin USB 3.0 Host controller [1022:145f]
```
Look for an USB controller on its own group, note the BDF ID (`27:00.3` in this example) and the PCI ID (`1022:145f` in this example)

## Isolate the Controller
Edit `rebind.sh` and change the values for PID and BDF with your own, then save it and run it as `sudo ./rebind.sh`. This will turn off a group of USB ports, so relocate any input devices to other ports as needed. As an example of the format:
```
BIND_PID1="1022 145f"
BIND_BDF1="0000:27:00.3"
```

## Install macOS
Follow https://github.com/foxlet/macOS-Simple-KVM up to step 2. Once installation is finished, shut down the VM.

## Attach USB Controller
Add the following to the end of `basic.sh`, replace `host=XX:XX.X` with the BDF ID from earlier.

```
    -device pcie-root-port,bus=pcie.0,multifunction=on,port=1,chassis=1,id=port.1 \
    -device vfio-pci,host=XX:XX.X,bus=port.1 \
```

## Run Checkra1n
Start `./basic.sh`. If everything went correctly, you should be able to connect an iPhone to the assigned ports and run the exploit.
