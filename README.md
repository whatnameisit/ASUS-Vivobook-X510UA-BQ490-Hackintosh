# Asus Vivobook X510UA-BQ490


![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## System specification

| Laptop | Asus Vivobook X510UA-BQ490 |
| - | - |
| CPU | Intel Core i5-8250U |
| Graphics | Intel UHD Graphics 620 |
| Wi-Fi / Bluetooth | *BCM94352Z (replaced)* |
| Card Reader | Alcor Micro USB Card Reader connected via USB |
| Camera | ASUS UVC HD |
| Audio | Conexant Audio CX8050 |
| Touchpad | ELAN1200 |
| UEFI BIOS Version | 309 |

## Not Working

1. FN + media controller's key
2. The support for DRM contents is limited due to incompatible firmware. Please see the [DRM Compatibility Chart](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md).

## VoodooI2C

1. Polling mode for smooth movements and gestures

## Attention please
1. Note that this fork is mostly for my laptop only (X510UA-BQ490). If yours has similar features such as no dGPU and no KB backlight, try, but at your own risk. Otherwise, please go to hieplpvip's Zenbook repository.
2. Please read the whole README before doing anything. [It's strange that some people ask me unrelated things and whatever things they want and they come at me when they're told they have asked useless things](https://github.com/whatnameisit/Asus-Vivobook-X510UA-BQ490-Catalina-10.15.6-Hackintosh/issues/17).

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

1. Download Release of [AsusSMC](https://github.com/hieplpvip/AsusSMC/releases).
2. Run install_daemon.sh by dragging it onto terminal.
- Note: Reboot if the script does not seem to work. After updating your EFI folder or any kexts, you may need to rerun the script.

## Unlock MSR 0xE2 (CFG Lock)

- Note: You need to know which BIOS version matches your laptop model. Otherwise, there may be a permanent damage to your laptop.
1. Follow [Dortania's guide](https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html).
2. The offset will be at 0x527 if your BIOS version is 309.

## When you think you are done

1. Read Configuration.pdf and Dortania guides again to understand what you have.
    
## Changelog
November 27, 2020
- Deprecated Clover.

August 4, 2020
- Updated kexts and OpenCore to Acidanthera's August Release.

July 27, 2020
- Delete CodecCommander and use AppleALC layout-id of 13 for working mic and HDMI sound.

June 2, 2020
- Updated OpenCore to 0.5.9.

May 9, 2020
- Reverted _PTS patch as it is a workaround to correctly shutdown without restarting which is no longer needed.
- Switched from VoodooTSCSync.kext to CpuTscSync.kext to fix rare kernel panic on wake.

April 24, 2020
- Added back _PTS part in ACPI to avoid "Device not ejected properly" message on wake.

April 12, 2020
- Updated OpenCore to r0.5.7 and VoodooI2C to r2.4.

March 23, 2020
- Use Finger ID-implemented VoodooInput and VoodooI2C for persistent touchpad gestures.

March 4, 2020
- Updated OpenCore to 0.5.6.

February 3, 2020
- Updated OpenCore to 0.5.4.

January 27, 2020 
- Updated kexts and Clover.
- AppleALC.kext stays on 1.4.2. Built AsusSMC.kext 1.2.0 with 10.15.2 and latest Lilu and VirtualSMC SDKs.
- Added NoTouchID.kext and other SMC sensor kexts.
- Deleted .efi files specific to FileVault. If needed, they can be obtained from the Release.

December 28, 2019
- Reverted back to AppleALC 1.4.2 with the layout-id 03000000, reinstalled CodecCommander and the corresponding SSDT: SSDT-CC.aml
- Reinstall USBPorts.kext to comply with ACPI specifications.

December 26, 2019
- Deleted USB configuration as not needed for working bluetooth on wake from sleep in 10.15.2: deleted USBPorts.kext.
- Changed SMBIOS to MacBookPro15,4 and added NoTouchID.kext.
- Switched CPUFriendDataProvider.kext to a new one: BPOWER-CPUFriendDataProvider.kext.

December 16, 2019
- Set the default touchpad patch to be SSDT-I2C1_USTP.aml.

December 15, 2019
- Updated AppleALC to 1.4.4 and deleted CodecCommander and the corresponding patches.

October 28, 2019
- Added a simplified and minimum patch of the touchpad code in ACPI: SSDT-I2Cx_USTP.dsl.

October 26, 2019
- Update bluetooth kexts: BrcmPatchRAM2, BrcmPatchRAM3, BrcmFirmwareData, BrcmFirmwareRepo, BrcmBluetoothInjector.kext.

October 6, 2019
- Added the general touchpad polling mode patch that corresponds to the laptops in hieplpvip's repo: config-touchpad_general.plist, SSDT-ELAN-General.aml

October 4, 2019
- Separated fake EC device from main SSDT: SSDT-EC.aml.

September 28, 2019
- Deleted some entries in /config.plist/ACPI/DSDT/Fixes and added an SSDT to make the laptop behave more like MBP14,1: FixMutex, FixIPIC, FixHPET, SSDT-HPET.aml.

September 27, 2019
- Added back MATH and LDR2 devices: SSDT-MATHLDR2_STA.aml.

September 26, 2019
- Added another XOSI replacement patch: SSDT-OSYS.dsl.
- Added the steps to write your own touchpad SSDT.

September 13, 2019
- Option to replace XOSI patch by invoking If _OSI Darwin with SSDT-_OSI-XINI.dsl.
- Delete SSDT-PS2.aml and add SSDT-PS2.dsl with comments.

Prior to September 13, 2019
- Touchpad now uses polling mode with SSDT-X510UA-Touchpad.aml with assignment of FMCN and SSCN with activation from USTP=1 for proper clicks.
- Trimmed down SSDT-S510UA-KabyLakeR.aml and removed SSDT-RP01_PEGP for X510UA-BQ490.
- Removed XHC AAPL properties as not required as of Sierra.
- Removed Sinetek-rtsx.kext as the SD Card Reader is connected via USB.
- Removed SSDT-UIA.aml and included USBPorts.kext and information for proper USB configuration and working BT after sleep.
- Removed BT4LEContinuityFixup.kext and FakePCIID.kext and the FakePCIID plugin as AirportBrcmFixup, BrcmBluetoothInjector, BrcmFirmwareRepo, and BrcmPatchRAM2 are enough.
- Separated the RMNE device.
- Moved IGPU and HDEF contents from ACPI to config.plist.
- Made F5 and F6 keys do nothing with SSDT-PS2.aml as they are associated with keyboard backlight which X510UA-BQ490 does not have.

## Credits

Apple for macOS

tctien342 and hieplpvip for Asus repositories

The VoodooI2C helpdesk for working touchpad

daliansky and williambj1 for many hotpatch methods

LeeBinder for many helps

fewtarius for new CPUFriendDataProvider.kext and SMBIOS

The Acidanthera team for OpenCore and many kexts

The Dortania team for OpenCore guides

## For Koreans
[README-kr](README-kr.md)를 참고하십시오.
