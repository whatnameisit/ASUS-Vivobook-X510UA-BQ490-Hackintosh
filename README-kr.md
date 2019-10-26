# Asus Vivobook X510UA-BQ490

Tested on 10.14.4-10.15 (Clover) and 10.15 Beta 2 (OpenCore) 

![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## System specification

1. Name:           Asus Vivobook X510UA-BQ490
2. CPU:            Intel Core i5-8250U
3. Graphic:        Intel UHD Graphics 620 // HDMI 연결하면 작동합니다 (Index 2). VRAM을 2048 MB로 할당했습니다.
4. Wifi:           Intel Dual Band Wireless-AC 8265 - with bluetooth // DW1560로 교체 (AirDrop and Handoff 완벽히 작동합니다.)
5. Card Reader:    USB로 연결
6. Camera:         ASUS UVC HD
7. Audio:          Conexant Audio CX8050
8. Touchpad:       ELAN1200
9. Bios Version:   309

## Thing will not able to use

1. hieplpvip의 FN + media 컨트롤 키에 해당하는 패치가 이 노트북에는 적용되지 않습니다.

## Known problems

1.  X510UA-BQ490에는 문제점이 없습니다.

## VoodooI2C

1. 부드러운 움직임과 제스쳐를 위해 Polling mode를 사용합니다.

## Attention please
1. 이 fork는 X510UA-BQ490에 최적화되도록 구성했습니다. 만약 본인의 노트북에 옵티머스 외장그래픽이 없고 키보드 백라이트가 없다면 사용할 수 있지만, 책임은 본인에게 있습니다. 부담이 되거나 외장그래픽 기능을 제어해야 한다면 tctien342의 기존 master branch나 hieplpvip의 Zenbook repository를 참고하시길 바랍니다.
2. VirtualSMC와 플러그인 및 efi 파일의 버전이 서로 일치하지 않으면 터치패드나 기타 전원에 오류가 발생할 수 있습니다. 가장 최근에 나온 안정적인 SMC 패키지를 다운로드하고 알맞게 설치하십시오.
3. X510UA-BQ490이 아니라면 터치패드가 작동하지 않을 수 있습니다. 아래 Configure your own touchpad code 섹션에 개별 터치패드를 활성화하는 방법이 있습니다. 터치패드가 작동하더라도 자신에게 알맞는 코드를 작성하는 것을 추천합니다.

## Steps to install

1. macOS 인스톨러 USB를 준비합니다. (creationmedia 방법이나 Mojave와 Catalina를 HFS+ 파일시스템에 설치하고 싶다면 MBR HFS Firmware Check Patch를 사용하십시오. https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/) 기존 맥 시스템이 없다면 가상머신을 이용하실 수 있습니다. 또는 [hackintosh.co.kr](http://hackintosh.co.kr)에서 고스트를 다운로드 받아 설치하시면 편리합니다.
2. USB의 EFI 파티션에 Clover EFI의 하위폴더 EFI를 붙여넣으십시오.
3. USB로 부팅해서 macOS Installer를 선택하십시오.
4. 설치중에는 터치패드가 작동하지 않을 수 있습니다. 이 경우 별도의 마우스가 필요합니다. tonymacx86이나 다른 해킨토시 커뮤니티를 참고해서 설치를 마무리하십시오. 한글을 원하시면 [hackintosh.co.kr](http://hackintosh.co.kr)를 이용하십시오.
    - 만약 Catalina를 HFS+ 파일시스템으로 설치하신다면 https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/의 설치방법을 참고하십시오.
5. 설치가 완료된 후에 macOS로 부팅해서 /kexts/Other의 켁스트를 -> /Library/Extension로 붙여넣으십시오.
6. Kext Utility를  이용해서 (또는 큰따옴표를 제외한 다음의 명령어를 터미널에 붙여넣습니다: "sudo chmod -R 755 /L*/E*&&sudo chown -R 0:0 /L*/E*&&sudo kextcache -i /") 캐시를 재생성하고 재부팅하십시오.
7. 터치패드와 소리가 (마이크) 정상작동합니다. SSD의 EFI 파티션을 활성화시키고 (sudo diskutil mount EFI) Clover EFI의 하위폴더를 SSD의 EFI 하위폴더로 붙여넣습니다.
8. EFI 폴더를 설치한 후 Clover Configurator를 이용해서 MacBookPro14,1의 SMBIOS 내용을 생성하십시오.
- Note: 경우에 따라서 별도 패치가 필요할 수 있습니다.
    - X510UA-BQ490이 아닌 경우 -- Configure your own touchpad code
    - DW1560를 설치한 경우 -- Replace WiFi/Bluetooth card
    - DW1560설치 이후 잠자기에서 깨어난 상태에서 블루투스가 작동하지 않을 때 -- Set Bluetooth port as internal
    - WiFi & BT 모듈을 DW1560로 교체하지 않았지만 USB WiFi 동글이나 USB LAN를 통해 iMessage와 FaceTime를 활성화시킬 때 -- Install RehabMan's Null Ethernet
    - 잠자기와 비행기모드 fn 버튼이 있을 때 -- Activate Sleep and Airplane fn keys
    - 백라이트 버튼 기능을 제거할 경우 -- Remap PS2
    - XOSI 대신 다른 패치를 사용할 경우 -- Replace XOSI patch

## Configure your own touchpad code

1. MaciASL을 실행하여 Clover로 추출한 DSDT.aml 코드를 확인하십시오.
2. \_SB.PCI0.I2C1.ETPD 장치 내용을 복사하여 SSDT-X510UA-Touchpad.aml ETXX의 해당하는 부분에 대치하십시오. *주의* 이 때 `Method (_STA)`와 `Method (_CRS)`는 바꾸지 않습니다.
3. 패치한 SSDT를 본인 모델명으로 변경하십시오.
4. 재부팅합니다.
- 패치한 SSDT를 공유하면 다른 ASUS 노트북 사용자에게 도움이 됩니다. SSDT와 노트북 모델명을 첨부해주시기 바랍니다.
- 패치가 어렵다면 Issues에 ticket을 작성하거나, touchpad 폴더의 패치를 사용하십시오.

## Replace WiFi/Bluetooth card

1. DW1560 카드를 설치하십시오.
2. 지역이 한국인 경우 bootflag가 brcmfx-country=#a인 것을 확인하십시오.
3. /kexts/other/additional에 있는 AirportBrcmFixup를 /L*/E*로 복사하십시오.
4. 모하비의 경우 두 개의 블루투스 Brcm kext들 (Repo, RAM2), 카탈리나의 경우 세 개를 (Repo, Injector, RAM3) /L*/E*로 복사하고 캐시를 재생성하십시오.
5. 권장사항: /kexts/other/additional/LiluFriend.kext를 (새롭게 LiluFriend를 생성하는 것이 안정적입니다.) /L*/E*에 붙여넣고 캐시를 재생성하십시오.
6. 재부팅합니다.

## Set Bluetooth port as internal

1. /L*/E*의 3rd party USB 관련 켁스트나 SSDT-UIA.aml가 로드되지 않은 것을 확인하십시오.
2. headkaze의 Hackintool를 다운로드 하십시오: http://headsoft.com.au/download/mac/Hackintool.zip.
3. USB 탭에서 블루투스 포트를 확인하고 internal로 설정하십시오. UVC 카메라 또한 internal로 설정할 수 있습니다. Export/내보내기 버튼으로 codeless injection kext과 SSDT들을 데스크톱에 생성하고, 생성된 SSDT들은 삭제하십시오.
4. USBPorts.kext를 /L*/E*에 설치하십시오. (자세한 내용은 https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/ 에서 확인하실 수 있습니다.)
5. 캐시를 재생성하고 재부팅합니다.
- Note: kexts/other/additional의 USBPorts.kext는 제 X510UA-BQ490에 해당하는 켁스트입니다. 종료나 잠자기 시 오류를 방지하기 위해 본인의 USB 매핑을 설정하는 것을 추천합니다.

## Install RehabMan's Null Ethernet

1. /kexts/other/additional/NullEthernet.kext를 /L*/E*에 설치하고 캐시를 재생성하십시오.
2. /ACPI/additional/SSDT-RMNE를 /ACPI/patched로 복사하십시오.
3. 재부팅합니다.
- Note: 안정적인 iMessage, FaceTime, 그리고 App Store를 사용하기 위해서는 Null Ethernet를 먼저 설치한 후 기타 USB 동글이나 LAN을 사용하십시오.

## Activate Sleep and Airplane fn keys

1. https://github.com/hieplpvip/AsusSMC/wiki/Installation-Instruction 를 참고하십시오.
    - AsusSMC Release를 다운로드합니다: https://github.com/hieplpvip/AsusSMC/releases
    - install_daemon.sh를 터미널로 드래그해서 실행시키십시오.
- 곧바로 작동하지 않는다면 재부팅하십시오. 켁스트와 efi 드라이버, OS, 클로버 등을 업데이트 할 때 새로 실행해야 할 수 있습니다.

## Remap PS2

1. MaciASL을 이용하여 ACPI/additional/SSDT-PS2.dsl을 .aml 확장자로 Patched 폴더에 저장하십시오.
2. 재부팅합니다.
- Optional: non-macOS USB 키보드를 사용할 경우 SSDT-PS2.dsl의 commented-out 내용을 활성화시키고 Karabiner-Elements를 이용하여 left-cmd와 left-alt를 교환시키면 PS2 키보드와 USB 키보드 둘 다 left-cmd와 left-alt가 동일한 기능으로 작동합니다.

## Replace XOSI patch
두 패치 중 하나를 택하십시오.
### Insert _OSI for "Darwin"
1. ACPI/Patched/SSDT-XOSI.aml을 삭제하십시오.
2. MaciASL을 이용하여 ACPI/replacement/SSDT-_OSI-XINI.dsl을 .aml 확장자로 Patched 폴더에 저장하십시오.
3. 기존 config.plist/ACPI/DSDT/Patches/ 중 _OSI와 OSID 패치를 삭제하고 /replacement/config-_OSI-XINI.plist/ACPI/DSDT/Patches의 OSYS 패치를 복사하여 붙여넣으십시오.
4. 재부팅합니다.
### Assign OSYS "Windows 2015" value
1. ACPI/Patches/SSDT-XOSI.aml을 삭제하십시오.
2. MaciASL을 이용하여 ACPI/replacement/SSDT-OSYS.dsl을 .aml 확장자로 Patched 폴더에 저장하십시오.
3. 재부팅합니다.
- SSDT-OSYS.dsl이 SSDT-_OSI-XINI.dsl보다 안정적일 것으로 예상됩니다.

## When you think you are done
 
1. 클로버, 켁스트, 그리고 efi 파일을 최근 버전으로 업데이트 하십시오.
2. /L*/E*의 내용을 SSD의 EFI 파티션과 설치 USB EFI 파티션에 복사하십시오.

## Other things

1. OpenCore (10.15 Beta 2)
    - CC kext를 /L*/E*에서 로드합니다.
    - 종료시 패닉현상은 없습니다.
    - Clover 수준의 안정적인 EFI 폴더 구성 후 가이드를 제공할 예정입니다.
2. Clover
    - 키보드 Fn 조합 (터치패드 활성화/비활성화 버튼) 이 작동하지 않는 경우 CC를 제외한 켁스트를 전부 Clover에서 로드하십시오. 단, Clover에서 로드하는 경우 BrcmFirmwareRepo 대신 BrcmFirmwareData를 사용해야 블루투스가 안정적입니다.

## Changelog
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

the VoodooI2C helpdesk for working touchpad

headkaze for Hackintool

RehabMan for Null Ethernet and many other things

CrazyBird for HFS+ partitioning in 10.14+

daliansky and williambj1 for many hotpatch methods

## [hackintosh.co.kr](http://hackintosh.co.kr)
이 한국 커뮤니티에 방문하시면 기타 정보를 얻으실 수 있습니다.
