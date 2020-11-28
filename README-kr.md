# Asus Vivobook X510UA-BQ490


![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## System specification

| Laptop | Asus Vivobook X510UA-Bq490 |
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

1. hieplpvip의 FN + media 컨트롤 키에 해당하는 패치가 이 노트북에는 적용되지 않습니다.
2. IMEI 펌웨어가 macOS와 호환되지 않는 부분이 있어 DRM 콘텐츠 지원이 미비합니다. [DRM Compatibility Chart](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md).

## VoodooI2C

1. 부드러운 움직임과 제스쳐를 위해 Polling mode를 사용합니다.

## Attention please
1. 이 fork는 X510UA-BQ490에 최적화되도록 구성했습니다. 만약 본인의 노트북에 옵티머스 외장그래픽이 없고 키보드 백라이트가 없다면 사용할 수 있지만, 책임은 본인에게 있습니다. 부담이 되거나 외장그래픽 기능을 제어해야 한다면 hieplpvip의 Zenbook repository를 참고하시길 바랍니다.
2. 이 README를 꼭 숙지하고 진행하시기 바랍니다. [여기서 제공되는 것과 상관 없는 내용 및 아무 조치 없이 아무 말이나 한다면 무시됩니다](https://github.com/whatnameisit/Asus-Vivobook-X510UA-BQ490-Catalina-10.15.6-Hackintosh/issues/10#issuecomment-622947888).

## Steps to install

1. [Configuration.pdf](https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf)를 정독합니다.
2. [Dortania guides](https://dortania.github.io/getting-started/)를 정독합니다.
3. macOS 인스톨러 USB를 준비합니다.
4. USB의 EFI 파티션에 OpenCore EFI의 하위폴더 EFI를 붙여넣으습니다.
5. USB로 부팅해서 macOS Installer를 선택한 후 설치합니다.
6. SSD의 EFI 파티션을 마운트한 후 OpenCore EFI의 하위폴더를 SSD의 EFI 하위폴더로 붙여넣습니다.
8. SMBIOS의 시리얼 숫자들을 새로 생성하십시오.
- Note: 경우에 따라서 별도 패치가 필요할 수 있습니다.
    - 잠자기와 비행기모드 fn 버튼이 있을 때 -- [Activate Sleep and Airplane fn keys](#activate-sleep-and-airplane-fn-keys)
    - 전력관리를 최대 활성화하고자 하는 경우 -- [Unlock MSR 0xE2 (CFG Lock)](#unlock-msr-0xe2-cfg-lock)
    
## Activate Sleep and Airplane fn keys

1. [AsusSMC](https://github.com/hieplpvip/AsusSMC/releases)를 다운로드합니다.
2. install_daemon.sh를 터미널로 드래그해서 실행시키십시오.
- Note: 곧바로 작동하지 않는다면 재부팅하십시오. 켁스트와 efi 드라이버, OS, 클로버 등을 업데이트 할 때 새로 실행해야 할 수 있습니다.

## Unlock MSR 0xE2 (CFG Lock)
- Note: 자신의 노트북의 바이오스 버전을 확실히 알아야 합니다. 버전이 다르다면 노트북에 이상이 생길 수 있습니다.
1. [Dortania 가이드](https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html)를 참고하십시오.
2. BIOS 버전이 309이라면 설정해주어야 할 Offset은 0x527에 해당합니다.

## When you think you are done
 
 1. 클로버, 켁스트, 그리고 efi 파일을 최근 버전으로 업데이트 하십시오. 이 때 VoodooPS2Controller.kext의 VoodooInput.kext를 삭제하십시오.
2. /L*/E*의 내용을 SSD의 EFI 파티션과 설치 USB EFI 파티션에 복사하십시오.

## Other things

1. OpenCore
    - 윈도우는 KMS 라이센스 사용시 정상작동합니다. 또는 `CustomSMBIOSGuid`를 `True`, `UpdateSmbiosMode`를 `Custom`으로 설정할 수도 있습니다.
    - BlessOverride 개별 설정이 필요합니다.
    - bootpicker와 boot chime 파일을 https://github.com/acidanthera/OcBinaryData 에서 다운로드 할 수 있습니다.
    - OpenCore는 Configuration.pdf를 참조하지 않고서는 설치하는 것을 권장하지 않기 때문에 가이드는 별도로 제공하지 않습니다.
2. Clover
    - 키보드 Fn 조합 (터치패드 활성화/비활성화 버튼) 이 작동하지 않는 경우 CC를 제외한 켁스트를 전부 Clover에서 로드하십시오. 단, Clover에서 로드하는 경우 BrcmFirmwareRepo 대신 BrcmFirmwareData를 사용해야 블루투스가 안정적입니다.
    - 켁스트를 업데이트 한 경우 VoodooPS2Controller.kext/Contents/Plugins 폴더 안의 VoodooInput.kext를 삭제해야 합니다. VoodooI2C.kext/Contents/Plugins/VoodooInput.kext로 VoodooI2C에 필요한 MT2 emulation이 이미 적용됩니다. 또한 VoodooPS2Trackpad.kext와 VoodooPS2Mouse.kext도 삭제할 것을 권장합니다.

## Changelog
November 28, 2020
- Clover를 더이상 지원하지 않습니다.

Aug 4, 2020
- 켁스트와 OpenCore를 Acidanthera August Release로 업데이트 했습니다.

July 27, 2020
- CodecCommander를 삭제하고 AppleALC layout-id를 13으로 설정합니다. 마이크와 HDMI 소리도 잘 작동합니다.

June 2, 2020
- OpenCore를 0.5.9로 업데이트 했습니다.

May 9, 2020
- _PTS 패치는 종료시 재부팅되는 것을 방지하는 것이고 해당사항이 없기 때문에 다시 지웠습니다.
- 간헐적 커널 패닉이 일어나는 VoodooTSCSync.kext로부터 패닉이 없는 CpuTscSync.kext로 변경했습니다.

April 24, 2020
- 잠자기에서 깨울 때 "Device not ejected properly" 메시지가 표기되지 않도록 _PTS 관련 ACPI 패치를 다시 추가했습니다.

April 12, 2020
- OpenCore를 r0.5.7로, VoodooI2C를 r2.4로 업데이트 했습니다.

March 23, 2020
- 터치패드 제스쳐의 안정적인 사용을 위해 Finger ID가 포함된 VoodooInput과 VoodooI2C를 사용합니다.

March 4, 2020
- OpenCore를 0.5.6으로 업데이트 했습니다.

February 3, 2020
- OpenCore를 0.5.4로 업데이트 했습니다.

January 27, 2020 
- 켁스트, 클로버 등을 업데이트 했습니다.
- AppleALC.kext는 1.4.2로 동일하고, AsusSMC.kext는 1.2.0을 직접 빌드했습니다.
- NoTouchID.kext와 SMC 센서 켁스트를 전부 추가했습니다.
- FileVault를 사용하지 않는 관계로 필요 없는 .efi를 전부 삭제했습니다. 필요하다면 Release에서 다운로드 받을 수 있습니다.

December 28, 2019
- AppleALC를 1.4.2로 되돌리고, layout-id를 03000000로, CodecCommander를 다시 설치, 그리고 CodecCommander 데이터 SSDT를 다시 추가했습니다: SSDT-CC.aml.
- ACPI 스펙에 맞추어 USBPorts.kext를 다시 추가했습니다.

December 26, 2019
- 10.15.2 이후로는 USB 포트 설정 없이도 잠자기 이후 블루투스가 정상 작동합니다: USBPorts.kext 삭제.
- SMBIOS를 MacBookPro15,4로 설정하고 NoTouchID.kext를 추가했습니다.
- CPUFriendDataProvider.kext를 교체했습니다: BPOWER-CPUFriendDataProvider.kext.

December 16, 2019
- 기본 터치패드 패치를 SSDT-I2C1_USTP.aml로 설정했습니다.

December 15, 2019
- AppleALC 1.4.4 업데이트로 CodecCommander와 해당 패치를 삭제했습니다.

October 28, 2019
- 최대한 적은 패치로 터치패드를 활성화할 수 있는 SSDT를 추가했습니다: SSDT-I2Cx_USTP.dsl.

October 26, 2019
- 블루투스 켁스트 업데이트: BrcmPatchRAM2, BrcmPatchRAM3, BrcmFirmwareData, BrcmFirmwareRepo, BrcmBluetoothInjector.kext.

October 6, 2019
- 대부분 Vivobook/Zenbook에서 작동하는 터치패드 코드를 추가했습니다: config-touchpad_general.plist, SSDT-ELAN-General.aml.

October 4, 2019
- 메인 SSDT로부터 EC 장치를 분리했습니다: SSDT-EC.aml.

September 28, 2019
- MBP14,1 DSDT에 알맞게 DSDT Fixes중 일부를 삭제하고 SSDT를 추가했습니다: FixMutex, FixIPIC, FixHPET, SSDT-HPET.aml.

September 27, 2019
- 기존에 삭제했던 MATH와 LDR2 장치를 추가했습니다: SSDT-MATHLDR2_STA.aml.

September 26, 2019
- XOSI 대응 패치를 추가했습니다: SSDT-OSYS.dsl.
- 터치패드 코드 작성법을 추가했습니다.

September 13, 2019
- XOSI 패치 대신 별도 방법으로 구현한 _OSI Darwin 패치를 사용할 수 있습니다 (SSDT-_OSI-XINI.dsl).
- SSDT-PS2.aml을 삭제하고 설명을 넣은 SSDT-PS2.dsl을 추가했습니다.

Prior to September 13, 2019
- 매끄럽고 정확한 클릭을 위해 VoodooI2C 작동모드를 Interrupts에서(SSDT-ELAN.aml) Polling으로(SSDT-X510UA-Touchpad.aml) 바꾸었습니다.
- 옵티머스 기능이 없기 때문에 기존 SSDT-S510UA-KabyLakeR.aml의 해당 내용을 삭제하고, SSDT-RP01_PEGP.aml를 삭제했습니다. 
- 시에라 이후에는 USB 전력 관리에 AAPL properties가 사용되지 않기 때문에 삭제했습니다.
- SD 카드 리더기가 USB로 연결되어 있기 때문에 Sinetek-rtsx.kext를 삭제했습니다.
- USBInjectAll.kext와 정확하지 않은 SSDT-UIA.aml를 삭제하고 BQ490 기준으로 패치된 USBPorts.kext와 패치내용을 추가했습니다.
- AirportBrcmFixup.kext, BrcmBluetoothInjector, BrcmFirmwareRepo, 그리고 BrcmPatchRAM2만으로 와이파이와 블루투스 및 Handoff 기능이 충분하기 때문에 BT4LEContinuityFixup.kext, FakePCIID.kext, 그리고 FakePCIID 플러그인 켁스트를 삭제했습니다.
- RMNE 장치를 기존 SSDT-S510UA-KabyLakeR.aml에서부터 분리했습니다.
- IGPU 및 HDEF 내용을 ACPI에서 config.plist로 옮겼습니다.
- 키보드 백라이트가 없는 기종이기 때문에 F5와 F6로 백라이트 문양이 나타나는 것을 SSDT-PS2.aml로 기능을 제거했습니다.

## Credits

Apple for macOS

tctien342 and hieplpvip for Asus repositories

The VoodooI2C helpdesk for working touchpad

daliansky and williambj1 for many hotpatch methods

LeeBinder for many helps

fewtarius for new CPUFriendDataProvider.kext and SMBIOS

The Acidanthera team for OpenCore and many kexts

The Dortania team for OpenCore guides

## [hackintosh.co.kr](http://hackintosh.co.kr)
이 한국 커뮤니티에 방문하시면 기타 정보를 얻으실 수 있습니다.
