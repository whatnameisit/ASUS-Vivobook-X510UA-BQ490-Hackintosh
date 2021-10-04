// This is just a template. It does not work on its own. Read below to use in your own SSDT.
// This example includes how to force sleep at a custom battery charge level.
// This way of patching by itself will also affect sleep behavior in other OS.
// If you want to apply this only to macOS, refer to "Overview" in OC-little-Translated: https://github.com/5T33Z0/OC-Little-Translated. You might as well read the rest.
// Original _BST needs to be renamed to something else for the newly written _BST to execute without error.
// Find the Base of _BST, which in this case is \_SB.PCI0.LPCB.EC0.BAT0, and rename _BST to, say, ZBST. Check you do not have the same object name in this scope.
// In config.plist
// Base    : \_SB.PCI0.LPCB.EC0.BAT0
// Comment : Rename _BST to ZBST in \_SB.PCI0.LPCB.EC0.BAT0
// Find    : 5F 42 53 54
// Replace : 5A 42 53 54

DefinitionBlock ("", "SSDT", 2, "what", "LowBat", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC0_.BAT0.BIXT, PkgObj)
    External (_SB_.PCI0.LPCB.EC0_.BAT0.PBST, PkgObj)
    External (_SB_.SLPB, DeviceObj)

    /*
       Find _BIX method and check which package _BIX returns.
       If there is no _BIX in the ACPI, check _BIF and the corresponding index for design capacity: second index (0x01).
    Method (\_SB.PCI0.LPCB.EC0.BAT0._BIX, 0, NotSerialized)  // _BIX: Battery Information Extended
    {
        // Contents before returning _BIX package
        
        Return (\_SB_.PCI0.LPCB.EC0_.BAT0.BIXT) // _BIX returns BIXT. The third (0x02) index of BIXT will contain design capacity.
    }
    */

    // Find _BST method and insert code just before return.
    Method (\_SB.PCI0.LPCB.EC0.BAT0._BST, 0, NotSerialized)  // _BST: Battery Status
    {
        // Contents before returning _BST package
        
        If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [Zero]) & One)) // Check the first (Zero) index of PBST is DWORD 1, or discharging. DWORD 1 & One should return One, or true, meaning it is discharging.
        {
            Divide (DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.BIXT [0x02]), 0x14, Local0, Local1) // Divide the design capacity (100) by 0x14 (20), and store that into Local1 (5).
            Local1 *= 0x02 // Multiply Local1 (5) by 2 (now 10).
            If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [0x02]) < Local1)) // If the battery remaining capacity is less than 10 percent of design capacity
            {
                Notify (\_SB.SLPB, 0x80) // notify the sleep button, meaning go to sleep.
            }
        }
        

        Return (\_SB.PCI0.LPCB.EC0.BAT0.PBST) // Need to make note of this first. _BST returns PBST. The first (Zero) and third (0x02) indexes of PBST will be battery state and battery remaining capacity.
    }
}

