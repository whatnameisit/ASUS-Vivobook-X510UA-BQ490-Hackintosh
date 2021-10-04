// This is a template that does not work on its own. Read below to use in your own SSDT.
// This example includes how to set a custom sleep battery level.

DefinitionBlock ("", "SSDT", 2, "what", "LowBat", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC0_.BAT0.BIXT, PkgObj)
    External (_SB_.PCI0.LPCB.EC0_.BAT0.PBST, PkgObj)
    External (_SB_.SLPB, DeviceObj)

    /*
       Find _BIX method and check which package _BIX returns.
       If there is no _BIX in the ACPI, refer to _BIF and the corresponding index for design capacity.
    Method (\_SB.PCI0.LPCB.EC0.BAT0._BIX, 0, NotSerialized)  // _BIX: Battery Information Extended
    {
        // Contents before returning _BIX package
        
        Return (\_SB_.PCI0.LPCB.EC0_.BAT0.BIXT) // _BIX returns BIXT. The second (0x03) index of BIXT will contain design capacity.
    }
    */

    // Find _BST method and insert code just before return.
    Method (\_SB.PCI0.LPCB.EC0.BAT0._BST, 0, NotSerialized)  // _BST: Battery Status
    {
        // Contents before returning _BST package
        
        If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [Zero]) & One)) // Check the first (Zero) index of PBST is DWORD 1, or discharging. DWORD 1 & One should return One, or true, meaning it is discharging.
        {
            Divide (DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.BIXT [0x02]), 0x14, Local0, Local1) // Divide the design capacity by 0x14 = 20, and store that into Local1.
            Local1 *= 0x02 // Multiply Local1 by 2 which will be 10.
            If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [0x02]) < Local1)) // If the current charge level is less than 10 percent of design capacity
            {
                Notify (\_SB.SLPB, 0x80) // notify the sleep button, meaning go to sleep.
            }
        }
        

        Return (\_SB.PCI0.LPCB.EC0.BAT0.PBST) // _BST returns PBST. The first (Zero) index of PBST will be battery state.
    }
}

