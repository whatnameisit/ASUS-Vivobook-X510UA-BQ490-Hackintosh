# Asus Vivobook X510UA-BQ490

Tested on 10.14.4-10.14.6 (Clover) and 10.15 Beta 2 (OpenCore) 

![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## Details

1. Version:    9-A
2. Date:       July 15, 2019
3. Support:    All BIOS
4. Changelogs: Removed many things
    - Touchpad now uses polling mode with SSDT-ELAN-Polling.aml with automatic activation of FMCN and SSCN with USTP=1 for proper clicks
    - Trimmed down SSDT-S510UA-KabyLakeR.aml and removed SSDT-RP01_PEGP for X510UA-BQ490 
    - Removed XHC AAPL properties as not required as of Sierra
    - Removed Sinetek-rtsx.kext as the SD Card Reader is connected via USB
    - Removed SSDT-UIA.aml and included USBPorts.kext and information for proper USB configuration and working BT after sleep
    - Removed BT4LEContinuityFixup.kext and FakePCIID.kext and the FakePCIID plugin as AirportBrcmFixup, BrcmFirmwareRepo, and BrcmPatchRAM2 are enough.
    - Separated the RMNE device
5. Status: Stable

## System specification

1. Name:           Asus Vivobook X510UA-BQ490
2. CPU:            Intel Core i5-8250U
3. Graphic:        Intel UHD Graphics 620 // Dual monitor with HDMI (con2) and 2048 MB VRAM
4. Wifi:           Intel Dual Band Wireless-AC 8265 - with bluetooth // REPLACED WITH DW1560 (AirDrop and Handoff Working perfectly)
5. Card Reader:    Connected via USB
6. Camera:         ASUS UVC HD
7. Audio:          Conexant Audio CX8050
8. Touchpad:       ELAN1200
9. Bios Version:   309

## Thing will not able to use

1. FN + media controller's key

## Known problems

1.  Not on X510UA-BQ490

## VoodooI2C

1. Polling mode for smooth movements and gestures

## Attention please
1. Note that this fork is mostly for myself only (X510UA-BQ490). If you have similar features such as no dGPU and no KB backlight, try, but at your own risk. Otherwise, please go to tctien342's original master branch or hieplpvip's Zenbook repository.
2. If the versions of your VirtualSMC and corresponding efi driver and plugins do not match, touchpad and other battery issues might arise. Please make sure to download the most recent stable release of the SMC package and install them accordingly.

## Steps to install

1. Prepair an Mac installer in USB (Use creationmedia method or MBR HFS Firmware Check Patch available in https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/ for both Mojave and Catalina)
2. Replace EFI folder in USB EFI partition with the EFI folder in Clover EFI
3. Disable VT-d in BIOS and boot into USB and select MacOs installer
4. During the installation process, touchpad will not work. You need a mouse connected through USB. Follow mac install instruction you can find it on tonymacx86 or other hackintosh forums
    - If you have chosen to install Catalina in HFS+ file system, follow the directions given in https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/. Updating Bluetooth kexts for DW1560 is necessary. Download is available at https://github.com/headkaze/OS-X-BrcmPatchRAM/releases and take a moment to read https://www.insanelymac.com/forum/topic/339175-brcmpatchram2-for-1015-catalina-broadcom-bluetooth-firmware-upload/
5. After a successful installation, boot into macOS, copy kexts In /kexts/Other -> /Library/Extension
6. Use Kext Utility (or simply copy this line without the quotation marks: "sudo chmod -R 755 /L*/E*&&sudo chown -R 0:0 /L*/E*&&sudo kextcache -i /") to rebuild kext then reboot
7. This time, touchpad and audio should function correctly. Then you need to mount EFI and copy Clover EFI to the system EFI partition in like what you have done on USB EFI partition
8. After System EFI replaced by your EFI, use Clover Configurator to change SMBIOS, generate your serial and MBL
- Note: installing kexts and SSDT in /additional, changing the content of config.plist, configuring the USB mapping, or enabling Sleep and Airplane fn button may be required for the following reasons:
    - You have DW1560 installed -- WIFI Replacement
    - You have DW1560 installed but Bluetooth fails upon wake from sleep -- Set Bluetooth port as internal
    - You have not replaced the WiFi & BT module with DW1560 but want to have working iMessage and FaceTime with USB WiFi dongle or USB LAN -- Install RehabMan Null Ethernet
    - You have Sleep and Airplane fn keys

## WIFI Replacement

1. Replace your card wifi with DW1560 (Or other if you can find better one, although I doubt there's one any better in terms of stability. If you like adventures, try DW1820A and follow the guides in OSXLatitude: 1. https://osxlatitude.com/forums/topic/11322-broadcom-bcm4350-cards-under-high-sierramojave/ 2. https://osxlatitude.com/forums/topic/11540-dw1820a-for-7490-help/ pages 3 to 5)
2. Change the bootflag so you can specify your region. The default is brcmfx-country=#a
3. Optional: Copy /kexts/other/additional/LiluFriend.kext (or create your own LiluFriend) to /L*/E* and rebuild cache
4. Reboot

## Set Bluetooth port as internal

1. Make sure USB injection kexts or SSDT-UIA.aml are not loaded
2. Download Hackintool by headkaze http://headsoft.com.au/download/mac/Hackintool.zip
3. Under the USB tab, identify the Bluetooth port and set it as internal. The UVC camera can also be set as internal. Export and obtain the codeless injection kext or SSDT-UIA.aml
4. Install the USBPorts.kext in /L*/E* (or USBInjectAll.kext and SSDT-UIA.aml if you want to have custom USB power configuration which will not be covered here. Refer to https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/ for more information)
5. Rebuild cache and reboot
- Note: USBPorts.kext in /kexts/other/additional is specifically for my own X510UA-BQ490. Creating your own mapping is recommended to avoid shutdown/sleep errors.

## Install RehabMan Null Ethernet

1. Copy /kexts/other/additional/NullEthernet.kext to /L*/E* and rebuild cache
2. Copy /ACPI/additional/SSDT-RMNE to /ACPI/patched
3. Reboot
- Note: For iMessage, FaceTime, and App Store to function correctly with RMNE, I recommend you install RMNE before trying to connect to any USB networking devices. Otherwise, you need to reset the network mapping by having RMNE set to en0. Use Google.

## Sleep and Airplane fn keys
1. Follow the simple directions given in https://github.com/hieplpvip/AsusSMC/wiki/Installation-Instruction
    - Download Release of AsusSMC: https://github.com/hieplpvip/AsusSMC/releases
    - Run install_daemon.sh by dragging it onto terminal
    - Reboot if the script does not seem to work

## When you think you are done
 
1. Update Clover, kexts, and efi files.
2. Backup your /L*/E* by copying them to the system EFI partition and/or installation USB EFI partition

## Other things
1. OpenCore (10.15 Beta 2)
    - Load BT kexts and CC from /L*/E*
    - No more shutdown panics
    - For 10.14 or prior, BT kexts are to be replaced with RehabMan's version for stable functionality

## Credits

Apple for macOS

tctien342 and hieplpvip for Asus repositories

the VoodooI2C helpdesk for working touchpad

headkaze for Hackintool

RehabMan for Null Ethernet and many other things

CrazyBird for HFS+ partitioning in 10.14+

## For Koreans
[README-kr](README-kr.md)를 참고하십시오.
