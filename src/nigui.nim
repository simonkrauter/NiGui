# NiGui - main file

# This file contains all common code except extra widgets.
# All public procedures are declared here.
# Platform-specific code will added by "include".

# Templates for "include":
template useWindows(): bool = defined(windows) and not defined(forceGtk)
template useGtk(): bool = not useWindows()

# ========================================================================================
#
#                                   Public Declaration
#
# ========================================================================================

# ----------------------------------------------------------------------------------------
#                                     Simple Types
# ----------------------------------------------------------------------------------------

type
  Layout* = enum
    Layout_Horizontal
    Layout_Vertical

  XAlign* = enum
    XAlign_Left
    XAlign_Right
    XAlign_Center
    XAlign_Spread

  YAlign* = enum
    YAlign_Top
    YAlign_Bottom
    YAlign_Center
    YAlign_Spread

  XTextAlign* = enum
    XTextAlign_Left
    XTextAlign_Right
    XTextAlign_Center

  YTextAlign* = enum
    YTextAlign_Top
    YTextAlign_Bottom
    YTextAlign_Center

  WidthMode* = enum
    WidthMode_Static
    WidthMode_Auto
    WidthMode_Fill
    WidthMode_Expand

  HeightMode* = enum
    HeightMode_Static
    HeightMode_Auto
    HeightMode_Fill
    HeightMode_Expand

  MouseButton* = enum
    MouseButton_Left
    MouseButton_Middle
    MouseButton_Right

  Color* = object
    red*:   byte
    green*: byte
    blue*:  byte
    alpha*: byte

  Spacing* = object
    left*:   int
    right*:  int
    top*:    int
    bottom*: int

  Timer* = distinct int

  Key* = enum
    # Keys with same value than Unicode:
    Key_None       = 0
    Key_Backspace  = 8
    Key_Tab        = 9
    Key_Return     = 13
    Key_Pause      = 19
    Key_CapsLock   = 20
    Key_Escape     = 27
    Key_Space      = 32
    Key_ExclamationMark = 33
    Key_DoubleQuotes    = 34
    Key_NumberSign      = 35
    Key_Dollar     = 36
    Key_Percent    = 37
    Key_Ampersand  = 38
    Key_OpenParen  = 40
    Key_CloseParen = 41
    Key_Plus       = 43
    Key_Comma      = 44
    Key_Minus      = 45
    Key_Point      = 46
    Key_Divide     = 47
    Key_Number0    = 48
    Key_Number1    = 49
    Key_Number2    = 50
    Key_Number3    = 51
    Key_Number4    = 52
    Key_Number5    = 53
    Key_Number6    = 54
    Key_Number7    = 55
    Key_Number8    = 56
    Key_Number9    = 57
    Key_Less       = 60
    Key_Equal      = 61
    Key_Greater    = 62
    Key_QuestionMark = 63
    Key_AtSign     = 64
    Key_A          = 65
    Key_B          = 66
    Key_C          = 67
    Key_D          = 68
    Key_E          = 69
    Key_F          = 70
    Key_G          = 71
    Key_H          = 72
    Key_I          = 73
    Key_J          = 74
    Key_K          = 75
    Key_L          = 76
    Key_M          = 77
    Key_N          = 78
    Key_O          = 79
    Key_P          = 80
    Key_Q          = 81
    Key_R          = 82
    Key_S          = 83
    Key_T          = 84
    Key_U          = 85
    Key_V          = 86
    Key_W          = 87
    Key_X          = 88
    Key_Y          = 89
    Key_Z          = 90
    Key_SuperL     = 91
    Key_SuperR     = 92
    Key_ContextMenu = 93
    Key_Circumflex = 94
    Key_Numpad0    = 96
    Key_Numpad1    = 97
    Key_Numpad2    = 98
    Key_Numpad3    = 99
    Key_Numpad4    = 100
    Key_Numpad5    = 101
    Key_Numpad6    = 102
    Key_Numpad7    = 103
    Key_Numpad8    = 104
    Key_Numpad9    = 105
    Key_NumpadMultiply  = 106
    Key_NumpadAdd       = 107
    Key_NumpadSeparator = 108
    Key_NumpadSubtract  = 109
    Key_NumpadDecimal   = 110
    Key_NumpadDivide    = 111
    Key_F1         = 112
    Key_F2         = 113
    Key_F3         = 114
    Key_F4         = 115
    Key_F5         = 116
    Key_F6         = 117
    Key_F7         = 118
    Key_F8         = 119
    Key_F9         = 120
    Key_F10        = 121
    Key_F11        = 122
    Key_F12        = 123
    Key_F13        = 124
    Key_F14        = 125
    Key_F15        = 126
    Key_F16        = 127
    Key_F17        = 128
    Key_F18        = 129
    Key_F19        = 130
    Key_F20        = 131
    Key_F21        = 132
    Key_F22        = 133
    Key_F23        = 134
    Key_F24        = 135
    Key_NumLock    = 144
    Key_ScrollLock = 145
    Key_AE         = 196
    Key_OE         = 214
    Key_UE         = 220
    Key_SharpS     = 223
    # Not part of Unicode:
    Key_Insert     = 1000
    Key_Delete
    Key_Left
    Key_Right
    Key_Up
    Key_Down
    Key_Home
    Key_End
    Key_PageUp
    Key_PageDown
    Key_ControlL
    Key_ControlR
    Key_AltL
    Key_AltR
    Key_ShiftL
    Key_ShiftR
    Key_Print
    Key_NumpadEnter
    Key_AltGr

  InterpolationMode* = enum
    InterpolationMode_Default
    InterpolationMode_NearestNeighbor
    InterpolationMode_Bilinear

const
  inactiveTimer* = 0


# ----------------------------------------------------------------------------------------
#                                   Widget Types 1/3
# ----------------------------------------------------------------------------------------

type
  # Window base type:

  Window* = ref object of RootObj
    fDisposed: bool
    fTitle: string
    fVisible: bool
    fMinimized: bool
    fAlwaysOnTop: bool
    fWidth, fHeight: int
    fClientWidth, fClientHeight: int
    fX, fY: int
    fControl: Control
    fIconPath: string
    fOnDispose: WindowDisposeProc
    fOnCloseClick: CloseClickProc
    fOnResize: ResizeProc
    fOnDropFiles: DropFilesProc
    fOnKeyDown: KeyboardProc

  # Control base type:

  Control* = ref object of RootObj
    fDisposed: bool
    fParentControl: Control # is nil or object of ContainerImpl
    fParentWindow: Window # only set for top level widget
    fIndex: int
    fVisible: bool
    fWidth, fHeight: int
    fX, fY: int
    fWidthMode: WidthMode
    fHeightMode: HeightMode
    fMinWidth, fMinHeight: int
    fMaxWidth, fMaxHeight: int
    fXScrollEnabled, fYScrollEnabled: bool
    fXScrollPos, fYScrollPos: int
    fScrollableWidth, fScrollableHeight: int
    fFontFamily: string
    fFontSize: float
    fFontBold: bool
    fTextColor: Color
    fBackgroundColor: Color
    fUseDefaultFontFamily: bool
    fUseDefaultFontSize: bool
    fUseDefaultTextColor: bool
    fUseDefaultBackgroundColor: bool
    fCanvas: Canvas
    fOnDispose: ControlDisposeProc
    fOnDraw: DrawProc
    fOnMouseButtonDown: MouseButtonProc
    fOnMouseButtonUp: MouseButtonProc
    fOnClick: ClickProc
    # fOnMouseMove: MouseMoveProc
    fOnKeyDown: KeyboardProc
    tag*: string

  # Drawing:

  Canvas* = ref object of RootObj
    fWidth: int
    fHeight: int
    fFontFamily: string
    fFontSize: float
    fFontBold: bool
    fTextColor: Color
    fLineColor: Color
    fLineWidth: float
    fAreaColor: Color
    fInterpolationMode: InterpolationMode

  Image* = ref object of RootObj
    fCanvas: Canvas

  # Window events:

  WindowDisposeEvent* = ref object
    window*: Window
  WindowDisposeProc* = proc(event: WindowDisposeEvent)

  CloseClickEvent* = ref object
    window*: Window
  CloseClickProc* = proc(event: CloseClickEvent)

  ResizeEvent* = ref object
    window*: Window
  ResizeProc* = proc(event: ResizeEvent)

  DropFilesEvent* = ref object
    window*: Window
    files*: seq[string]
  DropFilesProc* = proc(event: DropFilesEvent)

  KeyboardEvent* = ref object
    window*: Window
    control*: Control
    key*: Key
    unicode*: int
    character*: string # UTF-8 character
    handled*: bool
  KeyboardProc* = proc(event: KeyboardEvent)

  # Control events:

  ControlDisposeEvent* = ref object
    control*: Control
  ControlDisposeProc* = proc(event: ControlDisposeEvent)

  DrawEvent* = ref object
    control*: Control
  DrawProc* = proc(event: DrawEvent)

  MouseEvent* = ref object
    control*: Control
    button*: MouseButton
    x*: int
    y*: int
  MouseButtonProc* = proc(event: MouseEvent)

  ClickEvent* = ref object
    control*: Control
  ClickProc* = proc(event: ClickEvent)

  TextChangeEvent* = ref object
    control*: Control
  TextChangeProc* = proc(event: TextChangeEvent)

  ToggleEvent* = ref object
    control*: Control
  ToggleProc* = proc(event: ToggleEvent)

  # Other events:

  ErrorHandlerProc* = proc()

  TimerEvent* = ref object
    timer*: Timer
    data*: pointer
  TimerProc* = proc(event: TimerEvent)

# Platform-specific extension of Window and Control:
when useWindows(): include "nigui/private/windows/platform_types1"
when useGtk():     include "nigui/private/gtk3/platform_types1"


# ----------------------------------------------------------------------------------------
#                                   Widget Types 2/3
# ----------------------------------------------------------------------------------------

type
  # Basic controls:

  Container* = ref object of ControlImpl
    fFrame: Frame
    fChildControls: seq[Control]

  Frame* = ref object of ControlImpl
    fText: string

  Button* = ref object of ControlImpl
    fText: string
    fEnabled: bool

  Checkbox* = ref object of ControlImpl
    fText: string
    fEnabled: bool
    fOnToggle: ToggleProc

  ComboBox* = ref object of ControlImpl
    fEnabled: bool
    fOptions: seq[string]

  Label* = ref object of ControlImpl
    fText: string
    fXTextAlign: XTextAlign
    fYTextAlign: YTextAlign

  ProgressBar* = ref object of ControlImpl
    fValue: float # should be between 0.0 and 1.0

  TextBox* = ref object of ControlImpl
    fEditable: bool
    fOnTextChange: TextChangeProc


# Platform-specific extension:
when useWindows(): include "nigui/private/windows/platform_types2"
when useGtk():     include "nigui/private/gtk3/platform_types2"


# ----------------------------------------------------------------------------------------
#                                   Widget Types 3/3
# ----------------------------------------------------------------------------------------

type
  LayoutContainer* = ref object of ContainerImpl
    fLayout: Layout
    fXAlign: XAlign
    fYAlign: YAlign
    fPadding: int
    fSpacing: int

  TextArea* = ref object of NativeTextBox
    fWrap: bool

# Platform-specific extension:
when useWindows(): include "nigui/private/windows/platform_types3"
when useGtk():     include "nigui/private/gtk3/platform_types3"


