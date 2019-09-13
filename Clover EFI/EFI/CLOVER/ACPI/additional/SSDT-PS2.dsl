// PS2 remap
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "ps2", 0x00000000)
{
#endif
    Name (_SB.PCI0.LPCB.PS2K.RMCF, Package (0x02)
    {
        "Keyboard", 
        Package ()
        {
            "Custom PS2 Map", 
            Package ()
            {
                Package (){}, 
                "3f=0", // Map f5 to nothing
                "40=0", // Map f6 to nothing
                // Uncomment if you want to use non-macOS USB keyboard to map PS2 to USB keyboard
                // Then use Karabiner Elements to switch back
                /*"e05b=38", // PS2-left-cmd to PS2-left-alt
                "38=e05b" // PS2-left-alt to PS2-left-cmd
                */
            }
        }
    })
#ifndef NO_DEFINITIONBLOCK
}
#endif