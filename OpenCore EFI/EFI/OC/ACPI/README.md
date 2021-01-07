# Battery: Modified RECB and WECB methods
## Problem
I was studying the [`new` battery patch guide](https://xstar-dev.github.io/hackintosh_advanced/Guide_For_Battery_Hotpatch.html) and was wondering if there was a simpler way of reading and writing `FieldUnitObjs` with size above 32 bits.\
There are many databases which contain battery patches for various laptops, but they are not very consistent when breaking up `FieldUnitObjs` size above 32 bits. If the `OperationRegion` starts at `Zero`, then they use `RE1B` and `RECB` (or `WE1B` and `WECB`. I should inclusively call them `xE1B` and `xECB`.) methods. If it starts at something other than `Zero`, then they break up `256`-bits into a set of 32 `FieldUnitObjs` and write every single one of them into `xRBA` methods. A lack of a unified guide, and also tiring...\
The [`new` battery patch guide](https://xstar-dev.github.io/hackintosh_advanced/Guide_For_Battery_Hotpatch.html) talks about how `SystemMemory` `OperationRegions` also need patching and there it shows this:
```
注意

有些笔记本的 EC 使用 SystemMemory 作用域，则 EC、RE1B 和 WE1B 的 Field 起始偏移量也需要加上原始定义数值，参照如下所示代码进行修改
```
English translation:
```
note

Some notebook EC use SystemMemoryscope, EC, RE1B and WE1B the Field starting offset is also necessary to add the value originally defined with reference to the code to be modified as shown below
```
```
Scope (_SB.PCI0.LPCB.EC0)
{
    OperationRegion (ERAX, SystemMemory, 0xFE708300, 0x0100)
    Field (ERAX, ByteAcc, Lock, Preserve)
    {
    ···
    Method (RE1B, 1, NotSerialized)
    {
        Local0 = (0xFE708300 + Arg0)
        OperationRegion (ERM2, SystemMemory, Local0, One)
```
Notice how they summed the `Offsets` of the `OperationRegion` and the `FieldUnitObj`. With this, no more manually breaking up `FieldUnitObjs` and putting them all into `xRBA` methods; just write a set of `xE1B` and `xECB` methods! But I have to be smarter. I do not want to define a new set of methods every time a different `OperationRegion` `Offset` shows up.
## Preliminary work
These are the usual methods to read and write to larger-sized `FieldUnitObjs`:
```
Method (RE1B, 1, NotSerialized)
{
    OperationRegion (ERM2, EmbeddedControl, Arg0, One)
    Field (ERM2, ByteAcc, NoLock, Preserve)
    {
        BYTE,   8
    }

    Return (BYTE) /* \_SB_.PCI0.LPCB.EC0_.RE1B.BYTE */
}

Method (RECB, 2, Serialized)
{
    Arg1 = ((Arg1 + 0x07) >> 0x03)
    Name (TEMP, Buffer (Arg1){})
    Arg1 += Arg0
    Local0 = Zero
    While ((Arg0 < Arg1))
    {
        TEMP [Local0] = RE1B (Arg0)
        Arg0++
        Local0++
    }

    Return (TEMP) /* \_SB_.PCI0.LPCB.EC0_.RECB.TEMP */
}

Method (WE1B, 2, NotSerialized)
{
    OperationRegion (ERAM, EmbeddedControl, Arg0, One)
    Field (ERAM, ByteAcc, NoLock, Preserve)
    {
        BYTE,   8
    }

    BYTE = Arg1
}

Method (WECB, 3, Serialized)
{
    Arg1 = ((Arg1 + 0x07) >> 0x03)
    Name (TEMP, Buffer (Arg1){})
    TEMP = Arg2
    Arg1 += Arg0
    Local0 = Zero
    While ((Arg0 < Arg1))
    {
        WE1B (Arg0, DerefOf (TEMP [Local0]))
        Arg0++
        Local0++
    }
}
```
So let's modify these methods so I can let the computer do all the work and not me. I think it should be very simple. I just need to include the `OperationRegion` `Offset` as a `Variable`. Since the `xECB` methods pass the `FieldUnitObj` `Offset` to `xE1B` methods as `Arg0`, adding the `OperationRegion` `Offset` to `Arg0` and passing it would suffice.\
Increase the number of `Arguments` to `xECB` methods by `1` in their definition:
```
...
Method (RECB, 3, Serialized)
...
Method (WECB, 4, Serialized)
...
```
And add the last `Argument` to `Arg0`
```
...
Method (RECB, 3, Serialized)
{
...
        TEMP [Local0] = RE1B ((Arg0 + Arg2))
...
}
...
Method (WECB, 4, Serialized)
{
...
        WE1B ((Arg0 + Arg3), DerefOf (TEMP [Local0]))
...
}
...
```
Then remember to write the `OperationRegion` `Offset` in the last `Argument`.
Now the methods should be used like this:
```
RECB (FieldUnitObj Offset, FieldUnitObj Length, OperationRegion Offset)
WECB (FieldUnitObj Offset, FieldUnitObj Length, Value written to FieldUnitObj, OperationRegion Offset)
```
Then we are good to go!
## Application
In this ASUS laptop, there is only one `FieldUnitObj` we need to work on. In `DSDT`, 256-bit `BDAT` object in one of its `EmbeddedControl` `OperationRegions`:
```
OperationRegion (SMBX, EmbeddedControl, 0x18, 0x28)
Field (SMBX, ByteAcc, NoLock, Preserve)
{
    PRTC,   8, 
    SSTS,   5, 
        ,   1, 
    ALFG,   1, 
    CDFG,   1, 
    ADDR,   8, 
    CMDB,   8, 
    BDAT,   256, 
    BCNT,   8, 
        ,   1, 
    ALAD,   7, 
    ALD0,   8, 
    ALD1,   8
}
```
tctien342 and hieplpvip were kind to us and broke this whole thing into 32 `FieldUnitObjs` and wrote them all into two methods and all too very long lines of codes, but not anymore! We are going to change that. Now remember the `FieldUnitObj` `Offset` `0x04`, `FieldUnitObj` `Length` `256`, and `OperationRegion` `Offset` `0x18`.\
`BDAT` is read and written in `DSDT` four times. Inside `Method (\_SB.PCI0.LPCB.EC0.SMBR...` and `Method (\_SB.PCI0.LPCB.EC0.SMBW...`.\
`SMBR`:
```
...
BDAT = Zero
...
Local0 [0x02] = BDAT
...
```
`SMBW`:
```
...
BDAT = Zero
...
BDAT = Arg4
...
```
In the above, the second operation is `Read` and all the others are `Write`. So let's make use of our new methods.\
`SMBR`:
```
...
WECB (0x04, 256, Zero, 0x18)
...
Local0 [0x02] = RECB (0x04, 0x0100, 0x18)
...
```
`SMBW`:
```
...
WECB (0x04, 256, Zero, 0x18)
...
WECB (0x04, 256, Arg4, 0x18)
...
```
Now we are done!\
I have already uploaded the modified [SSDT-Battery.aml](SSDT-Battery.aml) so you can use it right away. It also has modified `B1B2` (now called `R16B`) and newly defined `W16B` method to write to a 16-bit register instead so for easier recognition.
## Other things
- What if the `OperationRegion` starts at `Zero` `Offset`? Then the last `Argument` should be `Zero`.
- Studying the ACPI is more interesting than I thought. I might work on [`Battery Information Supplement`](https://github.com/acidanthera/VirtualSMC/blob/master/Docs/Battery%20Information%20Supplement.md).
