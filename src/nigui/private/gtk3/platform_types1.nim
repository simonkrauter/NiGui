# NiGui - GTK+ 3 platform-specific code - part 1

# This file will be included in "nigui.nim".

type
  WindowImpl* = ref object of Window
    fHandle: pointer
    fInnerHandle: pointer
    fIMContext: pointer
    fKeyPressed: Key

  ControlImpl* = ref object of Control
    fHandle: pointer
    fHScrollbar: pointer
    fVScrollbar: pointer
    fHAdjust: pointer
    fVAdjust: pointer
    fDeadCornerHandle: pointer
    fIMContext: pointer
    fKeyPressed: Key

  CanvasImpl* = ref object of Canvas
    fSurface: pointer
    fData: ptr UncheckedArray[byte]
    fStride: int
    fCairoContext: pointer
    fFont: pointer

  ImageImpl* = ref object of Image
