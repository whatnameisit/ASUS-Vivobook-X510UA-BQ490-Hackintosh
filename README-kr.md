# Asus Vivobook X510UA-BQ490

This build running on MacOs X

![Alt text](https://ivanov-audio.com/wp-content/uploads/2014/01/Hackintosh-Featured-Image.png)

## Detail

1. Version:    9-A
2. Date:       July 15, 2019
3. Support:    All BIOS
4. Changelogs: tctien342's master branch로부터 내용을 줄였습니다.
    - 매끄럽고 정확한 클릭을 위해 VoodooI2C 작동모드를 Interrupts에서(SSDT-ELAN.aml) Polling으로(SSDT-ELAN-Polling.aml) 바꾸었습니다.
    - 옵티머스 기능이 없기 때문에 기존 SSDT-S510UA-KabyLakeR.aml의 해당 내용을 삭제하고, SSDT-RP01_PEGP를 삭제했습니다. 
    - 시에라 이후에는 USB 전력 관리에 AAPL properties가 사용되지 않기 때문에 삭제했습니다.
    - SD 카드 리더기가 USB로 연결되어 있기 때문에 Sinetek-rtsx.kext를 삭제했습니다.
    - USBInjectAll.kext와 정확하지 않은 SSDT-UIA.aml를 삭제하고 BQ490 기준으로 패치된 USBPorts.kext와 패치내용을 추가했습니다.
    - AirportBrcmFixup.kext만으로 와이파이와 Handoff 기능이 충분하기 때문에 BT4LEContinuityFixup.kext, FakePCIID.kext, 그리고 FakePCIID 플러그인 켁스트를 삭제했습니다.
    - RMNE 장치를 기존 SSDT-S510UA-KabyLakeR.aml에서부터 분리했습니다.
5. Status: Stable

## System specification

1. Name:           Asus Vivobook X510UA-BQ490
2. CPU:            Intel Core i5-8250U
3. Graphic:        Intel UHD620
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
이 fork는 X510UA-BQ490에 최적화되도록 구성했습니다. 만약 본인의 노트북에 옵티머스 외장그래픽이 없고 키보드 백라이트가 없다면 사용할 수 있지만, 책임은 본인에게 있습니다. 부담이 되거나 외장그래픽 기능을 제어해야 한다면 tctien342의 기존 master branch나 hieplpvip의 Zenbook repository를 참고하시길 바랍니다.

## Step to install

1. macOS 인스톨러 USB를 준비합니다. (creationmedia 방법이나 Mojave와 Catalina를 HFS+ 파일시스템에 설치하고 싶다면 MBR HFS Firmware Check Patch를 사용하십시오. https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/) 기존 맥 시스템이 없다면 가상머신을 이용하실 수 있습니다. 또는 hackintosh.co.kr에서 고스트를 다운로드 받아 설치하시면 편리합니다.
2. USB의 EFI 파티션에 Clover EFI를 붙여넣고, 이름을 Clover EFI > EFI로 변경하십시오.
3. 바이오스에서 VT-d를 비활성화 시키고 USB로 부팅해서 macOS Installer를 선택하십시오.
4. 설치중에는 터치패드가 작동하지 않습니다. 따라서 별도의 마우스가 필요합니다. tonymacx86이나 다른 해킨토시 커뮤니티를 참고해서 설치를 마무리하십시오. 한글을 원하시면 hackintosh.co.kr를 이용하십시오.
    - 만약 Catalina를 HFS+ 파일시스템으로 설치하신다면 https://www.insanelymac.com/forum/files/file/985-catalina-mbr-hfs-firmware-check-patch/의 설치방법을 참고하십시오. 설치가 완료된 후 DW1560에 대해 블루투스 켁스트를 Catalina 대응 버전으로 업데이트해야 합니다. https://github.com/headkaze/OS-X-BrcmPatchRAM/releases에서 다운로드 받으실 수 있습니다. 설치 방법이나, 패치 내용은 https://www.insanelymac.com/forum/topic/339175-brcmpatchram2-for-1015-catalina-broadcom-bluetooth-firmware-upload/를 참고하십시오.
5. 설치가 완료된 후에 macOS로 부팅해서 /kexts/Other의 켁스트를 -> /Library/Extension로 붙여넣으십시오.
6. Kext Utility를  이용해서 (또는 큰따옴표를 제외한 다음의 명령어를 터미널에 붙여넣습니다: "sudo chmod -R 755 /L*/E*&&sudo chown -R 0:0 /L*/E*&&sudo kextcache -i /") 캐시를 재생성하고 재부팅하십시오.
7. 터치패드와 소리가 (마이크) 정상작동합니다. Clover EFI의 하위폴더를 SSD의 EFI 하위폴더로 붙여넣습니다.
8. EFI 폴더를 설치한 후 Clover Configurator를 이용해서 MacBookPro11,1의 SMBIOS 내용을 생성하십시오.
- Note: 경우에 따라서 additional의 켁스트와 SSDT를 새로 설치하거나, config.plist의 내용을 변경하거나, USB 매핑을 설정하거나, 잠자기 and 비행기모드 fn 키 설정이 필요할 수 있습니다.
    - DW1560를 설치한 경우 -- WIFI Replacement
    - DW1560설치 이후 잠자기에서 깨어난 상태에서 블루투스가 작동하지 않을 때 -- Set Bluetooth port as internal
    - WiFi & BT 모듈을 DW1560로 교체하지 않았지만 USB WiFi 동글이나 USB LAN를 통해 iMessage와 FaceTime를 활성화시킬 때 -- Install RehabMan Null Ethernet
    - 잠자기와 비행기모드 fn 버튼이 있을 때

## WIFI Replacement

1. DW1560 카드를 설치하십시오.
2. 지역이 한국인 경우 bootflag가 brcmfx-country=#a인 것을 확인하십시오.
3. 권장사항: /kexts/other/additional/LiluFriend.kext를 (또는 새롭게 LiluFriend를 생성하십시오.) /L*/E*에 붙여넣고 캐시를 재생성하십시오.
4. 재부팅합니다.

## Set Bluetoth port as internal

1. /L*/E*의 3rd party USB 관련 켁스트나 SSDT-UIA.aml가 로드되지 않은 것을 확인하십시오.
2. headkaze의 Hackintool를 다운로드 하십시오: http://headsoft.com.au/download/mac/Hackintool.zip.
3. USB 탭에서 블루투스 포트를 확인하고 internal로 설정하십시오. UVC 카메라 또한 internal로 설정할 수 있습니다. Export/내보내기 버튼으로 codeless injection kext과 SSDT-UIA.aml를 생성하십시오.
4. USBPorts.kext를 /L*/E*에 설치하십시오. (또는 추가전력 관리를 수동으로 설정하고 싶다면 USBInjectAll.kext와 SSDT-UIA.aml를 설치하십시오. 자세한 내용은 https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/ 에서 확인하실 수 있습니다.)
5. 캐시를 재생성하고 재부팅합니다.
- Note: kexts/other/additional의 USBPorts.kext는 제 X510UA-BQ490에 해당하는 켁스트입니다. 종료나 잠자기 시 오류를 방지하기 위해 본인의 USB 매핑을 설정하는 것을 추천합니다.

## Install RehabMan Null Ethernet

1. /kexts/other/additional/NullEthernet.kext를 /L*/E*에 설치하고 캐시를 재생성하십시오.
2. /ACPI/additional/SSDT-RMNE를 /ACPI/patched로 복사하십시오.
3. 재부팅합니다.
- Note: 안정적인 iMessage, FaceTime, 그리고 App Store를 사용하기 위해서는 Null Ethernet를 먼저 설치한 후 기타 USB 동글이나 LAN을 사용하십시오.

## Sleep and Airplane fn keys
1. https://github.com/hieplpvip/AsusSMC/wiki/Installation-Instruction를 참고하십시오.
    - hieplpvip의 repository를 다운로드합니다: https://github.com/hieplpvip/AsusSMC
    - AsusSMCDaemon/install_daemon.sh를 터미널로 드래그해서 실행시키십시오.
    - 곧바로 작동하지 않는다면 재부팅하십시오.

## When you think you are done
 
1. /L*/E*의 내용을 SSD의 EFI 파티션과 USB (비상용) EFI 파티션에 복사하십시오.

## Problems with the polling mode in other laptops
1. X510UA-BQ490에서는 USTP=1 설정으로 FMCN and SSCN의 자동활성화 시 macOS 한 번의 터치패드 클릭을 여러 번으로 인식하는 현상이 수정되었습니다. X510UA-BQ492에서는 패치를 적용한 후에도 노트북이 배터리로 운영되는 중에는 문제가 재발생합니다. FMCN and SSCN의 수동할당이 필요할 수 있습니다. https://github.com/hieplpvip/ASUS-ZENBOOK-HACKINTOSH/blob/master/src/hotpatch/SSDT-I2CBUS.dsl를 참고하고 VoodooI2C helpdesk에 도움을 요청하십시오.

## Other things
1. OpenCore
    - 종료시 패닉 현상이 발생합니다.
    - CodecCommander.kext를 OC로 인젝트할 경우 마이크가 작동하지 않습니다.
    - 대부분 사용자 오류일 것으로 판단됩니다.

## Credits

Apple for macOS

tctien342 and hieplpvip for Asus repo

the VoodooI2C helpdesk for working touchpad

headkaze for Hackintool

RehabMan for Null Ethernet and many other things

CrazyBird for HFS+ partitioning in 10.14+

## hackintosh.co.kr
이 한국 커뮤니티에 방문하시면 기타 정보를 얻으실 수 있습니다.