# ----------------------------------------------------------------------------------------
#                                    Global Variables
# ----------------------------------------------------------------------------------------

var
  quitOnLastWindowClose* = true
  clickMaxXYMove* = 20

# dummy type and object, needed to use get/set properties
type App = object
  running*: bool
var app*: App


# ----------------------------------------------------------------------------------------
#                                  Global/App Procedures
# ----------------------------------------------------------------------------------------

proc init*(app: App)

proc run*(app: var App)

proc quit*(app: var App, quitApp: bool = false)

proc processEvents*(app: App)

proc sleep*(app: App, milliSeconds: float)

proc queueMain*(app: App, fn: proc()) ## \
## Queues `fn` to be executed on the GUI thread and returns immediately.
##
## This is the only function that can be safely called from other threads, and it must be called from a `{.gcsafe.}:` block.
## Before a thread that has called this function returns, it should wait for all queued funcitons to be executed:
##
## .. code-block:: nim
##    while app.queued() > 0:
##      discard

proc queued*(app: App): int ## \
## Returns the number of functions queued to be executed on the GUI thread.

proc errorHandler*(app: App): ErrorHandlerProc
proc `errorHandler=`*(app: App, errorHandler: ErrorHandlerProc)

proc defaultBackgroundColor*(app: App): Color
proc `defaultBackgroundColor=`*(app: App, color: Color)

proc defaultTextColor*(app: App): Color
proc `defaultTextColor=`*(app: App, color: Color)

proc defaultFontFamily*(app: App): string
proc `defaultFontFamily=`*(app: App, fontFamily: string)

proc defaultFontSize*(app: App): float
proc `defaultFontSize=`*(app: App, fontSize: float)

proc clipboardText*(app: App): string
proc `clipboardText=`*(app: App, text: string)

proc rgb*(red, green, blue: byte, alpha: byte = 255): Color

proc isDown*(key: Key): bool

proc downKeys*(): seq[Key]

proc scaleToDpi*(val: int): int
proc scaleToDpi*(val: float): float

proc convertLineBreaks*(str: string): string


# ----------------------------------------------------------------------------------------
#                                       Dialogs
# ----------------------------------------------------------------------------------------

proc alert*(window: Window, message: string, title = "Message") {.discardable.}

type OpenFileDialog* = ref object
  title*: string
  directory*: string
  multiple*: bool
  files*: seq[string]

proc newOpenFileDialog*(): OpenFileDialog

method run*(dialog: OpenFileDialog) {.base.}

type SaveFileDialog* = ref object
  title*: string
  directory*: string
  defaultExtension*: string
  defaultName*: string
  file*: string

proc newSaveFileDialog*(): SaveFileDialog

method run*(dialog: SaveFileDialog) {.base.}

type SelectDirectoryDialog* = ref object
  title*: string
  startDirectory*: string
  selectedDirectory*: string

proc newSelectDirectoryDialog*(): SelectDirectoryDialog

method run*(dialog: SelectDirectoryDialog) {.base.}


# ----------------------------------------------------------------------------------------
#                                        Timers
# ----------------------------------------------------------------------------------------

proc startTimer*(milliSeconds: int, timerProc: TimerProc, data: pointer = nil): Timer {.discardable.}

proc startRepeatingTimer*(milliSeconds: int, timerProc: TimerProc, data: pointer = nil): Timer {.discardable.}

proc stop*(timer: var Timer)


# ----------------------------------------------------------------------------------------
#                                        Canvas
# ----------------------------------------------------------------------------------------

proc newCanvas*(control: Control = nil): CanvasImpl

method destroy*(canvas: Canvas) {.base, locks: "unknown".}

method width*(canvas: Canvas): int {.base.}

method height*(canvas: Canvas): int {.base.}

method fontFamily*(canvas: Canvas): string {.base.}
method `fontFamily=`*(canvas: Canvas, fontFamily: string) {.base, locks: "unknown".}

method fontSize*(canvas: Canvas): float {.base.}
method `fontSize=`*(canvas: Canvas, fontSize: float) {.base, locks: "unknown".}

method fontBold*(canvas: Canvas): bool {.base.}
method `fontBold=`*(canvas: Canvas, fontBold: bool) {.base, locks: "unknown".}

method textColor*(canvas: Canvas): Color {.base.}
method `textColor=`*(canvas: Canvas, color: Color) {.base, locks: "unknown".}

method lineColor*(canvas: Canvas): Color {.base.}
method `lineColor=`*(canvas: Canvas, color: Color) {.base, locks: "unknown".}

method lineWidth*(canvas: Canvas): float {.base.}
method `lineWidth=`*(canvas: Canvas, width: float) {.base.}

method areaColor*(canvas: Canvas): Color {.base.}
method `areaColor=`*(canvas: Canvas, color: Color) {.base, locks: "unknown".}

method drawText*(canvas: Canvas, text: string, x, y = 0) {.base.}

method drawTextCentered*(canvas: Canvas, text: string, x, y = 0, width, height = -1) {.base.}

method drawLine*(canvas: Canvas, x1, y1, x2, y2: int) {.base.}

method drawRectArea*(canvas: Canvas, x, y, width, height: int) {.base.}

method drawRectOutline*(canvas: Canvas, x, y, width, height: int) {.base.}

method drawEllipseArea*(canvas: Canvas, x, y, width, height: int) {.base.}

method drawEllipseOutline*(canvas: Canvas, x, y, width, height: int) {.base.}

method drawArcOutline*(canvas: Canvas, centerX, centerY: int, radius, startAngle, sweepAngle: float) {.base.}

method fill*(canvas: Canvas) {.base.}

method drawImage*(canvas: Canvas, image: Image, x, y = 0, width, height = -1) {.base.}

method setPixel*(canvas: Canvas, x, y: int, color: Color) {.base.}

method getTextLineWidth*(canvas: Canvas, text: string): int {.base, locks: "unknown".}

method getTextLineHeight*(canvas: Canvas): int {.base, locks: "unknown".}

method getTextWidth*(canvas: Canvas, text: string): int {.base.}

method interpolationMode*(canvas: Canvas): InterpolationMode {.base.}
method `interpolationMode=`*(canvas: Canvas, mode: InterpolationMode) {.base.}


# ----------------------------------------------------------------------------------------
#                                        Image
# ----------------------------------------------------------------------------------------

proc newImage*(): Image

method resize*(image: Image, width, height: int) {.base.}

method loadFromFile*(image: Image, filePath: string) {.base.}

method saveToBitmapFile*(image: Image, filePath: string) {.base.}

method saveToPngFile*(image: Image, filePath: string) {.base.}

method saveToJpegFile*(image: Image, filePath: string, quality = 80) {.base.}

method width*(image: Image): int {.base.}

method height*(image: Image): int {.base.}

method canvas*(image: Image): Canvas {.base.}

method beginPixelDataAccess*(image: Image): ptr UncheckedArray[byte] {.base.}

method endPixelDataAccess*(image: Image) {.base.}


# ----------------------------------------------------------------------------------------
#                                        Window
# ----------------------------------------------------------------------------------------

proc newWindow*(title: string = ""): Window ## \
## Constructor for a Window object.
## If the title is empty, it will be set to the application filename.

proc init*(window: WindowImpl) ## \
## Initialize a WindowImpl object.
## Only needed for own constructors.

proc dispose*(window: var Window)
method dispose*(window: Window) {.base.}

proc disposed*(window: Window): bool

method visible*(window: Window): bool {.base.}
method `visible=`*(window: Window, visible: bool) {.base.}

method show*(window: Window) {.base.}

method showModal*(window: Window, parent: Window) {.base.}

method hide*(window: Window) {.base.}

method minimized*(window: Window): bool {.base.}
method `minimized=`*(window: Window, minimized: bool) {.base.}

method minimize*(window: Window) {.base.}

method alwaysOnTop*(window: Window): bool {.base.}
method `alwaysOnTop=`*(window: Window, alwaysOnTop: bool) {.base.}

method control*(window: Window): Control {.base.}
method `control=`*(window: Window, control: Control) {.base, locks: "unknown".}

method add*(window: Window, control: Control) {.base.}

method title*(window: Window): string {.base.}
method `title=`*(window: Window, title: string) {.base, locks: "unknown".}

method x*(window: Window): int {.base.}
method `x=`*(window: Window, x: int) {.base, locks: "unknown".}

method y*(window: Window): int {.base.}
method `y=`*(window: Window, y: int) {.base, locks: "unknown".}

method centerOnScreen*(window: Window) {.base, locks: "unknown".}

method width*(window: Window): int {.base.}
method `width=`*(window: Window, width: int) {.base, locks: "unknown".}

method height*(window: Window): int {.base.}
method `height=`*(window: Window, height: int) {.base, locks: "unknown".}

method clientWidth*(window: Window): int {.base.}

method clientHeight*(window: Window): int {.base.}

method iconPath*(window: Window): string {.base.}
method `iconPath=`*(window: Window, iconPath: string) {.base, locks: "unknown".}

method mousePosition*(window: Window): tuple[x, y: int] {.base.} ## \
## Returns the mouse pointer position relative to the given window

method closeClick*(window: Window) {.base.}

method handleResizeEvent*(window: Window, event: ResizeEvent) {.base.}

method handleKeyDownEvent*(window: Window, event: KeyboardEvent) {.base.}

method handleDropFilesEvent*(window: Window, event: DropFilesEvent) {.base.}

method onDispose*(window: Window): WindowDisposeProc {.base.}
method `onDispose=`*(window: Window, callback: WindowDisposeProc) {.base.}

method onCloseClick*(window: Window): CloseClickProc {.base.}
method `onCloseClick=`*(window: Window, callback: CloseClickProc) {.base.}

method onResize*(window: Window): ResizeProc {.base.}
method `onResize=`*(window: Window, callback: ResizeProc) {.base.}

method onDropFiles*(window: Window): DropFilesProc {.base.}
method `onDropFiles=`*(window: Window, callback: DropFilesProc) {.base.}

method onKeyDown*(window: Window): KeyboardProc {.base.}
method `onKeyDown=`*(window: Window, callback: KeyboardProc) {.base.}


# ----------------------------------------------------------------------------------------
#                                       Control
# ----------------------------------------------------------------------------------------

proc newControl*(): Control

proc init*(control: Control)
proc init*(control: ControlImpl)

proc dispose*(control: var Control)
method dispose*(control: Control) {.base.}

proc disposed*(control: Control): bool

method visible*(control: Control): bool {.base.}
method `visible=`*(control: Control, visible: bool) {.base.}
method show*(control: Control) {.base.}
method hide*(control: Control) {.base.}

# Allow the outside to walk over child widgets
method childControls*(control: Control): seq[Control] {.base.}

method parentControl*(control: Control): Control {.base.}

method parentWindow*(control: Control): WindowImpl {.base.}

method width*(control: Control): int {.base.}
# Set the control's width to a fixed value (sets widthMode to fixed)
method `width=`*(control: Control, width: int) {.base.}

method height*(control: Control): int {.base.}
# Set the control's height to a fixed value (sets heightMode to fixed)
method `height=`*(control: Control, height: int) {.base.}

method minWidth*(control: Control): int {.base, locks: "unknown".}
method `minWidth=`*(control: Control, minWidth: int) {.base.}

method minHeight*(control: Control): int {.base, locks: "unknown".}
method `minHeight=`*(control: Control, minHeight: int) {.base.}

method maxWidth*(control: Control): int {.base.}
method `maxWidth=`*(control: Control, maxWidth: int) {.base.}

