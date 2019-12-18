// Touchpad activation with VoodooI2C and HID satellite kexts
// SBFx patches are not needed because the HID kext falls into the polling mode
// after finding that APIC and GPIO are incompatible.
// The piece of code in SSDT-I2Cx_USTP.aml that caused kp with v2.3 VoodooI2C kexts is now removed.
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "elan", 0x00000000)
{
#endif
    External (_SB_.PCI0.I2C1, DeviceObj)    // (from opcode)

    Scope (_SB.PCI0.I2C1)
    {
        If (_OSI ("Darwin"))
        {
            Name (USTP, One) // "Infinite click" fix.
            Name (SSCN, Package (0x03) // Assignment of SSCN and FMCN
            {
                0x0210, 
                0x0280, 
                0x1E
            })
            Name (FMCN, Package (0x03)
            {
                0x80, 
                0xA0, 
                0x1E
            })
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
