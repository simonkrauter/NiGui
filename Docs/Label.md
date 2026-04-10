Label
=====
*   [Procs](#12)
    *   [newLabel](#newLabel%2Cstring "newLabel(text = ""): Label")
    *   [init](#init%2CLabel "init(label: Label)")
*   [Methods](#14)
    *   [text=](#text%3D.e%2CLabel%2Cstring "text=(label: Label; text: string)")
    *   [xTextAlign=](#xTextAlign%3D.e%2CLabel%2CXTextAlign "xTextAlign=(label: Label; xTextAlign: XTextAlign)")
    *   [yTextAlign=](#yTextAlign%3D.e%2CLabel%2CYTextAlign "yTextAlign=(label: Label; yTextAlign: YTextAlign)")

[Procs](#12)
============

proc [newLabel](#newLabel%2Cstring)(text \= ""): Label {...}{.raises: \[Exception\], tags: \[RootEffect\].}

proc [init](#init%2CLabel)(label: Label) {...}{.raises: \[\], tags: \[\].}

[Methods](#14)
==============

method [text=](#text%3D.e%2CLabel%2Cstring)(label: Label; text: string) {...}{.base, raises: \[\], tags: \[\].}

method [xTextAlign=](#xTextAlign%3D.e%2CLabel%2CXTextAlign)(label: Label; xTextAlign: XTextAlign) {...}{.raises: \[\], tags: \[\].}

method [yTextAlign=](#yTextAlign%3D.e%2CLabel%2CYTextAlign)(label: Label; yTextAlign: YTextAlign) {...}{.raises: \[\], tags: \[\].}