method maxHeight*(control: Control): int {.base.}
method `maxHeight=`*(control: Control, maxHeight: int) {.base.}

# Set the control's width and height without changing widthMode or heightMode
method setSize*(control: Control, width, height: int) {.base.}

method x*(control: Control): int {.base.}
method `x=`*(control: Control, x: int) {.base.}

method y*(control: Control): int {.base.}
method `y=`*(control: Control, y: int) {.base.}

method setPosition*(control: Control, x, y: int) {.base, locks: "unknown".}

method naturalWidth*(control: Control): int {.base, locks: "unknown".}

method naturalHeight*(control: Control): int {.base, locks: "unknown".}

method wantedWidth*(control: Control): int {.base.}

method wantedHeight*(control: Control): int {.base.}

method mousePosition*(control: Control): tuple[x, y: int] {.base.} ## \
## Returns the mouse pointer position relative to the given control

method focus*(control: Control) {.base.}

method getTextLineWidth*(control: Control, text: string): int {.base, locks: "unknown".}

method getTextLineHeight*(control: Control): int {.base, locks: "unknown".}

method getTextWidth*(control: Control, text: string): int {.base.}

method `widthMode=`*(control: Control, mode: WidthMode) {.base.}
method widthMode*(control: Control): WidthMode {.base.}

method heightMode*(control: Control): HeightMode {.base.}
method `heightMode=`*(control: Control, mode: HeightMode) {.base.}

method visibleWidth*(control: Control): int {.base.}

method visibleHeight*(control: Control): int {.base.}

method xScrollPos*(control: Control): int {.base.}
method `xScrollPos=`*(control: Control, xScrollPos: int) {.base, locks: "unknown".}

method yScrollPos*(control: Control): int {.base.}
method `yScrollPos=`*(control: Control, yScrollPos: int) {.base, locks: "unknown".}

method scrollableWidth*(control: Control): int {.base.}
method `scrollableWidth=`*(control: Control, scrollableWidth: int) {.base.}

method scrollableHeight*(control: Control): int {.base.}
method `scrollableHeight=`*(control: Control, scrollableHeight: int) {.base.}

method fontFamily*(control: Control): string {.base.}
method `fontFamily=`*(control: Control, fontFamily: string) {.base.}
method setFontFamily*(control: Control, fontFamily: string) {.base.}

method fontSize*(control: Control): float {.base.}
method `fontSize=`*(control: Control, fontSize: float) {.base.}
method setFontSize*(control: Control, fontSize: float) {.base, locks: "unknown".}

method fontBold*(control: Control): bool {.base.}
method `fontBold=`*(control: Control, fontBold: bool) {.base.}
method setFontBold*(control: Control, fontBold: bool) {.base, locks: "unknown".}

method backgroundColor*(control: Control): Color {.base.}
method `backgroundColor=`*(control: Control, color: Color) {.base.}
method setBackgroundColor*(control: Control, color: Color) {.base.}
method initStyle*(control: Control) {.base.}

method textColor*(control: Control): Color {.base.}
method `textColor=`*(control: Control, color: Color) {.base.}
method setTextColor*(control: Control, color: Color) {.base.}

method forceRedraw*(control: Control) {.base.}

method canvas*(control: Control): Canvas {.base.}

method handleDrawEvent*(control: Control, event: DrawEvent) {.base.}

method handleMouseButtonDownEvent*(control: Control, event: MouseEvent) {.base.}

method handleMouseButtonUpEvent*(control: Control, event: MouseEvent) {.base.}

method handleClickEvent*(control: Control, event: ClickEvent) {.base.}

method handleKeyDownEvent*(control: Control, event: KeyboardEvent) {.base.}

method onDispose*(control: Control): ControlDisposeProc {.base.}
method `onDispose=`*(control: Control, callback: ControlDisposeProc) {.base.}

method onDraw*(control: Control): DrawProc {.base.}
method `onDraw=`*(control: Control, callback: DrawProc) {.base.}

method onMouseButtonDown*(control: Control): MouseButtonProc {.base.}
method `onMouseButtonDown=`*(control: Control, callback: MouseButtonProc) {.base.}

method onMouseButtonUp*(control: Control): MouseButtonProc {.base.}
method `onMouseButtonUp=`*(control: Control, callback: MouseButtonProc) {.base.}

method onClick*(control: Control): ClickProc {.base.}
method `onClick=`*(control: Control, callback: ClickProc) {.base.}

method onKeyDown*(control: Control): KeyboardProc {.base.}
method `onKeyDown=`*(control: Control, callback: KeyboardProc) {.base.}


# ----------------------------------------------------------------------------------------
#                                      Container
# ----------------------------------------------------------------------------------------

proc newContainer*(): Container

proc init*(container: Container)
proc init*(container: ContainerImpl)

method frame*(container: Container): Frame {.base.}
method `frame=`*(container: Container, frame: Frame) {.base.}

method add*(container: Container, control: Control) {.base.}
method remove*(container: Container, control: Control) {.base, locks: "unknown".}

method getPadding*(container: Container): Spacing {.base.}

method setInnerSize*(container: Container, width, height: int) {.base, locks: "unknown".}


# ----------------------------------------------------------------------------------------
#                                   LayoutContainer
# ----------------------------------------------------------------------------------------

proc newLayoutContainer*(layout: Layout): LayoutContainer

method layout*(container: LayoutContainer): Layout {.base.}
method `layout=`*(container: LayoutContainer, layout: Layout) {.base.}

method xAlign*(container: LayoutContainer): XAlign {.base.}
method `xAlign=`*(container: LayoutContainer, xAlign: XAlign) {.base.}

method yAlign*(container: LayoutContainer): YAlign {.base.}
method `yAlign=`*(container: LayoutContainer, yAlign: YAlign) {.base.}

method padding*(container: LayoutContainer): int {.base.}
method `padding=`*(container: LayoutContainer, padding: int) {.base.}

method spacing*(container: LayoutContainer): int {.base.}
method `spacing=`*(container: LayoutContainer, spacing: int) {.base.}


# ----------------------------------------------------------------------------------------
#                                        Frame
# ----------------------------------------------------------------------------------------

proc newFrame*(text = ""): Frame

proc init*(frame: Frame)
proc init*(frame: NativeFrame)

method text*(frame: Frame): string {.base.}
method `text=`*(frame: Frame, text: string) {.base, locks: "unknown".}

method getPadding*(frame: Frame): Spacing {.base, locks: "unknown".}


# ----------------------------------------------------------------------------------------
#                                        Button
# ----------------------------------------------------------------------------------------

proc newButton*(text = ""): Button

proc init*(button: Button)
proc init*(button: NativeButton)

method text*(button: Button): string {.base.}
method `text=`*(button: Button, text: string) {.base.}

method enabled*(button: Button): bool {.base.}
method `enabled=`*(button: Button, enabled: bool) {.base.}


# ----------------------------------------------------------------------------------------
#                                        Checkbox
# ----------------------------------------------------------------------------------------

proc newCheckbox*(text = ""): Checkbox

proc init*(checkbox: Checkbox)
proc init*(checkbox: NativeCheckbox)

method text*(checkbox: Checkbox): string {.base.}
method `text=`*(checkbox: Checkbox, text: string) {.base.}

method enabled*(checkbox: Checkbox): bool {.base.}
method `enabled=`*(checkbox: Checkbox, enabled: bool) {.base.}

method checked*(checkbox: Checkbox): bool {.base.}

method `checked=`*(checkbox: Checkbox, checked: bool) {.base.}

method onToggle*(checkbox: Checkbox): ToggleProc {.base.}
method `onToggle=`*(checkbox: Checkbox, callback: ToggleProc) {.base.}

method handleToggleEvent*(checkbox: Checkbox, event: ToggleEvent) {.base.}

# ----------------------------------------------------------------------------------------
#                                        Checkbox
# ----------------------------------------------------------------------------------------

proc newComboBox*(options = @[""]): ComboBox

proc init*(comboBox: ComboBox)
proc init*(comboBox: NativeComboBox)

method enabled*(comboBox: ComboBox): bool {.base.}
method `enabled=`*(comboBox: ComboBox, enabled: bool) {.base.}

method options*(comboBox: ComboBox): seq[string] {.base.}
method `options=`*(comboBox: ComboBox, options: seq[string]) {.base.}

method value*(comboBox: ComboBox): string {.base.}
method `value=`*(comboBox: ComboBox, value: string) {.base.}

method index*(comboBox: ComboBox): int {.base.}
method `index=`*(comboBox: ComboBox, index: int) {.base.}


# ----------------------------------------------------------------------------------------
#                                        Label
# ----------------------------------------------------------------------------------------

proc newLabel*(text = ""): Label

proc init*(label: Label)
proc init*(label: NativeLabel)

method text*(label: Label): string {.base.}
method `text=`*(label: Label, text: string) {.base.}

method xTextAlign*(label: Label): XTextAlign {.base.}
method `xTextAlign=`*(label: Label, xTextAlign: XTextAlign) {.base.}

method yTextAlign*(label: Label): YTextAlign {.base.}
method `yTextAlign=`*(label: Label, yTextAlign: YTextAlign) {.base.}


# ----------------------------------------------------------------------------------------
#                                      ProgressBar
# ----------------------------------------------------------------------------------------

proc newProgressBar*(): ProgressBar

proc init*(progressBar: ProgressBar)
proc init*(progressBar: NativeProgressBar)

method value*(progressBar: ProgressBar): float {.base.}
method `value=`*(progressBar: ProgressBar, value: float) {.base.} ## \
## value should be between 0.0 and 1.0


# ----------------------------------------------------------------------------------------
#                                       TextBox
# ----------------------------------------------------------------------------------------

proc newTextBox*(text = ""): TextBox

proc init*(textBox: TextBox)
proc init*(textBox: NativeTextBox)

method text*(textBox: TextBox): string {.base, locks: "unknown".}
method `text=`*(textBox: TextBox, text: string) {.base, locks: "unknown".}

method editable*(textBox: TextBox): bool {.base.}
method `editable=`*(textBox: TextBox, editable: bool) {.base.}

method cursorPos*(textBox: TextBox): int {.base.}
method `cursorPos=`*(textBox: TextBox, cursorPos: int) {.base.}

method selectionStart*(textBox: TextBox): int {.base.}
method `selectionStart=`*(textBox: TextBox, selectionStart: int) {.base.}

method selectionEnd*(textBox: TextBox): int {.base.}
method `selectionEnd=`*(textBox: TextBox, selectionEnd: int) {.base.}

method selectedText*(textBox: TextBox): string {.base.}
method `selectedText=`*(textBox: TextBox, text: string) {.base.}

method handleTextChangeEvent*(textBox: TextBox, event: TextChangeEvent) {.base.}

method onTextChange*(textBox: TextBox): TextChangeProc {.base.}
method `onTextChange=`*(textBox: TextBox, callback: TextChangeProc) {.base.}


# ----------------------------------------------------------------------------------------
#                                      TextArea
# ----------------------------------------------------------------------------------------

proc newTextArea*(text = ""): TextArea

proc init*(textArea: TextArea)
proc init*(textArea: NativeTextArea)

method addText*(textArea: TextArea, text: string) {.base.}
method addLine*(textArea: TextArea, text = "") {.base.}

method scrollToBottom*(textArea: TextArea) {.base.}

method wrap*(textArea: TextArea): bool {.base.}
method `wrap=`*(textArea: TextArea, wrap: bool) {.base.}


