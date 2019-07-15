# Asus Vivobook X510UA-BQ490

This build running on MacOs X

![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## Detail

1. Version:    9-A
2. Date:       July 15, 2019
3. Support:    All BIOS
4. Changelogs: Removed many things
    - Touchpad now uses polling mode with SSDT-ELAN-Polling.aml with automatic activation of FMCN and SSCN with USTP=1 for proper clicks
    - Trimmed down SSDT-S510UA-KabyLakeR.aml and removed SSDT-RP01_PEGP for X510UA-BQ490 
    - Removed XHC AAPL injections as not required as of Sierra
    - Removed Sinetek-rtsx.kext as the SD Card Reader is connected via USB
    - Removed SSDT-UIA.aml and included USBPorts.kext and information for proper USB configuration and working BT after sleep
    - Removed BT4LEContinuityFixup.kext and FakePCIID.kext and the FakePCIID plugin as AirportBrcmFixup.kext is enough.
    - Separated the RMNE device
5. Status: Stable

## System specification

1. Name:           Asus Vivobook X510UA-BQ490
2. CPU:            Intel Core i5-8250U
3. Graphic:        Intel UHD620
4. Wifi:           Intel Dual Band Wireless-AC 8265 - with bluetooth // REPLACED WITH DW1560 (AirDrop and Handoff Working perfectly)
5. Card Reader:    Connected via USB
6. Camera:         ASUS UVC HD
7. Audio:          Conexant Audio CX8050
8. Touchpad:       ELAN1200
9. Bios Version:   301/303

## Thing will not able to use

1. FN + media controller's key

## Known problems

1.  Not on X510UA-BQ490

## VoodooI2C

1. Polling mode for smooth movements and gestures

## Attention please
Note that this fork is mostly for myself only (X510UA-BQ490). If you have similar features such as no dGPU and no KB backlight, try, but at your own risk. Otherwise, please go to tctien342's original master branch or hieplpvip's Zenbook repository.

## Step to install

1. Prepair an Mac installer in USB with Clover added (Use creationmedia method or MBR HFS Firmware Check Patch available in https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/ for both Mojave and Catalina)
2. Replace EFI folder in USB EFI partition with the INCLUDED CLOVER EFI FOLDER
3. Boot into USB and select MacOs installer
4. First boot Trackpad will not work, need and mouse connect through USB, Follow mac install instruction you can find it on tonymacx86 or other hackintosh forum
    - If you have chosen to install Catalina in HFS+ file system, follow the directions given in https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/. Updating kexts and Clover is necessary at the moment.
5. After install success, boot into MacOS, Copy Kext In /kexts/Other -> /Library/Extension
6. Use Kext Utility (or simply copy this line without the quotation marks: "sudo chmod -R 755 /L*/E*&&sudo chown -R 0:0 /L*/E*&&sudo kextcache -i /")to rebuild kext then reboot
7. This time trackpad and audio will working normally, then you need to use Clover EFI bootloader to install clover to EFI partition
8. After install success, using Clover Configurator to mount your USB EFI partition then copy it to your System EFI.
9. After System EFI replaced by your EFI, Using Clover Configurator to change SMBIOS, generate your serial and MBL, then you can use icloud now
Note: Deleting old and/or installing new kexts, changing the content of config.plist, configuring the USB mapping, or enabling Sleep and Airplane fn button may be required for the following reasons
        - You have DW1560 installed -- WIFI Replacement
        - You have DW1560 installed but Bluetooth fails upon wake from sleep -- Set Bluetooth port as internal
        - You have not replaced the WiFi & BT module with DW1560 but want to have working iMessage and FaceTime with USB WiFi dongle or USB LAN -- Install RehabMan Null Ethernet
        - You have Sleep and Airplane fn keys

## WIFI Replacement

1. Replace your card wifi with DW1560 (Or other if you can find better one, although I doubt there's one any better in terms of stability)
2. Change the bootflag so you can specify your region. The default is brcmfx-country=#a
3. Optional: Copy /kexts/other/additional/LiluFriend.kext (or create your own LiluFriend) to /L*/E* and rebuild cache
4. Reboot

## Set Bluetoth port as internal

1. Make sure USB injection kexts or SSDT-UIA.aml are not loaded
2. Download Hackintool by headkaze http://headsoft.com.au/download/mac/Hackintool.zip
3. Under the USB tab, identify the Bluetooth port and set it as internal. The UVC camera can also be set as internal. Export and obtain the codeless injection kext or SSDT-UIA.aml
4. Install the USBPorts.kext in /L*/E* (or USBInjectAll.kext and SSDT-UIA.aml if you want to have custom USB power configuration which will not be covered here. Refer to https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/ for more information)
5. Rebuild cache and reboot
Note: USBPorts.kext in /kexts/other/additional is specifically for my own X510UA-BQ490. Creating your own mapping is recommended to avoid shutdown/sleep errors.

## Install RehabMan Null Ethernet

1. Copy /kexts/other/additional/NullEthernet.kext to /L*/E* and rebuild cache
2. Copy /ACPI/patched/additional/SSDT-RMNE to /ACPI/patched
3. Reboot

## Sleep and Airplane fn keys
1. Follow the simple directions given in https://github.com/hieplpvip/AsusSMC/wiki/Installation-Instruction
    - Download hieplpvip's repo: https://github.com/hieplpvip/AsusSMC
    - Run AsusSMCDaemon/install_daemon.sh by dragging it onto terminal
    - Reboot if the script does not seem to work

## When you think you are done
 
1. Backup your /L*/E* by copying them to the system EFI partition and/or USB EFI partition

## Problems with the polling mode in other laptops
1. Enabling FMCN and SSCN and their automatic assignment fixed the issues with the macOS recognizing a single click input as multiple clicks in my X510UA-BQ490. X510UA-BQ492 experiences the same issue when the laptop runs on battery even after implementing the fix. Custom FMCN and SSCN configuration may be required. Refer to https://github.com/hieplpvip/ASUS-ZENBOOK-HACKINTOSH/blob/master/src/hotpatch/SSDT-I2CBUS.dsl and ask for help at the VoodooI2C helpdesk

## Other things
1. OpenCore
    - Seems to have shutdown issues
    - Injecting CodecCommander.kext via the supposedly-better-at-injection bootloader does not seem to allow sound input
    - mostly my lack of skills and knowledge

## Credits

Apple, tctien342, hieplpvip, the VoodooI2C helpdesk, headkaze, and RehabMan
