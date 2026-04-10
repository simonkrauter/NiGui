-   [Types](#7)
    -   [Container](#Container "Container = ref object of ControlImpl
          fFrame: Frame
          fChildControls: seq[Control]")
-   [Procs](#12)
    -   [newContainerContainer](#newContainer "newContainer(): Container")
    -   [initContainer](#init%2CContainer "init(container: Container)")
-   [Methods](#14)
    -   [frameContainer](#frame.e%2CContainer "frame(container: Container): Frame")
    -   [frame=Container](#frame%3D.e%2CContainer%2CFrame "frame=(container: Container; frame: Frame)")
    -   [addContainer](#add.e%2CContainer%2CControl "add(container: Container; control: Control)")
    -   [removeContainer](#remove.e%2CContainer%2CControl "remove(container: Container; control: Control)")
    -   [getPaddingContainer](#getPadding.e%2CContainer "getPadding(container: Container): Spacing")
    -   [setInnerSizeContainer](#setInnerSize.e%2CContainer%2Cint%2Cint "setInnerSize(container: Container; width, height: int)")

[Types](#7)
===========

    Container = ref object of ControlImpl
      fFrame: Frame
      fChildControls: seq[Control]

[Procs](#12)
============

    proc newContainer(): Container {...}{.raises: [Exception], tags: [RootEffect].}

    proc init(container: Container) {...}{.raises: [Exception], tags: [RootEffect].}

[Methods](#14)
==============

    method frame(container: Container): Frame {...}{.base, raises: [], tags: [].}

    method frame=(container: Container; frame: Frame) {...}{.base, raises: [], tags: [].}

    method add(container: Container; control: Control) {...}{.base, raises: [], tags: [].}

    method remove(container: Container; control: Control) {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method getPadding(container: Container): Spacing {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method setInnerSize(container: Container; width, height: int) {...}{.base, locks: "unknown",
        raises: [], tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:30:49 UTC
