// USB controller is XHC, so PMEE needs to be properly set on sleep to avoid "Device not ejected properly" message
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "what", "pts", 0x00000000)
{
#endif
    External (_SB_.PCI0.XHC_.PMEE, FieldUnitObj)    // (from opcode)
    External (ZPTS, MethodObj)    // 1 Arguments (from opcode)

    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        If (_OSI ("Darwin"))
        {
            If (LAnd (LEqual (0x05, Arg0), CondRefOf (\_SB.PCI0.XHC.PMEE)))
            {
                Store (Zero, \_SB.PCI0.XHC.PMEE)
            }
        }

        ZPTS (Arg0)
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
