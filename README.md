# Asus Vivobook X510UA-BQ490


![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## System specification

| Item | Details |
| - | - |
| Model | Asus Vivobook X510UA-BQ490 |
| CPU | Intel Core i5-8250U |
| Graphics | Intel UHD Graphics 620 |
| RAM | Samsung SODIMM DDR4 8GB x 2 *(upgraded)* |
| Wi-Fi / Bluetooth | BCM94360NG / BRCM20702 *(Replaced)* |
| Card Reader | Alcor Micro USB Card Reader connected via USB |
| Camera | ASUS UVC HD |
| Audio | Conexant Audio CX8050 |
| Touchpad | ELAN1200 |
| UEFI BIOS Utility | X510UAR-AS.310 |

## Not working

1. FN + media controller's key
2. The support for DRM contents is limited due to incompatible firmware. Please see the [DRM Compatibility Chart](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md).

## Attention please

1. Note that this fork is mostly for my laptop only (X510UA-BQ490). If yours has similar features such as no dGPU and no KB backlight, try, but at your own risk. Otherwise, please go to [hieplpvip's Zenbook repository](https://github.com/hieplpvip/Asus-Zenbook-Hackintosh) or [S510UA hackintosh repository](https://github.com/LeeBinder/Asus-Vivobook-S510UA-Hackintosh).
2. Please read the whole README before doing anything. [It's strange that some people ask me unrelated things and whatever things they want and they come at me when they're told they have asked useless things](https://github.com/whatnameisit/Asus-Vivobook-X510UA-BQ490-Hackintosh/issues/17).

## Steps to install

1. Read [Configuration.pdf](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf).
2. Read [Dortania guides](https://dortania.github.io/getting-started/).
3. Prepare USB drive with macOS installer mounted on it.
4. Replace EFI folder in USB EFI partition with the EFI folder in OpenCore EFI.
5. Boot into USB and select macOS installer and install.
6. Mount EFI and copy OpenCore EFI to the system EFI partition.
7. Replace the numbers in SMBIOS.
- Note: You may want to complete these extra steps.
    - You have Sleep and Airplane fn keys -- [Activate Sleep and Airplane fn keys](#activate-sleep-and-airplane-fn-keys)
    - You want to enable full power management -- [Unlock MSR 0xE2 (CFG Lock)](#unlock-msr-0xe2-cfg-lock)

## Activate Sleep and Airplane fn keys

1. Download [AsusSMC](https://github.com/hieplpvip/AsusSMC/releases).
2. Run install_daemon.sh by dragging it onto terminal.

## Unlock MSR 0xE2 (CFG Lock)

1. Follow [Dortania's guide](https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html).
- Note: You need to know which UEFI BIOS version matches your laptop model. Otherwise, there may be a permanent damage to your laptop. If you are unsure, use ControlMsrE2.efi bundled in OpenCore instead in which case you are still at your own risk.

## When you think you are done

1. Read Configuration.pdf and Dortania guides again to understand what you have.

## Acknowledgment

Apple for macOS

tctien342 and hieplpvip for Asus repositories

The VoodooI2C team for working touchpad

daliansky and williambj1 for many hotpatch methods

LeeBinder for many helps

fewtarius for new CPUFriendDataProvider.kext and SMBIOS

The Acidanthera team for OpenCore and many kexts

The Dortania team for OpenCore guides

## For Koreans
[README-kr](README-kr.md)를 참고하십시오.
