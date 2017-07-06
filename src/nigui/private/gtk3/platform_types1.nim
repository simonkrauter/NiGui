# NiGui - GTK+ 3 platform-specific code - part 1

# This file will be included in "nigui.nim".

type
  WindowImpl* = ref object of Window
    fHandle: pointer
    fInnerHandle: pointer

  ControlImpl* = ref object of Control
    fHandle: pointer
    fHScrollbar: pointer
    fVScrollbar: pointer
    fHAdjust: pointer
    fVAdjust: pointer
    fDeadCornerHandle: pointer

  CanvasImpl* = ref object of Canvas
    fSurface: pointer
    fData: cstring
    fStride: int
    fCairoContext: pointer
    fFont: pointer

  ImageImpl* = ref object of Image