# ----------------------------------------------------------------------------------------
#                            Private Procedures Predeclaration
# ----------------------------------------------------------------------------------------

proc raiseError(msg: string)

proc handleException()

proc runMainLoop()

proc platformQuit()

proc init(window: Window)

method destroy(window: Window) {.base.}

proc triggerRelayout(window: Window)

method destroy(control: Control) {.base, locks: "unknown".}

method triggerRelayout(control: Control) {.base.}

method triggerRelayoutDownwards(control: Control) {.base.}

proc triggerRelayoutIfModeIsAuto(control: Control)

method relayout(control: Control, availableWidth, availableHeight: int) {.base.}

method realignChildControls(control: Control) {.base, locks: "unknown".}

method setControlPosition(container: Container, control: Control, x, y: int) {.base.}


# ========================================================================================
#
#                                    Implementation
#
# ========================================================================================

import math
import os
import strutils
import times
import unicode


# ----------------------------------------------------------------------------------------
#                                   Global Variables
# ----------------------------------------------------------------------------------------

const
  defaultDpi = 96
  defaultFontSizeForDefaultDpi = 15.0

var
  fErrorHandler: ErrorHandlerProc = nil
  windowList: seq[Window] = @[]
  fScrollbarSize = -1
  fDownKeys: seq[Key] = @[]
  fSystemDpi = defaultDpi

  # Default style:
  fDefaultBackgroundColor: Color # initialized by platform-specific init()
  fDefaultTextColor: Color # initialized by platform-specific init()
  fDefaultFontFamily = ""
  fDefaultFontSize = defaultFontSizeForDefaultDpi


# ----------------------------------------------------------------------------------------
#                                  Global/App Procedures
# ----------------------------------------------------------------------------------------

proc raiseError(msg: string) =
  raise newException(Exception, msg)

proc defaultExceptionHandler() =
  let msg = getCurrentExceptionMsg() & "\p\p" & getStackTrace()
  alert(nil, msg, "Error")
  echo "Error: unhandled exception: ", msg
  quit()

proc handleException() =
  ## Handle an exception raised in runMainLoop().
  ## This is called directly from the Gtk part.
  if fErrorHandler == nil:
    defaultExceptionHandler()
  else:
    fErrorHandler()

proc rgb(red, green, blue: byte, alpha: byte = 255): Color =
  result.red = red
  result.green = green
  result.blue = blue
  result.alpha = alpha

proc sleep(app: App, milliSeconds: float) =
  let t = epochTime() + milliSeconds / 1000
  while epochTime() < t:
    app.processEvents()
    os.sleep(20)

proc run(app: var App) =
  app.running = true
  while app.running:
    try:
      runMainLoop()
      break
    except:
      handleException()

proc quit(app: var App, quitApp: bool = false) =
  platformQuit()
  app.running = false
  if quitApp:
    quit()

proc errorHandler(app: App): ErrorHandlerProc = fErrorHandler

proc `errorHandler=`(app: App, errorHandler: ErrorHandlerProc) = fErrorHandler = errorHandler

proc defaultBackgroundColor(app: App): Color = fDefaultBackgroundColor

proc updateBackgroundColor(control: Control) =
  if control.fUseDefaultBackgroundColor and control.backgroundColor != fDefaultBackgroundColor:
    control.setBackgroundColor(fDefaultBackgroundColor)
  for child in control.childControls:
    child.updateBackgroundColor()

proc `defaultBackgroundColor=`(app: App, color: Color) =
  fDefaultBackgroundColor = color
  for window in windowList:
    let control = window.control
    if control != nil:
      control.updateBackgroundColor()

proc defaultTextColor(app: App): Color = fDefaultTextColor

proc updateTextColor(control: Control) =
  if control.fUseDefaultTextColor and control.textColor != fDefaultTextColor:
    control.setTextColor(fDefaultTextColor)
  for child in control.childControls:
    child.updateTextColor()

proc `defaultTextColor=`(app: App, color: Color) =
  fDefaultTextColor = color
  for window in windowList:
    let control = window.control
    if control != nil:
      control.updateTextColor()

proc defaultFontFamily(app: App): string = fDefaultFontFamily

proc updateFontFamily(control: Control) =
  if control.fUseDefaultFontFamily and control.fontFamily != fDefaultFontFamily:
    control.setFontFamily(fDefaultFontFamily)
  for child in control.childControls:
    child.updateFontFamily()

proc `defaultFontFamily=`(app: App, fontFamily: string) =
  fDefaultFontFamily = fontFamily
  for window in windowList:
    let control = window.control
    if control != nil:
      control.updateFontFamily()

proc defaultFontSize(app: App): float = fDefaultFontSize

proc updateFontSize(control: Control) =
  if control.fUseDefaultFontSize and control.fontSize != fDefaultFontSize:
    control.setFontSize(fDefaultFontSize)
  for child in control.childControls:
    child.updateFontSize()

proc `defaultFontSize=`(app: App, fontSize: float) =
  fDefaultFontSize = fontSize
  for window in windowList:
    let control = window.control
    if control != nil:
      control.updateFontSize()

proc newOpenFileDialog(): OpenFileDialog =
  result = new OpenFileDialog
  result.title = "Open File"
  result.directory = getCurrentDir()
  result.files = @[]

proc newSaveFileDialog(): SaveFileDialog =
  result = new SaveFileDialog
  result.title = "Save File"
  result.directory = getCurrentDir()

proc newSelectDirectoryDialog(): SelectDirectoryDialog =
  result = new SelectDirectoryDialog
  result.title = "Select a Folder"
  result.startDirectory = getCurrentDir()

proc isDown(key: Key): bool = fDownKeys.contains(key)

proc downKeys(): seq[Key] = fDownKeys

proc scaleToDpi(val: int): int = (val * fSystemDpi) div defaultDpi
proc scaleToDpi(val: float): float = val * fSystemDpi.float / defaultDpi.float

proc convertLineBreaks(str: string): string =
  ## Converts \\n line breaks (LF) to \\p line breaks (CRLF on Windows)
  when useWindows():
    for i in 0..str.high:
      let curr = str[i]
      if curr == '\n' and (i == 0 or str[i - 1] != '\r'):
        result.add("\p")
      else:
        result.add(curr)
  else:
    result = str

proc internalKeyDown(key: Key) =
  if not fDownKeys.contains(key):
    fDownKeys.add(key)

proc internalKeyUp(key: Key) =
  let i = fDownKeys.find(key)
  if i != -1:
    fDownKeys.delete(i)

proc internalAllKeysUp() =
  fDownKeys = @[]


# ----------------------------------------------------------------------------------------
#                                       Canvas
# ----------------------------------------------------------------------------------------

proc newCanvas(control: Control = nil): CanvasImpl =
  result = new CanvasImpl
  result.fLineColor = rgb(0, 0, 0)
  result.fLineWidth = 1
  result.fAreaColor = rgb(0, 0, 0)
  if control == nil:
    result.fFontFamily = app.defaultFontFamily
    result.fFontSize = app.defaultFontSize
    result.fTextColor = app.defaultTextColor
  else:
    result.fFontFamily = control.fontFamily
    result.fFontSize = control.fontSize
    result.fTextColor = control.textColor
    result.fWidth = control.width
    result.fHeight = control.height
    control.fCanvas = result

method destroy(canvas: Canvas) = discard

method width(canvas: Canvas): int = canvas.fWidth

method height(canvas: Canvas): int= canvas.fHeight

method fontFamily(canvas: Canvas): string = canvas.fFontFamily

method `fontFamily=`(canvas: Canvas, fontFamily: string) = canvas.fFontFamily = fontFamily

method fontSize(canvas: Canvas): float = canvas.fFontSize

method `fontSize=`(canvas: Canvas, fontSize: float) = canvas.fFontSize = fontSize

method fontBold(canvas: Canvas): bool = canvas.fFontBold

method `fontBold=`(canvas: Canvas, fontBold: bool) = canvas.fFontBold = fontBold

method textColor(canvas: Canvas): Color = canvas.fTextColor

method `textColor=`(canvas: Canvas, color: Color) = canvas.fTextColor = color

method lineColor(canvas: Canvas): Color = canvas.fLineColor

method `lineColor=`(canvas: Canvas, color: Color) = canvas.fLineColor = color

method lineWidth(canvas: Canvas): float = canvas.fLineWidth

method `lineWidth=`(canvas: Canvas, width: float) = canvas.fLineWidth = width

method areaColor(canvas: Canvas): Color = canvas.fAreaColor

method `areaColor=`(canvas: Canvas, color: Color) = canvas.fAreaColor = color

method getTextLineWidth(canvas: Canvas, text: string): int =
  result = text.len * 7
  # should be overrriden by CanvasImpl

method getTextLineHeight(canvas: Canvas): int =
  result = 20
  # should be overrriden by CanvasImpl

method getTextWidth(canvas: Canvas, text: string): int =
  result = 0
  for line in text.splitLines:
    result = max(result, canvas.getTextLineWidth(line))

method drawTextCentered(canvas: Canvas, text: string, x, y = 0, width, height = -1) =
  var w = width
  if w == -1:
    w = canvas.width
  var h = height
  if h == -1:
    h = canvas.height
  let rx = x + max((w - canvas.getTextWidth(text)) div 2, 0)
  let ry = y + max((h - canvas.getTextLineHeight() * text.countLines) div 2, 0)
  canvas.drawText(text, rx, ry)

method fill(canvas: Canvas) = canvas.drawRectArea(0, 0, canvas.width, canvas.height)

method interpolationMode(canvas: Canvas): InterpolationMode = canvas.fInterpolationMode

method `interpolationMode=`(canvas: Canvas, mode: InterpolationMode) = canvas.fInterpolationMode = mode


# ----------------------------------------------------------------------------------------
#                                        Image
# ----------------------------------------------------------------------------------------

proc newImage(): Image =
  result = new ImageImpl
  result.fCanvas = newCanvas()

method width(image: Image): int = image.canvas.width

method height(image: Image): int = image.canvas.height

method canvas(image: Image): Canvas = image.fCanvas


# ----------------------------------------------------------------------------------------
#                                        Window
# ----------------------------------------------------------------------------------------

proc newWindow(title: string = ""): Window =
  result = new WindowImpl
  result.WindowImpl.init()
  if title != "":
    result.title = title


proc init(window: Window) =
  window.fVisible = false
  window.fWidth = 640 # do not trigger resize
  window.height = 480 # trigger resize
  window.fX = -1 # window will be centered on screen
  window.fY = -1
  window.title = getAppFilename().extractFilename().changeFileExt("")
  var defaultIconPath = getAppFilename().changeFileExt("") & ".png"
  if defaultIconPath.fileExists():
    window.iconPath = defaultIconPath
  windowList.add(window)
  window.triggerRelayout()

method destroy(window: Window) =
  if window.fControl != nil:
    window.fControl.dispose()
  # should be extended by WindowImpl

proc dispose(window: var Window) =
  let w = window
  w.dispose() # force calling "dispose(window: Window)" instead of itself
  window = nil

method dispose(window: Window) =
  let callback = window.onDispose
  if callback != nil:
    var event = new WindowDisposeEvent
    event.window = window
    callback(event)
  window.destroy()
  let i = windowList.find(window)
  windowList.delete(i)
  if quitOnLastWindowClose and windowList.len == 0:
    app.quit()
  window.fDisposed = true

