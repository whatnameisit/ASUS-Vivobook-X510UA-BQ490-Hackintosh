# Battery: Hibernate at low battery
## Problem
This Asus Vivobook is reported to imediately wake after sleep at low battery level: [Issue #9](https://github.com/whatnameisit/Asus-Vivobook-X510UA-BQ490-Hackintosh/issues/9). I have not experienced such issue, but it seems a real one. I have tried the updated HibernationFixup.kext on other laptop which forces sleep / hibernation from the kernel, but it did not work. I think kexts are great, and I really appreciate the developers, but sometimes they break because most of them modify the kernel which is regularly updated.\
So what could I do? Well, the new feature in HibernationFixup.kext is supposed to eliminate the need to modify ACPI to force sleep / hibernate at low battery, which means I could still modify the ACPI to do the correct job.\
It has been some time since I knew the work was possible from reading [Hibernate при разряде батареи](https://applelife.ru/threads/hibernate-pri-razrjade-batarei.2874421/), but I did not quite understand what was being done. Someone asked if this thread could be used on their hackintosh on this [issue](https://github.com/tylernguyen/x1c6-hackintosh/issues/126#issuecomment-833750930), and the author of the thread, usr-sse2, explained what to be done. Thanks to him, I can write a patch then.

## Preliminary work
I read [usr-sse2's comment](https://github.com/tylernguyen/x1c6-hackintosh/issues/126#issuecomment-833750930) and the ACPI Specification version 6.4 on [`_BIX`](https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/10_Power_Source_and_Power_Meter_Devices/Power_Source_and_Power_Meter_Devices.html#bix-battery-information-extended) and [`_BST`](https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/10_Power_Source_and_Power_Meter_Devices/Power_Source_and_Power_Meter_Devices.html#bst-battery-status) to understand what needed to be done. They are relatively short and easy to understand, so I suggest you read them, too.

## Application
This ASUS laptop already has sleep button defined in the ACPI, so there is no need to add `SLPB`.\
I need to know where the battery capacity and current battery level information is stored.\
The battery capacity to use can be between design capacity and last full capacity. I initially thought it would be better to use last full capacity, but the level was a little bit unstable with AsusSMC's `Battery Health` on macOS and `Battery Health Charging` on Windows when I tested. So I chose design capacity in the end. It is the third index (0x02) in `_BIX`.\
Looking into `_BIX`, we find it returns `BIXT`.
```
Method (_BIX, 0, NotSerialized)  // _BIX: Battery Information Extended
{
...
    Return (BIXT) /* \_SB_.PCI0.LPCB.EC0_.BAT0.BIXT */
}
```
This means `BIXT` is the package that `_BIX` returns and the third index contains the value of design capacity.
```
Name (BIXT, Package (0x14)
{
    Zero, 
    Zero, 
    0x1770, 
    0x1770, 
    One, 
    0x39D0, 
    0x0258, 
    0x012C, 
    Zero, 
    0xFFFFFFFF, 
    0xFFFFFFFF, 
    0xFFFFFFFF, 
    0xFFFFFFFF, 
    0xFFFFFFFF, 
    0x3C, 
    0x3C, 
    "M3N", 
    " ", 
    "LIon", 
    "ASUSTeK"
})
```
Now, is 0x1770 equal to 6000 42WH? I am not sure. However, the package is updated as `_BIX` is executed every now and then, so I think it is safe to use the third index of `BIXT` and assume it does contain the design capacity value.\
Looking into `_BST`, we find it returns `PBST`.
```
Method (_BST, 0, NotSerialized)  // _BST: Battery Status
{
...
    Return (PBST) /* \_SB_.PCI0.LPCB.EC0_.BAT0.PBST */
}
```
By the same logic, we can assume `PBST` is updated and contains the values that we need.\
Putting the information we gathered, we have the following:
```
Method (\_SB.PCI0.LPCB.EC0.BAT0._BST, 0, NotSerialized)  // _BST: Battery Status
{
...
    If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [Zero]) & One))
    {
        Divide (DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.BIXT [0x02]), 0x14, Local0, Local1)
        If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [0x02]) < Local1))
        {
            Notify (\_SB.SLPB, 0x80) // Status Change
        }
    }

    Return (\_SB.PCI0.LPCB.EC0.BAT0.PBST) /* External reference */
}
```
This is the exact same format usr-sse2 used in their laptop. However, what if I wanted to set a custom level to hibernate? I would take multiples of `Local1` to be in the second condition with the `*=` operator. This could be used to multiply a variable by a number and set that assign the result to that variable. If `Local1 *= 2`, it is 10 percent battery level.
```
Method (\_SB.PCI0.LPCB.EC0.BAT0._BST, 0, NotSerialized)  // _BST: Battery Status
{
...
    If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [Zero]) & One))
    {
        Divide (DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.BIXT [0x02]), 0x14, Local0, Local1)
        Local *= 0x02
        If ((DerefOf (\_SB.PCI0.LPCB.EC0.BAT0.PBST [0x02]) < Local1))
        {
            Notify (\_SB.SLPB, 0x80) // Status Change
        }
    }

    Return (\_SB.PCI0.LPCB.EC0.BAT0.PBST) /* External reference */
}
```
Now we are done!\
If you want to have any other level than 10 percent, modify the multiplier or do other calculations. But keep in mind that it is somewhat meaningless below 5, say 3, because the laptop will not hibernate until it reaches 3 percent.

## Other things
- This document uses the word "hibernate," but the technique here works with regular sleep.
