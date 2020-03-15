-   [Procs](#12)
    -   [newCanvas](#newCanvas%2CControl "newCanvas(control: Control = nil): CanvasImpl")
-   [Methods](#14)
    -   [destroy](#destroy.e%2CCanvas "destroy(canvas: Canvas)")
    -   [fontFamily=](#fontFamily%3D.e%2CCanvas%2Cstring "fontFamily=(canvas: Canvas; fontFamily: string)")
    -   [fontSize=](#fontSize%3D.e%2CCanvas%2Cfloat "fontSize=(canvas: Canvas; fontSize: float)")
    -   [fontBold=](#fontBold%3D.e%2CCanvas%2Cbool "fontBold=(canvas: Canvas; fontBold: bool)")
    -   [textColor=](#textColor%3D.e%2CCanvas%2CColor "textColor=(canvas: Canvas; color: Color)")
    -   [lineColor=](#lineColor%3D.e%2CCanvas%2CColor "lineColor=(canvas: Canvas; color: Color)")
    -   [lineWidth=](#lineWidth%3D.e%2CCanvas%2Cfloat "lineWidth=(canvas: Canvas; width: float)")
    -   [areaColor=](#areaColor%3D.e%2CCanvas%2CColor "areaColor=(canvas: Canvas; color: Color)")
    -   [getTextLineWidth](#getTextLineWidth.e%2CCanvas%2Cstring "getTextLineWidth(canvas: Canvas; text: string): int")
    -   [getTextLineHeight](#getTextLineHeight.e%2CCanvas "getTextLineHeight(canvas: Canvas): int")
    -   [getTextWidth](#getTextWidth.e%2CCanvas%2Cstring "getTextWidth(canvas: Canvas; text: string): int")
    -   [drawTextCentered](#drawTextCentered.e%2CCanvas%2Cstring%2Cint%2Cint "drawTextCentered(canvas: Canvas; text: string; x, y = 0; width, height = -1)")
    -   [fill](#fill.e%2CCanvas "fill(canvas: Canvas)")
    -   [interpolationMode=](#interpolationMode%3D.e%2CCanvas%2CInterpolationMode "interpolationMode=(canvas: Canvas; mode: InterpolationMode)")

[Procs](#12)
============

    proc newCanvas(control: Control = nil): CanvasImpl {...}{.raises: [], tags: [].}

[Methods](#14)
==============

    method destroy(canvas: Canvas) {...}{.base, locks: "unknown", raises: [], tags: [].}

    method fontFamily=(canvas: Canvas; fontFamily: string) {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method fontSize=(canvas: Canvas; fontSize: float) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method fontBold=(canvas: Canvas; fontBold: bool) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method textColor=(canvas: Canvas; color: Color) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method lineColor=(canvas: Canvas; color: Color) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method lineWidth=(canvas: Canvas; width: float) {...}{.base, raises: [], tags: [].}

    method areaColor=(canvas: Canvas; color: Color) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method getTextLineWidth(canvas: Canvas; text: string): int {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method getTextLineHeight(canvas: Canvas): int {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method getTextWidth(canvas: Canvas; text: string): int {...}{.base, raises: [], tags: [].}

    method drawTextCentered(canvas: Canvas; text: string; x, y = 0; width, height = -1) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method fill(canvas: Canvas) {...}{.base, raises: [Exception], tags: [RootEffect].}

    method interpolationMode=(canvas: Canvas; mode: InterpolationMode) {...}{.base, raises: [],
        tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:29:17 UTC