proc disposed(window: Window): bool = window == nil or window.fDisposed

method title(window: Window): string = window.fTitle

method `title=`(window: Window, title: string) = window.fTitle = title

method control(window: Window): Control = window.fControl

method `control=`(window: Window, control: Control) =
  window.fControl = control
  control.fParentWindow = window
  # should be extended by WindowImpl

method add(window: Window, control: Control) =
  if window.control != nil:
    raiseError("Window can have only one control.")
  window.control = control

method visible(window: Window): bool = window.fVisible

method `visible=`(window: Window, visible: bool) =
  window.fVisible = visible
  if visible:
    window.fMinimized = false
  if window.x == -1 or window.y == -1:
    window.centerOnScreen()
  # should be extended by WindowImpl

method show(window: Window) = window.visible = true

method showModal(window: Window, parent: Window) =
  window.visible = true
  # should be extended by WindowImpl

method hide(window: Window) = window.visible = false

method minimized(window: Window): bool = window.fMinimized

method `minimized=`(window: Window, minimized: bool) =
  if minimized:
    window.minimize()
  else:
    window.show()

method minimize(window: Window) =
  window.fMinimized = true
  # should be extended by WindowImpl

method alwaysOnTop(window: Window): bool = window.fAlwaysOnTop

method `alwaysOnTop=`(window: Window, alwaysOnTop: bool) =
  window.fAlwaysOnTop = alwaysOnTop
  # should be extended by WindowImpl

method x(window: Window): int = window.fX

method `x=`(window: Window, x: int) =
  window.fX = x
  # should be extended by WindowImpl

method y(window: Window): int = window.fY

method `y=`(window: Window, y: int) =
  window.fY = y
  # should be extended by WindowImpl

method centerOnScreen(window: Window) =
  discard # has to be implemented in WindowImpl

method width(window: Window): int = window.fWidth

method height(window: Window): int = window.fHeight

method `width=`(window: Window, width: int) =
  window.fWidth = width
  # has to be extended by WindowImpl

method `height=`(window: Window, height: int) =
  window.fHeight = height
  # has to be extended by WindowImpl

method clientWidth(window: Window): int = window.fClientWidth

method clientHeight(window: Window): int = window.fClientHeight

proc triggerRelayout(window: Window) =
  if window.control == nil:
    return
  # echo ""
  # echo "WindowImpl:triggerRelayout()"
  # echo "window size: " & $window.clientWidth & ", " & $window.clientHeight
  window.control.relayout(window.clientWidth, window.clientHeight)

method iconPath(window: Window): string = window.fIconPath

method `iconPath=`(window: Window, iconPath: string) =
  window.fIconPath = iconPath
  # should be extended by WindowImpl

method closeClick(window: Window) =
  # can be overriden by custom window
  let callback = window.onCloseClick
  if callback != nil:
    var event = new CloseClickEvent
    event.window = window
    callback(event)
  else:
    window.dispose() # default action

method handleResizeEvent(window: Window, event: ResizeEvent) =
  # can be overriden by custom window
  let callback = window.onResize
  if callback != nil:
    callback(event)

method handleDropFilesEvent(window: Window, event: DropFilesEvent) =
  # can be overriden by custom window
  let callback = window.onDropFiles
  if callback != nil:
    callback(event)

method handleKeyDownEvent(window: Window, event: KeyboardEvent) =
  # can be overriden by custom window
  let callback = window.onKeyDown
  if callback != nil:
    callback(event)

method onDispose(window: Window): WindowDisposeProc = window.fOnDispose
method `onDispose=`(window: Window, callback: WindowDisposeProc) = window.fOnDispose = callback

method onCloseClick(window: Window): CloseClickProc = window.fOnCloseClick
method `onCloseClick=`(window: Window, callback: CloseClickProc) = window.fOnCloseClick = callback

method onResize(window: Window): ResizeProc = window.fOnResize
method `onResize=`(window: Window, callback: ResizeProc) = window.fOnResize = callback

method onDropFiles(window: Window): DropFilesProc = window.fOnDropFiles
method `onDropFiles=`(window: Window, callback: DropFilesProc) = window.fOnDropFiles = callback

method onKeyDown(window: Window): KeyboardProc = window.fOnKeyDown
method `onKeyDown=`(window: Window, callback: KeyboardProc) = window.fOnKeyDown = callback



# ----------------------------------------------------------------------------------------
#                                       Control
# ----------------------------------------------------------------------------------------

proc newControl(): Control =
  result = new ControlImpl
  result.ControlImpl.init()

proc init(control: Control) =
  control.fWidthMode = WidthMode_Static
  control.fHeightMode = HeightMode_Static
  control.fWidth = 50.scaleToDpi
  control.fheight = 50.scaleToDpi
  control.fScrollableWidth = -1
  control.fScrollableHeight = -1
  control.initStyle()
  control.show()
  # should be extended by ControlImpl

method destroy(control: Control) =
  discard # nothing to do here
  # should be extended by ControlImpl

proc dispose(control: var Control) =
  let c = control
  c.dispose() # force calling "dispose(control: Control)" instead of itself
  control = nil

method dispose(control: Control) =
  let callback = control.onDispose
  if callback != nil:
    var event = new ControlDisposeEvent
    event.control = control
    callback(event)
  control.destroy()
  control.fDisposed = true

proc disposed(control: Control): bool = control == nil or control.fDisposed

method visible(control: Control): bool = control.fVisible

method `visible=`(control: Control, visible: bool) =
  control.fVisible = visible
  control.triggerRelayout()
  # should be extended by ControlImpl

method show(control: Control) = control.visible = true

method hide(control: Control) = control.visible = false

method width(control: Control): int = control.fWidth

method height(control: Control): int = control.fHeight

method `width=`(control: Control, width: int) =
  control.setSize(width, control.fHeight)
  control.widthMode = WidthMode_Static

method `height=`(control: Control, height: int) =
  control.setSize(control.fWidth, height)
  control.heightMode = HeightMode_Static

method minWidth(control: Control): int = control.fMinWidth

method `minWidth=`(control: Control, minWidth: int) =
  control.fMinWidth = minWidth
  control.triggerRelayout()

method minHeight(control: Control): int = control.fMinHeight

method `minHeight=`(control: Control, minHeight: int) =
  control.fMinHeight = minHeight
  control.triggerRelayout()

method maxWidth(control: Control): int = control.fMaxWidth

method `maxWidth=`(control: Control, maxWidth: int) =
  control.fMaxWidth = maxWidth
  control.triggerRelayout()

method maxHeight(control: Control): int = control.fMaxHeight

method `maxHeight=`(control: Control, maxHeight: int) =
  control.fMaxHeight = maxHeight
  control.triggerRelayout()

method setSize(control: Control, width, height: int) =
  control.fWidth = width
  control.fHeight = height
  if control.canvas != nil:
    control.canvas.fWidth = width
    control.canvas.fHeight = height
  control.realignChildControls()
  # should be extended by ControlImpl

method setSize(control: ControlImpl, width, height: int) # required pre declaration

method `x=`(control: Control, x: int) =
  if control.fParentControl == nil:
    raiseError("Control cannot be moved, when it is not inside a container.")
  cast[Container](control.fParentControl).setControlPosition(control, x, control.y)

method x(control: Control): int = control.fX

method `y=`(control: Control, y: int) =
  if control.fParentControl == nil:
    raiseError("Control cannot be moved, when it is not inside a container.")
  cast[Container](control.fParentControl).setControlPosition(control, control.x, y)

method y(control: Control): int = control.fY

method setPosition(control: Control, x, y: int) =
  control.fX = x
  control.fY = y
  # should be extended by ControlImpl

method naturalWidth(control: Control): int = control.width

method naturalHeight(control: Control): int = control.height

method wantedWidth(control: Control): int =
  if control.widthMode == WidthMode_Static:
    result = control.width
  else:
    result = control.naturalWidth
  if result != -1 and control.minWidth > result:
    result = control.minWidth
  if control.maxWidth > 0 and control.maxWidth < result:
    result = control.maxWidth

method wantedHeight(control: Control): int =
  if control.heightMode == HeightMode_Static:
    result = control.height
  else:
    result = control.naturalHeight
  if result != -1 and control.minHeight > result:
    result = control.minHeight
  if control.maxHeight > 0 and control.maxHeight < result:
    result = control.maxHeight

method `widthMode=`(control: Control, mode: WidthMode) =
  control.fWidthMode = mode
  control.triggerRelayout()

method `heightMode=`(control: Control, mode: HeightMode) =
  control.fHeightMode = mode
  control.triggerRelayout()

method widthMode(control: Control): WidthMode = control.fWidthMode

method heightMode(control: Control): HeightMode = control.fHeightMode

method childControls(control: Control): seq[Control] = @[]

method parentControl(control: Control): Control = control.fParentControl

method parentWindow(control: Control): WindowImpl =
  if control.fParentControl == nil:
    result = cast[WindowImpl](control.fParentWindow)
  else:
    result = control.parentControl.parentWindow

method triggerRelayout(control: Control) =
  var con = control
  while con.parentControl != nil:
    con = con.parentControl
  if con.parentWindow != nil:
    con.parentWindow.triggerRelayout()
  if control.parentControl != nil:
    control.parentControl.triggerRelayout()
  control.realignChildControls()

method triggerRelayoutDownwards(control: Control) =
  control.triggerRelayout()

proc triggerRelayoutIfModeIsAuto(control: Control) =
  if control.widthMode == WidthMode_Auto or control.heightMode == HeightMode_Auto:
    control.triggerRelayout()

method relayout(control: Control, availableWidth, availableHeight: int) =
  # echo ""
  # echo control.tag & ".relayout(): "
  # echo "  available size: " & $availableWidth & ", " & $availableHeight
  var width = control.width
  var height = control.height
  var sizeChanged = false
  if control.widthMode == WidthMode_Auto:
    let naturalWidth = control.naturalWidth
    # echo "  naturalWidth: " & $naturalWidth
    if naturalWidth == -1:
      width = availableWidth
    else:
      width = min(availableWidth, naturalWidth)
    sizeChanged = true
  elif control.widthMode in {WidthMode_Expand, WidthMode_Fill}:
    width = availableWidth
    sizeChanged = true
  if control.heightMode == HeightMode_Auto:
    let naturalHeight = control.naturalHeight
    # echo "  naturalHeight: " & $naturalHeight
    if naturalHeight == -1:
      height = availableHeight
    else:
      height = min(availableHeight, naturalHeight)
    sizeChanged = true
  elif control.heightMode in {HeightMode_Expand, HeightMode_Fill}:
    height = availableHeight
    sizeChanged = true
  if sizeChanged:
    # echo "  new size: " & $width & ", " & $height
    control.setSize(width, height)

method realignChildControls(control: Control) = discard

method focus(control: Control) =
  discard
  # should be overrriden by ControlImpl

method getTextLineWidth(control: Control, text: string): int =
  result = text.len * 7
  # should be overrriden by ControlImpl

method getTextLineHeight(control: Control): int =
  result = 20
  # should be overrriden by ControlImpl

method getTextWidth(control: Control, text: string): int =
  result = 0
  for line in text.splitLines:
    result = max(result, control.getTextLineWidth(line))

method xScrollbarSpace(control: Control): int {.base.} =
  if control.fYScrollEnabled:
    result.inc(fScrollbarSize)

method yScrollbarSpace(control: Control): int {.base.} =
  if control.fXScrollEnabled:
    result.inc(fScrollbarSize)

