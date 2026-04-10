Frame
=====
*   [Types](#7)
    *   [Frame](#Frame "Frame = ref object of ControlImpl
          fText: string")
*   [Procs](#12)
    *   [newFrameFrame](#newFrame%2Cstring "newFrame(text = ""): Frame")
    *   [initFrame](#init%2CFrame "init(frame: Frame)")
*   [Methods](#14)
    *   [textFrame](#text.e%2CFrame "text(frame: Frame): string")
    *   [text=Frame](#text%3D.e%2CFrame%2Cstring "text=(frame: Frame; text: string)")
    *   [getPaddingFrame](#getPadding.e%2CFrame "getPadding(frame: Frame): Spacing")

[Types](#7)
===========

[Frame](Frame.html#Frame) \= ref object of ControlImpl
  fText: string

[Procs](#12)
============

proc [newFrame](#newFrame%2Cstring)(text \= ""): [Frame](Frame.html#Frame) {...}{.raises: \[Exception\], tags: \[RootEffect\].}

proc [init](#init%2CFrame)(frame: [Frame](Frame.html#Frame)) {...}{.raises: \[Exception\], tags: \[RootEffect\].}

[Methods](#14)
==============

method [text](#text.e%2CFrame)(frame: [Frame](Frame.html#Frame)): string {...}{.base, raises: \[\], tags: \[\].}

method [text=](#text%3D.e%2CFrame%2Cstring)(frame: [Frame](Frame.html#Frame); text: string) {...}{.base, locks: "unknown", raises: \[\], tags: \[\].}

method [getPadding](#getPadding.e%2CFrame)(frame: [Frame](Frame.html#Frame)): Spacing {...}{.base, locks: "unknown", raises: \[\], tags: \[\].}

  
Made with Nim. Generated: 2020-03-15 04:30:50 UTC