method visibleWidth(control: Control): int =
  result = control.width - control.xScrollbarSpace

method visibleHeight(control: Control): int =
  result = control.height - control.yScrollbarSpace

method xScrollPos(control: Control): int = control.fXScrollPos

method `xScrollPos=`(control: Control, xScrollPos: int) =
  control.fXScrollPos = xScrollPos

method yScrollPos(control: Control): int = control.fYScrollPos

method `yScrollPos=`(control: Control, yScrollPos: int) =
  control.fYScrollPos = yScrollPos

method scrollableWidth(control: Control): int = control.fScrollableWidth

method `scrollableWidth=`(control: Control, scrollableWidth: int) =
  control.fScrollableWidth = scrollableWidth

method scrollableHeight(control: Control): int = control.fScrollableHeight

method `scrollableHeight=`(control: Control, scrollableHeight: int) =
  control.fScrollableHeight = scrollableHeight

method fontFamily(control: Control): string = control.fFontFamily

method `fontFamily=`(control: Control, fontFamily: string) =
  control.setFontFamily(fontFamily)
  control.fUseDefaultFontFamily = false
  control.triggerRelayoutIfModeIsAuto()

method setFontFamily(control: Control, fontFamily: string) =
  control.fFontFamily = fontFamily
  control.triggerRelayoutIfModeIsAuto()
  # should be extended by ControlImpl

method fontSize(control: Control): float = control.fFontSize

method `fontSize=`(control: Control, fontSize: float) =
  control.setFontSize(fontSize)
  control.fUseDefaultFontSize = false
  control.triggerRelayoutIfModeIsAuto()

method setFontSize(control: Control, fontSize: float) =
  control.fFontSize = fontSize
  # should be extended by ControlImpl

method fontBold(control: Control): bool = control.fFontBold

method `fontBold=`(control: Control, fontBold: bool) =
  control.setFontBold(fontBold)
  control.triggerRelayoutIfModeIsAuto()

method setFontBold(control: Control, fontBold: bool) =
  control.fFontBold = fontBold
  # should be extended by ControlImpl

method backgroundColor(control: Control): Color = control.fBackgroundColor

method `backgroundColor=`(control: Control, color: Color) =
  control.setBackgroundColor(color)
  control.fUseDefaultBackgroundColor = false

method setBackgroundColor(control: Control, color: Color) =
  control.fBackgroundColor = color
  control.forceRedraw()
  # should be extended by ControlImpl

method initStyle(control: Control) =
  control.fBackgroundColor = fDefaultBackgroundColor
  control.fTextColor = fDefaultTextColor
  control.setFontFamily(fDefaultFontFamily)
  control.setFontSize(app.defaultFontSize)
  control.fUseDefaultBackgroundColor = true
  control.fUseDefaultTextColor = true
  control.fUseDefaultFontFamily = true
  control.fUseDefaultFontSize = true
  control.triggerRelayoutIfModeIsAuto()

method textColor(control: Control): Color = control.fTextColor

method `textColor=`(control: Control, color: Color) =
  control.setTextColor(color)
  control.fUseDefaultTextColor = false

method setTextColor(control: Control, color: Color) =
  control.fTextColor = color
  control.forceRedraw()
  # should be extended by ControlImpl

method forceRedraw(control: Control) =
  discard
  # should be implemented by ControlImpl

method canvas(control: Control): Canvas = control.fCanvas

method handleDrawEvent(control: Control, event: DrawEvent) =
  # can be overridden by custom control
  let callback = control.onDraw
  if callback != nil:
    callback(event)

method handleMouseButtonDownEvent(control: Control, event: MouseEvent) =
  # can be overridden by custom control
  let callback = control.onMouseButtonDown
  if callback != nil:
    callback(event)

method handleMouseButtonUpEvent(control: Control, event: MouseEvent) =
  # can be overridden by custom control
  let callback = control.onMouseButtonUp
  if callback != nil:
    callback(event)

method handleClickEvent(control: Control, event: ClickEvent) =
  # can be overridden by custom button
  let callback = control.onClick
  if callback != nil:
    callback(event)

method handleKeyDownEvent(control: Control, event: KeyboardEvent) =
  # can be overridden by custom control
  let callback = control.onKeyDown
  if callback != nil:
    callback(event)

method onDispose(control: Control): ControlDisposeProc = control.fOnDispose
method `onDispose=`(control: Control, callback: ControlDisposeProc) = control.fOnDispose = callback

method onDraw(control: Control): DrawProc = control.fOnDraw
method `onDraw=`(control: Control, callback: DrawProc) = control.fOnDraw = callback

method onMouseButtonDown(control: Control): MouseButtonProc = control.fOnMouseButtonDown
method `onMouseButtonDown=`(control: Control, callback: MouseButtonProc) = control.fOnMouseButtonDown = callback

method onMouseButtonUp(control: Control): MouseButtonProc = control.fOnMouseButtonUp
method `onMouseButtonUp=`(control: Control, callback: MouseButtonProc) = control.fOnMouseButtonUp = callback

method onClick(control: Control): ClickProc = control.fOnClick
method `onClick=`(control: Control, callback: ClickProc) = control.fOnClick = callback

method onKeyDown(control: Control): KeyboardProc = control.fOnKeyDown
method `onKeyDown=`(control: Control, callback: KeyboardProc) = control.fOnKeyDown = callback


# ----------------------------------------------------------------------------------------
#                                      Container
# ----------------------------------------------------------------------------------------

proc newContainer(): Container =
  result = new ContainerImpl
  result.ContainerImpl.init()

proc init(container: Container) =
  container.fChildControls = @[]
  container.ControlImpl.init()
  container.fWidthMode = WidthMode_Auto
  container.fHeightMode = HeightMode_Auto

method frame(container: Container): Frame = container.fFrame

method `frame=`(container: Container, frame: Frame) =
  if frame.fParentControl != nil:
    raiseError("Frame can be assigned only to one container.")
  container.fFrame = frame
  if frame != nil:
    frame.fParentControl = container
    container.tag = frame.tag
  container.triggerRelayout()
  if container.frame != nil:
    container.frame.setSize(container.width, container.height)
  # should be extended by NativeFrame

method setSize(container: Container, width, height: int) =
  procCall container.ControlImpl.setSize(width, height)
  if container.frame != nil:
    container.frame.setSize(width, height)

method childControls(container: Container): seq[Control] = container.fChildControls

method add(container: Container, control: Control) =
  if control.fParentControl != nil:
    raiseError("Control can be added only to one container.")
  container.fChildControls.add(control)
  control.fParentControl = container
  control.fIndex = container.fChildControls.high
  container.triggerRelayout()

method remove(container: Container, control: Control) =
  if cast[Control](container) != control.fParentControl:
    raiseError("control can not be removed because it is not member of the container")
  else:
    let startIndex = control.fIndex
    container.fChildControls.delete(startIndex)
    for i in startIndex..container.childControls.high:
      container.childControls[i].fIndex = i
    container.triggerRelayout()
    control.fParentControl = nil

method setControlPosition(container: Container, control: Control, x, y: int) =
  control.setPosition(x, y)
  container.triggerRelayout()

method minWidth(container: Container): int =
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    result = max(result, control.x + control.minWidth)
  let padding = container.getPadding()
  result.inc(padding.left)
  result.inc(padding.right)
  result.inc(container.xScrollbarSpace)
  result = max(result, container.fMinWidth)

method minHeight(container: Container): int =
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    result = max(result, control.y + control.minHeight)
  let padding = container.getPadding()
  result.inc(padding.top)
  result.inc(padding.bottom)
  result.inc(container.yScrollbarSpace)
  result = max(result, container.fMinHeight)

method naturalWidth(container: Container): int =
  if container.widthMode == WidthMode_Static:
    return container.width
  if container.widthMode == WidthMode_Expand:
    return -1
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    if control.widthMode == WidthMode_Expand:
      return -1
    result = max(result, control.x + control.wantedWidth)
  let padding = container.getPadding()
  result.inc(padding.left)
  result.inc(padding.right)
  result.inc(container.xScrollbarSpace)
  if container.frame != nil and container.frame.visible:
    result = max(result, container.frame.naturalWidth)

method naturalHeight(container: Container): int =
  if container.heightMode == HeightMode_Static:
    return container.height
  if container.heightMode == HeightMode_Expand:
    return -1
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    if control.heightMode == HeightMode_Expand:
      return -1
    result = max(result, control.y + control.wantedHeight)
  let padding = container.getPadding()
  result.inc(padding.top)
  result.inc(padding.bottom)
  result.inc(container.yScrollbarSpace)

method getPadding(container: Container): Spacing =
  if container.frame != nil and container.frame.visible:
    result = container.frame.getPadding()

method setInnerSize(container: Container, width, height: int) = discard
  # should be extended by ContainerImpl

method updateInnerSize(container: Container, pInnerWidth, pInnerHeight: int) {.base.} =
  let padding = container.getPadding()
  let clientWidth = container.visibleWidth - padding.left - padding.right
  let clientHeight = container.visibleHeight - padding.top - padding.bottom
  var innerWidth = pInnerWidth
  var innerHeight = pInnerHeight

  discard """ container.xScrollEnabled = innerWidth > clientWidth

  if container.xScrollEnabled and innerHeight + 20 > clientHeight:
    innerHeight.inc(20) # Space for scrollbar
    container.yScrollEnabled = true
  else:
    container.yScrollEnabled = innerHeight > clientHeight
    if container.yScrollEnabled and innerWidth + 20 > clientWidth:
      innerWidth.inc(20) # Space for scrollbar
      container.xScrollEnabled = true """

  # TODO: rework

  innerWidth = max(innerWidth, clientWidth)
  innerHeight = max(innerHeight, clientHeight)

  container.scrollableWidth = innerWidth
  container.scrollableHeight = innerHeight

  container.setInnerSize(innerWidth, innerHeight)

method realignChildControls(container: Container) =
  let padding = container.getPadding()
  var innerWidth = container.wantedWidth
  var innerHeight = container.wantedHeight
  if innerWidth == -1:
    innerWidth = container.width
  if innerHeight == -1:
    innerHeight = container.height
  container.updateInnerSize(innerWidth - padding.left - padding.right - container.xScrollbarSpace, innerHeight - padding.top - padding.bottom - container.yScrollbarSpace)

  for control in container.fChildControls:
    if not control.visible:
      continue
    control.relayout(container.width, container.height)

method triggerRelayoutDownwards(container: Container) =
  for control in container.childControls:
    control.triggerRelayoutDownwards()


# ----------------------------------------------------------------------------------------
#                                   LayoutContainer
# ----------------------------------------------------------------------------------------

proc newLayoutContainer(layout: Layout): LayoutContainer =
  result = new LayoutContainer
  result.init()
  result.layout = layout
  result.xAlign = XAlign_Left
  result.yAlign = YAlign_Top
  result.spacing = 4.scaleToDpi
  result.padding = 2.scaleToDpi

method naturalWidth(container: LayoutContainer): int =
  # echo container.tag & ".naturalWidth"
  if container.widthMode == WidthMode_Static:
    return container.width
  if container.widthMode == WidthMode_Expand:
    return -1
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    if control.widthMode == WidthMode_Expand or control.wantedWidth == -1:
      return -1
    if container.layout == Layout_Horizontal:
      result.inc(control.wantedWidth)
    else:
      result = max(result, control.wantedWidth)
  let padding = container.getPadding()
  result.inc(padding.left)
  result.inc(padding.right)
  result.inc(container.padding * 2)
  if container.layout == Layout_Horizontal and container.childControls.len > 1:
    result.inc(container.spacing * (container.childControls.len - 1))
  result.inc(container.xScrollbarSpace)
  if container.frame != nil and container.frame.visible:
    result = max(result, container.frame.naturalWidth)

method naturalHeight(container: LayoutContainer): int =
  if container.heightMode == HeightMode_Static:
    return container.height
  if container.heightMode == HeightMode_Expand:
    return -1
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    if control.heightMode == HeightMode_Expand or control.wantedHeight == -1:
      return -1
    if container.layout == Layout_Vertical:
      result.inc(control.wantedHeight)
    else:
      result = max(result, control.wantedHeight)
  let padding = container.getPadding()
  result.inc(padding.top)
  result.inc(padding.bottom)
  result.inc(container.padding * 2)
  result.inc(container.yScrollbarSpace)
  if container.layout == Layout_Vertical and container.childControls.len > 1:
    result.inc(container.spacing * (container.childControls.len - 1))

method minWidth(container: LayoutContainer): int =
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    if container.layout == Layout_Horizontal:
      result.inc(control.minWidth)
    else:
      result = max(result, control.minWidth)
  let padding = container.getPadding()
  result.inc(padding.left)
  result.inc(padding.right)
  result.inc(container.padding * 2)
  if container.layout == Layout_Horizontal and container.childControls.len > 1:
    result.inc(container.spacing * (container.childControls.len - 1))
  result.inc(container.xScrollbarSpace)
  result = max(result, container.fMinWidth)

method minHeight(container: LayoutContainer): int =
  result = 0
  for control in container.childControls:
    if not control.visible:
      continue
    if container.layout == Layout_Vertical:
      result.inc(control.minHeight)
    else:
      result = max(result, control.minHeight)
  let padding = container.getPadding()
  result.inc(padding.top)
  result.inc(padding.bottom)
  result.inc(container.padding * 2)
  if container.layout == Layout_Vertical and container.childControls.len > 1:
    result.inc(container.spacing * (container.childControls.len - 1))
  result.inc(container.yScrollbarSpace)
  result = max(result, container.fMinHeight)

method setControlPosition(container: LayoutContainer, control: Control, x, y: int) {.locks: "unknown".} =
  raiseError("Controls inside a LayoutContainer cannot be moved manually.")

method layout(container: LayoutContainer): Layout = container.fLayout

method `layout=`(container: LayoutContainer, layout: Layout) =
  container.fLayout = layout
  container.triggerRelayout()

method xAlign(container: LayoutContainer): XAlign = container.fXAlign

method `xAlign=`(container: LayoutContainer, xAlign: XAlign) =
  container.fXAlign = xAlign
  container.realignChildControls()

method yAlign(container: LayoutContainer): YAlign = container.fYAlign

method `yAlign=`(container: LayoutContainer, yAlign: YAlign) =
  container.fYAlign = yAlign
  container.realignChildControls()

method padding(container: LayoutContainer): int = container.fPadding

method `padding=`(container: LayoutContainer, padding: int) =
  container.fPadding = padding
  container.triggerRelayout()

method spacing(container: LayoutContainer): int = container.fSpacing

method `spacing=`(container: LayoutContainer, spacing: int) =
  container.fSpacing = spacing
  container.triggerRelayout()

method realignChildControls(container: LayoutContainer) =
  # echo ""
  # echo container.tag & ".realignChildControls()"
  if container.fChildControls.len == 0:
    return
  # echo "  container size: " & $container.width & ", " & $container.height
  let padding = container.getPadding()
  let clientWidth = container.visibleWidth - padding.left - padding.right
  let clientHeight = container.visibleHeight - padding.top - padding.bottom

  # echo "  client size: " & $clientWidth & ", " & $clientHeight
  var minInnerWidth = 0
  var minInnerHeight = 0
  var expandWidthCount = 0
  var expandHeightCount = 0

  # Calculate minimum needed size:
  for control in container.fChildControls:
    if not control.visible:
      continue

    if control.widthMode in {WidthMode_Fill, WidthMode_Expand}:
      if container.layout == Layout_Horizontal:
        minInnerWidth.inc(control.minWidth)
        expandWidthCount.inc

    elif control.widthMode in {WidthMode_Auto , WidthMode_Static}:
      if container.layout == Layout_Horizontal:
        if control.wantedWidth == -1:
          minInnerWidth.inc(control.minWidth)
          expandWidthCount.inc
        else:
          minInnerWidth.inc(control.wantedWidth)
      else:
        if control.wantedWidth == -1:
          expandWidthCount.inc
        else:
          minInnerWidth = max(minInnerWidth, control.wantedWidth)

    if control.heightMode in {HeightMode_Fill, HeightMode_Expand}:
      if container.layout == Layout_Vertical:
        minInnerHeight.inc(control.minHeight)
        expandHeightCount.inc

    elif control.heightMode in {HeightMode_Auto, HeightMode_Static}:
      if container.layout == Layout_Vertical:
        if control.wantedHeight == -1:
          minInnerHeight.inc(control.minHeight)
          expandHeightCount.inc
        else:
          minInnerHeight.inc(control.wantedHeight)
      else:
        if control.wantedHeight == -1:
          expandHeightCount.inc
        else:
          minInnerHeight = max(minInnerHeight, control.wantedHeight)

  # Add padding:
  minInnerWidth.inc(container.padding * 2)
  minInnerHeight.inc(container.padding * 2)

  # Add spacing:
  if container.childControls.len > 1:
    if container.layout == Layout_Horizontal:
      minInnerWidth.inc(container.spacing * (container.childControls.len - 1))
    if container.layout == Layout_Vertical:
      minInnerHeight.inc(container.spacing * (container.childControls.len - 1))

  container.updateInnerSize(minInnerWidth, minInnerHeight)

  let innerWidth = max(minInnerWidth, clientWidth)
  let innerHeight = max(minInnerHeight, clientHeight)

  # Calculate dynamic size:
  var dynamicWidth = clientWidth - minInnerWidth
  var dynamicHeight = clientHeight - minInnerHeight
  dynamicWidth = max(dynamicWidth, 0)
  dynamicHeight = max(dynamicHeight, 0)

  # Move and resize controls:
  var x = container.padding
  var y = container.padding

  if (container.xAlign == XAlign_Center or (container.xAlign == XAlign_Spread and container.childControls.len == 1)) and (container.layout == Layout_Vertical or expandWidthCount == 0):
    x.inc(dynamicWidth div 2)
  elif container.xAlign == XAlign_Right:
    x.inc(dynamicWidth)
  if (container.yAlign == YAlign_Center or (container.yAlign == YAlign_Spread and container.childControls.len == 1)) and (container.layout == Layout_Horizontal or expandHeightCount == 0):
    y.inc(dynamicHeight div 2)
  elif container.yAlign == YAlign_Bottom:
    y.inc(dynamicHeight)

  for control in container.fChildControls:
    if not control.visible:
      continue
    # echo "  child: " & control.tag

    # Size:
    var width = control.width
    var height = control.height
    # echo "size old: " & $width & ", " $height
    if control.widthMode in {WidthMode_Fill, WidthMode_Expand} or control.wantedWidth == -1:
      if container.layout == Layout_Horizontal:
        if expandWidthCount > 0:
          width = control.minWidth + dynamicWidth div expandWidthCount
        else:
          width = control.minWidth + dynamicWidth
      else:
        width = clientWidth - container.padding * 2
    elif control.widthMode == WidthMode_Auto:
      width = control.wantedWidth

    if control.minWidth > width:
      width = control.minWidth
    if control.maxWidth > 0 and control.maxWidth < width:
      width = control.maxWidth

    if control.heightMode in {HeightMode_Fill, HeightMode_Expand} or control.wantedHeight == -1:
      if container.layout == Layout_Vertical:
        if expandHeightCount > 0:
          height = control.minHeight + dynamicHeight div expandHeightCount
        else:
          height = control.minHeight + dynamicHeight
      else:
        height = clientHeight - container.padding * 2
    elif control.heightMode == HeightMode_Auto:
      height = control.wantedHeight

    if control.minHeight > height:
      height = control.minHeight
    if control.maxHeight > 0 and control.maxHeight < height:
      height = control.maxHeight

    if control.width != width or control.height != height:
      # echo "  ", control.tag, "    new size: ", width, ", ", $height
      control.setSize(width, height)

    # Position:
    if container.layout == Layout_Vertical or container.childControls.len == 1:
      if container.xAlign == XAlign_Center:
        x = (innerWidth - width) div 2
      elif container.xAlign == XAlign_Right:
        x = innerWidth - width - container.padding
    if container.layout == Layout_Horizontal or container.childControls.len == 1:
      if container.yAlign == YAlign_Center:
        y = (innerHeight - height) div 2
      elif container.yAlign == YAlign_Bottom:
        y = innerHeight - height - container.padding

    if control.x != x or control.y != y:
      # echo "    new pos: ", x, ", ", $y
      control.setPosition(x, y)

    # Calculate next position:
    case container.layout
    of Layout_Horizontal:
      x.inc(width)
      x.inc(container.spacing)
      if container.xAlign == XAlign_Spread and expandWidthCount == 0 and container.childControls.len > 1:
        x.inc(dynamicWidth div (container.childControls.len - 1))
    of Layout_Vertical:
      y.inc(height)
      y.inc(container.spacing)
      if container.yAlign == YAlign_Spread and expandHeightCount == 0 and container.childControls.len > 1:
        y.inc(dynamicHeight div (container.childControls.len - 1))


# ----------------------------------------------------------------------------------------
#                                        Frame
# ----------------------------------------------------------------------------------------

proc newFrame(text = ""): Frame =
  result = new NativeFrame
  result.NativeFrame.init()
  result.text = text

proc init(frame: Frame) =
  frame.ControlImpl.init()

method text(frame: Frame): string = frame.fText

method `text=`(frame: Frame, text: string) =
  frame.fText = text
  frame.tag = text
  frame.forceRedraw()
  # should be extended by NativeFrame

method getPadding(frame: Frame): Spacing =
  result.left = 4.scaleToDpi
  result.right = 4.scaleToDpi
  result.top = 4.scaleToDpi
  result.bottom = 4.scaleToDpi
  # should be extended by NativeFrame

method `onDraw=`(container: NativeFrame, callback: DrawProc) = raiseError("NativeFrame does not allow onDraw.")


# ----------------------------------------------------------------------------------------
#                                        Button
# ----------------------------------------------------------------------------------------

proc newButton(text = ""): Button =
  result = new NativeButton
  result.NativeButton.init()
  result.text = text

proc init(button: Button) =
  button.ControlImpl.init()
  button.fWidthMode = WidthMode_Auto
  button.fHeightMode = HeightMode_Auto
  button.minWidth = 15.scaleToDpi
  button.minHeight = 15.scaleToDpi
  button.enabled = true

method text(button: Button): string = button.fText

method `text=`(button: Button, text: string) =
  button.fText = text
  button.tag = text
  button.triggerRelayoutIfModeIsAuto()
  button.forceRedraw()
  # should be extended by NativeButton

method naturalWidth(button: Button): int {.locks: "unknown".} = button.getTextWidth(button.text) + 20.scaleToDpi

method naturalHeight(button: Button): int {.locks: "unknown".} = button.getTextLineHeight() * button.text.countLines + 12.scaleToDpi

method enabled(button: Button): bool = button.fEnabled

method `enabled=`(button: Button, enabled: bool) = discard
  # has to be implemented by NativeButton

method handleKeyDownEvent*(button: Button, event: KeyboardEvent) =
  if event.key == Key_Return or event.key == Key_Space:
    var clickEvent = new ClickEvent
    clickEvent.control = button
    button.handleClickEvent(clickEvent)


method `onDraw=`(container: NativeButton, callback: DrawProc) = raiseError("NativeButton does not allow onDraw.")


# ----------------------------------------------------------------------------------------
#                                        Checkbox
# ----------------------------------------------------------------------------------------

proc newCheckbox(text = ""): Checkbox =
  result = new NativeCheckbox
  result.NativeCheckbox.init()
  result.text = text

proc init(checkbox: Checkbox) =
  checkbox.ControlImpl.init()
  checkbox.fWidthMode = WidthMode_Auto
  checkbox.fHeightMode = HeightMode_Auto
  checkbox.enabled = true

method text(checkbox: Checkbox): string = checkbox.fText

method `text=`(checkbox: Checkbox, text: string) =
  checkbox.fText = text
  checkbox.tag = text
  checkbox.triggerRelayoutIfModeIsAuto()
  checkbox.forceRedraw()

method naturalWidth(checkbox: Checkbox): int {.locks: "unknown".} = checkbox.getTextWidth(checkbox.text) + 20.scaleToDpi

method naturalHeight(checkbox: Checkbox): int {.locks: "unknown".} = checkbox.getTextLineHeight() * checkbox.text.countLines + 12.scaleToDpi

method enabled(checkbox: Checkbox): bool = checkbox.fEnabled

method `enabled=`(checkbox: Checkbox, enabled: bool) = discard
  # has to be implemented by NativeCheckbox

method checked(checkbox: Checkbox): bool = discard
  # has to be implemented by NativeCheckbox

method `checked=`(checkbox: Checkbox, checked: bool) = discard
  # has to be implemented by NativeCheckbox

method handleKeyDownEvent*(checkbox: Checkbox, event: KeyboardEvent) =
  if event.key == Key_Return or event.key == Key_Space:
    checkbox.checked = not checkbox.checked
    var evt = new ToggleEvent
    evt.control = checkbox
    checkbox.handleToggleEvent(evt)
    event.handled = true


method `onDraw=`(checkbox: NativeCheckbox, callback: DrawProc) = raiseError("NativeCheckbox does not allow onDraw.")

method onToggle(checkbox: Checkbox): ToggleProc = checkbox.fOnToggle
method `onToggle=`(checkbox: Checkbox, callback: ToggleProc) = checkbox.fOnToggle = callback

method handleToggleEvent(checkbox: Checkbox, event: ToggleEvent) =
  # can be overridden by custom control
  let callback = checkbox.onToggle
  if callback != nil:
    callback(event)


# ----------------------------------------------------------------------------------------
#                                        ComboBox
# ----------------------------------------------------------------------------------------

proc newComboBox(options = @[""]): ComboBox =
  result = new NativeComboBox
  result.NativeComboBox.init()
  result.options = options
  result.index = 0

proc init(comboBox: ComboBox) =
  comboBox.ControlImpl.init()
  comboBox.fWidthMode = WidthMode_Auto
  comboBox.fHeightMode = HeightMode_Auto
  comboBox.enabled = true

method options(comboBox: ComboBox): seq[string] = comboBox.fOptions

method `options=`(comboBox: ComboBox, options: seq[string]) =
  comboBox.fOptions = options
  comboBox.triggerRelayoutIfModeIsAuto()
  comboBox.forceRedraw()

method enabled(comboBox: ComboBox): bool = comboBox.fEnabled

method `enabled=`(comboBox: ComboBox, enabled: bool) = discard
  # has to be implemented by NativeComboBox

method value(comboBox: ComboBox): string = discard
  # has to be implemented by NativeComboBox

method `value=`*(comboBox: ComboBox, value: string) = discard
  # has to be implemented by NativeComboBox

method index(comboBox: ComboBox): int = discard
  # has to be implemented by NativeComboBox

method `index=`(comboBox: ComboBox, index: int) = discard
  # has to be implemented by NativeComboBox


# ----------------------------------------------------------------------------------------
#                                        Label
# ----------------------------------------------------------------------------------------

proc newLabel(text = ""): Label =
  result = new NativeLabel
  result.NativeLabel.init()
  result.text = text

proc init(label: Label) =
  label.ControlImpl.init()
  label.fWidthMode = WidthMode_Auto
  label.fHeightMode = HeightMode_Auto
  label.minWidth = 10.scaleToDpi
  label.minHeight = 10.scaleToDpi
  label.fXTextAlign = XTextAlign_Left
  label.fYTextAlign = YTextAlign_Center

method text(label: Label): string = label.fText

method `text=`(label: Label, text: string) =
  label.fText = text
  label.tag = text
  label.triggerRelayoutIfModeIsAuto()
  label.forceRedraw()

method naturalWidth(label: Label): int {.locks: "unknown".} = label.getTextWidth(label.text)

method naturalHeight(label: Label): int {.locks: "unknown".} = label.getTextLineHeight() * label.text.countLines

method xTextAlign(label: Label): XTextAlign = label.fXTextAlign

method `xTextAlign=`(label: Label, xTextAlign: XTextAlign) =
  label.fXTextAlign = xTextAlign
  label.forceRedraw()

method yTextAlign(label: Label): YTextAlign = label.fYTextAlign

method `yTextAlign=`(label: Label, yTextAlign: YTextAlign) =
  label.fYTextAlign = yTextAlign
  label.forceRedraw()

method handleDrawEvent(label: Label, event: DrawEvent) =
  # Use a custom draw for labels, because Windows does not support vertical text aligment.
  let callback = label.onDraw
  if callback != nil:
    callback(event)
    return
  label.canvas.fontFamily = label.fontFamily
  label.canvas.fontSize = label.fontSize
  label.canvas.textColor = label.textColor
  label.canvas.areaColor = label.backgroundColor
  label.canvas.fill()
  let x =
    case label.xTextAlign
    of XTextAlign_Left:
      0
    of XTextAlign_Center:
      (label.width - label.canvas.getTextLineWidth(label.text)) div 2
    of XTextAlign_Right:
      label.width - label.canvas.getTextLineWidth(label.text)
  let y =
    case label.yTextAlign
    of YTextAlign_Top:
      0
    of YTextAlign_Center:
      (label.height - label.canvas.getTextLineHeight() * label.text.countLines) div 2
    of YTextAlign_Bottom:
      label.height - label.canvas.getTextLineHeight() * label.text.countLines
  label.canvas.drawText(label.text, x, y)


# ----------------------------------------------------------------------------------------
#                                      ProgressBar
# ----------------------------------------------------------------------------------------

proc newProgressBar(): ProgressBar =
  result = new NativeProgressBar
  result.NativeProgressBar.init()

proc init(progressBar: ProgressBar) =
  progressBar.ControlImpl.init()
  progressBar.fWidthMode = WidthMode_Expand
  progressBar.height = 15.scaleToDpi

method value*(progressBar: ProgressBar): float = progressBar.fValue

method `value=`*(progressBar: ProgressBar, value: float) =
  # should be overridden by native control
  progressBar.fValue = value
  progressBar.forceRedraw()


# ----------------------------------------------------------------------------------------
#                                       TextBox
# ----------------------------------------------------------------------------------------

proc newTextBox(text = ""): TextBox =
  result = new NativeTextBox
  result.NativeTextBox.init()
  result.text = text

proc init(textBox: TextBox) =
  textBox.ControlImpl.init()
  textBox.fWidthMode = WidthMode_Expand
  textBox.fHeightMode = HeightMode_Auto
  textBox.minWidth = 20.scaleToDpi
  textBox.minHeight = 20.scaleToDpi
  textBox.editable = true

method naturalHeight(textBox: TextBox): int {.locks: "unknown".} = textBox.getTextLineHeight()

method text(textBox: TextBox): string = discard
  # has to be implemented by NativeTextBox

method `text=`(textBox: TextBox, text: string) = discard
  # has to be implemented by NativeTextBox

method `onDraw=`(container: NativeTextBox, callback: DrawProc) = raiseError("NativeTextBox does not allow onDraw.")

method editable(textBox: TextBox): bool = textBox.fEditable

method `editable=`(textBox: TextBox, editable: bool) = discard
  # has to be implemented by NativeTextBox

method cursorPos(textBox: TextBox): int = discard
  # has to be implemented by NativeTextBox

method `cursorPos=`(textBox: TextBox, cursorPos: int) = discard
  # has to be implemented by NativeTextBox

method selectionStart(textBox: TextBox): int = discard
  # has to be implemented by NativeTextBox

method `selectionStart=`(textBox: TextBox, selectionStart: int) = discard
  # has to be implemented by NativeTextBox

method selectionEnd(textBox: TextBox): int = discard
  # has to be implemented by NativeTextBox

method `selectionEnd=`(textBox: TextBox, selectionEnd: int) = discard
  # has to be implemented by NativeTextBox

method selectedText(textBox: TextBox): string =
  result = textBox.text.runeSubStr(textBox.selectionStart, textBox.selectionEnd - textBox.selectionStart)

method `selectedText=`(textBox: TextBox, text: string) =
  let oldCursorPos = textBox.cursorPos
  let oldText = textBox.text
  textBox.text = oldText.runeSubStr(0, textBox.selectionStart) & text & oldText.runeSubStr(textBox.selectionEnd)
  textBox.cursorPos = oldCursorPos

method handleTextChangeEvent(textBox: TextBox, event: TextChangeEvent) =
  # can be overridden by custom control
  let callback = textBox.onTextChange
  if callback != nil:
    callback(event)

method onTextChange(textBox: TextBox): TextChangeProc = textBox.fOnTextChange

method `onTextChange=`(textBox: TextBox, callback: TextChangeProc) = textBox.fOnTextChange = callback


# ----------------------------------------------------------------------------------------
#                                      TextArea
# ----------------------------------------------------------------------------------------

proc newTextArea(text = ""): TextArea =
  result = new NativeTextArea
  result.NativeTextArea.init()
  result.text = text

proc init(textArea: TextArea) =
  textArea.ControlImpl.init()
  textArea.fWidthMode = WidthMode_Expand
  textArea.fHeightMode = HeightMode_Expand
  textArea.minWidth = 20.scaleToDpi
  textArea.minHeight = 20.scaleToDpi
  textArea.wrap = true
  textArea.editable = true

method addText(textArea: TextArea, text: string) = textArea.text = textArea.text & text

method addLine(textArea: TextArea, text = "") = textArea.addtext(text & "\p")

method scrollToBottom(textArea: TextArea) = discard
  # has to be implemented by NativeTextBox

method `onDraw=`(container: NativeTextArea, callback: DrawProc) = raiseError("NativeTextArea does not allow onDraw.")

method wrap(textArea: TextArea): bool = textArea.fWrap

method `wrap=`(textArea: TextArea, wrap: bool) =
  textArea.fWrap = wrap
  # should be extended by NativeTextArea


# ----------------------------------------------------------------------------------------
#                             Platform-specific implementation
# ----------------------------------------------------------------------------------------

when useWindows(): include "nigui/private/windows/platform_impl"
when useGtk():     include "nigui/private/gtk3/platform_impl"
