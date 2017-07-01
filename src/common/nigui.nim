# NiGui - main file

# This file contains all common code except extra widgets.
# All public procedures are declared here.
# Public types are declared here or in the platform-specific file "nigui_platform_types".
# The platform-specific files "nigui_platform_types" and "nigui_platform_procs" will be
# included to this file.

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
    Key_None
    Key_Number0
    Key_Number1
    Key_Number2
    Key_Number3
    Key_Number4
    Key_Number5
    Key_Number6
    Key_Number7
    Key_Number8
    Key_Number9
    Key_A
    Key_B
    Key_C
    Key_D
    Key_E
    Key_F
    Key_G
    Key_H
    Key_I
    Key_J
    Key_K
    Key_L
    Key_M
    Key_N
    Key_O
    Key_P
    Key_Q
    Key_R
    Key_S
    Key_T
    Key_U
    Key_V
    Key_W
    Key_X
    Key_Y
    Key_Z
    Key_Space
    Key_Tab
    Key_Return
    Key_Escape
    Key_Insert
    Key_Delete
    Key_Backspace
    Key_Left
    Key_Right
    Key_Up
    Key_Down
    Key_Home
    Key_End
    Key_PageUp
    Key_PageDown

const inactiveTimer* = 0


# ----------------------------------------------------------------------------------------
#                                   Widget Types 1/3
# ----------------------------------------------------------------------------------------

type
  # Window base type:

  Window* = ref object of RootObj
    fDisposed: bool
    fTitle: string
    fVisible: bool
    fWidth, fHeight: int
    fClientWidth, fClientHeight: int
    fX, fY: int
    fControl: Control
    fIconPath: string
    fOnDispose: WindowDisposeProc
    fOnResize: ResizeProc
    fOnDropFiles: DropFilesProc
    fOnKeyDown: WindowKeyProc

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
    fFontSize: int
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
    fOnKeyDown: ControlKeyProc
    fOnTextChange: TextChangeProc
    tag*: string

  # Drawing:

  Canvas* = ref object of RootObj
    fWidth: int
    fHeight: int
    fFontFamily: string
    fFontSize: int
    fTextColor: Color
    fLineColor: Color
    fAreaColor: Color

  Image* = ref object of RootObj
    fCanvas: Canvas

  # Window events:

  WindowDisposeEvent* = ref object
    window*: Window
    cancel*: bool
  WindowDisposeProc* = proc(event: WindowDisposeEvent)

  ResizeEvent* = ref object
    window*: Window
  ResizeProc* = proc(event: ResizeEvent)

  DropFilesEvent* = ref object
    window*: Window
    files*: seq[string]
  DropFilesProc* = proc(event: DropFilesEvent)

  WindowKeyEvent* = ref object
    window*: Window
    key*: Key
    unicode*: int
    character*: string # UTF-8 character
  WindowKeyProc* = proc(event: WindowKeyEvent)

  # Control events:

  ControlDisposeEvent* = ref object
    control*: Control
    cancel*: bool
  ControlDisposeProc* = proc(event: ControlDisposeEvent)

  DrawEvent* = ref object
    control*: Control
  DrawProc* = proc(event: DrawEvent)

  MouseButtonEvent* = ref object
    control*: Control
    button*: MouseButton
    x*: int
    y*: int
  MouseButtonProc* = proc(event: MouseButtonEvent)

  ClickEvent* = ref object
    control*: Control
  ClickProc* = proc(event: ClickEvent)

  ControlKeyEvent* = ref object
    control*: Control
    key*: Key
    unicode*: int
    character*: string # UTF-8 character
    cancel*: bool
  ControlKeyProc* = proc(event: ControlKeyEvent)

  TextChangeEvent* = ref object
    control*: Control
  TextChangeProc* = proc(event: TextChangeEvent)

  # Other events:

  ErrorHandlerProc* = proc()

  TimerEvent* = ref object
    timer*: Timer
    data*: pointer
  TimerProc* = proc(event: TimerEvent)


# Platform-specific extension of Window and Control:
include nigui_platform_types1


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

  Label* = ref object of ControlImpl
    fText: string

  TextBox* = ref object of ControlImpl

  TextArea* = ref object of ControlImpl
    fWrap: bool


# Platform-specific extension of basic controls:
include nigui_platform_types2


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


# ----------------------------------------------------------------------------------------
#                                    Global Variables
# ----------------------------------------------------------------------------------------

var quitOnLastWindowClose* = true
var clickMaxXYMove* = 20

# dummy type and object, needed to use get/set properties
type App = object
var app*: App


# ----------------------------------------------------------------------------------------
#                                  Global/App Procedures
# ----------------------------------------------------------------------------------------

proc init*(app: App)

proc run*(app: App)

proc quit*(app: App)

proc processEvents*(app: App)

proc sleep*(app: App, milliSeconds: float)

proc errorHandler*(app: App): ErrorHandlerProc
proc `errorHandler=`*(app: App, errorHandler: ErrorHandlerProc)

proc defaultBackgroundColor*(app: App): Color
proc `defaultBackgroundColor=`*(app: App, color: Color)

proc defaultTextColor*(app: App): Color
proc `defaultTextColor=`*(app: App, color: Color)

proc defaultFontFamily*(app: App): string
proc `defaultFontFamily=`*(app: App, fontFamily: string)

proc defaultFontSize*(app: App): int
proc `defaultFontSize=`*(app: App, fontSize: int)

proc rgb*(red, green, blue: byte, alpha: byte = 255): Color


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

method run*(dialog: OpenFileDialog)

type SaveFileDialog* = ref object
  title*: string
  directory*: string
  defaultExtension*: string
  defaultName*: string
  file*: string

proc newSaveFileDialog*(): SaveFileDialog

method run*(dialog: SaveFileDialog)


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

method destroy*(canvas: Canvas)

method width*(canvas: Canvas): int

method height*(canvas: Canvas): int

method fontFamily*(canvas: Canvas): string
method `fontFamily=`*(canvas: Canvas, fontFamily: string)

method fontSize*(canvas: Canvas): int
method `fontSize=`*(canvas: Canvas, fontSize: int)

method textColor*(canvas: Canvas): Color
method `textColor=`*(canvas: Canvas, color: Color)

method lineColor*(canvas: Canvas): Color
method `lineColor=`*(canvas: Canvas, color: Color)

method areaColor*(canvas: Canvas): Color
method `areaColor=`*(canvas: Canvas, color: Color)

method drawText*(canvas: Canvas, text: string, x, y = 0)

method drawTextCentered*(canvas: Canvas, text: string, x, y = 0, width, height = -1)

method drawLine*(canvas: Canvas, x1, y1, x2, y2: int)

method drawRectArea*(canvas: Canvas, x, y, width, height: int)

method drawRectOutline*(canvas: Canvas, x, y, width, height: int)

method fill*(canvas: Canvas)

method drawImage*(canvas: Canvas, image: Image, x, y = 0, width, height = -1)

method setPixel*(canvas: Canvas, x, y: int, color: Color)

method getTextLineWidth*(canvas: Canvas, text: string): int

method getTextLineHeight*(canvas: Canvas): int

method getTextWidth*(canvas: Canvas, text: string): int


# ----------------------------------------------------------------------------------------
#                                        Image
# ----------------------------------------------------------------------------------------

proc newImage*(): Image

method resize*(image: Image, width, height: int)

method loadFromFile*(image: Image, filePath: string)

method saveToPngFile*(image: Image, filePath: string)

method saveToJpegFile*(image: Image, filePath: string, quality = 80)

method width*(image: Image): int

method height*(image: Image): int

method canvas*(image: Image): Canvas


# ----------------------------------------------------------------------------------------
#                                        Window
# ----------------------------------------------------------------------------------------

proc newWindow*(title: string = nil): Window
## Constructor for a Window object.
## If the title is nil, it will be set to the application filename.

proc init*(window: WindowImpl)
## Initialize a WindowImpl object
## Only needed for own constructors.

proc dispose*(window: var Window)
proc dispose*(window: Window)

proc disposed*(window: Window): bool

method visible*(window: Window): bool
method `visible=`*(window: Window, visible: bool)

method show*(window: Window)

method showModal*(window: Window, parent: Window)

method hide*(window: Window)

method control*(window: Window): Control
method `control=`*(window: Window, control: Control)

method add*(window: Window, control: Control)

method title*(window: Window): string
method `title=`*(window: Window, title: string)

method x*(window: Window): int
method `x=`*(window: Window, x: int)

method y*(window: Window): int
method `y=`*(window: Window, y: int)

method centerOnScreen*(window: Window)

method width*(window: Window): int
method `width=`*(window: Window, width: int)

method height*(window: Window): int
method `height=`*(window: Window, height: int)

method clientWidth*(window: Window): int

method clientHeight*(window: Window): int

method iconPath*(window: Window): string
method `iconPath=`*(window: Window, iconPath: string)

method handleDisposeEvent*(window: Window, event: WindowDisposeEvent)

method handleResizeEvent*(window: Window, event: ResizeEvent)

method handleKeyDownEvent*(window: Window, event: WindowKeyEvent)

method handleDropFilesEvent*(window: Window, event: DropFilesEvent)

method onDispose*(window: Window): WindowDisposeProc
method `onDispose=`*(window: Window, callback: WindowDisposeProc)

method onResize*(window: Window): ResizeProc
method `onResize=`*(window: Window, callback: ResizeProc)

method onDropFiles*(window: Window): DropFilesProc
method `onDropFiles=`*(window: Window, callback: DropFilesProc)

method onKeyDown*(window: Window): WindowKeyProc
method `onKeyDown=`*(window: Window, callback: WindowKeyProc)


# ----------------------------------------------------------------------------------------
#                                       Control
# ----------------------------------------------------------------------------------------

proc newControl*(): Control

proc init*(control: Control)
proc init*(control: ControlImpl)

proc dispose*(control: var Control)
proc dispose*(control: Control)

proc disposed*(control: Control): bool

method visible*(control: Control): bool
method `visible=`*(control: Control, visible: bool)
method show*(control: Control)
method hide*(control: Control)

# Allow the outside to walk over child widgets
method childControls*(control: Control): seq[Control]

method parentControl*(control: Control): Control

method parentWindow*(control: Control): WindowImpl

method width*(control: Control): int
# Set the control's width to a fixed value (sets widthMode to fixed)
method `width=`*(control: Control, width: int)

method height*(control: Control): int
# Set the control's height to a fixed value (sets heightMode to fixed)
method `height=`*(control: Control, height: int)

method minWidth*(control: Control): int
method `minWidth=`*(control: Control, minWidth: int)

method minHeight*(control: Control): int
method `minHeight=`*(control: Control, minHeight: int)

method maxWidth*(control: Control): int
method `maxWidth=`*(control: Control, maxWidth: int)

method maxHeight*(control: Control): int
method `maxHeight=`*(control: Control, maxHeight: int)

# Set the control's width and height without changing widthMode or heightMode
method setSize*(control: Control, width, height: int)

method x*(control: Control): int
method `x=`*(control: Control, x: int)

method y*(control: Control): int
method `y=`*(control: Control, y: int)

method setPosition*(control: Control, x, y: int)

method naturalWidth*(control: Control): int

method naturalHeight*(control: Control): int

method wantedWidth*(control: Control): int

method wantedHeight*(control: Control): int

method focus*(control: Control)

method getTextLineWidth*(control: Control, text: string): int

method getTextLineHeight*(control: Control): int

method getTextWidth*(control: Control, text: string): int

method `widthMode=`*(control: Control, mode: WidthMode)
method widthMode*(control: Control): WidthMode

method heightMode*(control: Control): HeightMode
method `heightMode=`*(control: Control, mode: HeightMode)

method visibleWidth*(control: Control): int

method visibleHeight*(control: Control): int

method xScrollPos*(control: Control): int
method `xScrollPos=`*(control: Control, xScrollPos: int)

method yScrollPos*(control: Control): int
method `yScrollPos=`*(control: Control, yScrollPos: int)

method scrollableWidth*(control: Control): int
method `scrollableWidth=`*(control: Control, scrollableWidth: int)

method scrollableHeight*(control: Control): int
method `scrollableHeight=`*(control: Control, scrollableHeight: int)

method fontFamily*(control: Control): string
method `fontFamily=`*(control: Control, fontFamily: string)
method setFontFamily*(control: Control, fontFamily: string)
method resetFontFamily*(control: Control)

method fontSize*(control: Control): int
method `fontSize=`*(control: Control, fontSize: int)
method setFontSize*(control: Control, fontSize: int)
method resetFontSize*(control: Control)

method backgroundColor*(control: Control): Color
method `backgroundColor=`*(control: Control, color: Color)
method setBackgroundColor*(control: Control, color: Color)
method resetBackgroundColor*(control: Control)

method textColor*(control: Control): Color
method `textColor=`*(control: Control, color: Color)
method setTextColor*(control: Control, color: Color)
method resetTextColor*(control: Control)

method forceRedraw*(control: Control)

method canvas*(control: Control): Canvas

method handleDisposeEvent*(control: Control, event: ControlDisposeEvent)

method handleDrawEvent*(control: Control, event: DrawEvent)

method handleMouseButtonDownEvent*(control: Control, event: MouseButtonEvent)

method handleMouseButtonUpEvent*(control: Control, event: MouseButtonEvent)

method handleClickEvent*(control: Control, event: ClickEvent)

method handleKeyDownEvent*(control: Control, event: ControlKeyEvent)

method handleTextChangeEvent*(control: Control, event: TextChangeEvent)

method onDispose*(control: Control): ControlDisposeProc
method `onDispose=`*(control: Control, callback: ControlDisposeProc)

method onDraw*(control: Control): DrawProc
method `onDraw=`*(control: Control, callback: DrawProc)

method onMouseButtonDown*(control: Control): MouseButtonProc
method `onMouseButtonDown=`*(control: Control, callback: MouseButtonProc)

method onMouseButtonUp*(control: Control): MouseButtonProc
method `onMouseButtonUp=`*(control: Control, callback: MouseButtonProc)

method onClick*(control: Control): ClickProc
method `onClick=`*(control: Control, callback: ClickProc)

method onKeyDown*(control: Control): ControlKeyProc
method `onKeyDown=`*(control: Control, callback: ControlKeyProc)

method onTextChange*(control: Control): TextChangeProc
method `onTextChange=`*(control: Control, callback: TextChangeProc)


# ----------------------------------------------------------------------------------------
#                                      Container
# ----------------------------------------------------------------------------------------

proc newContainer*(): Container

proc init*(container: Container)
proc init*(container: ContainerImpl)

method frame*(container: Container): Frame
method `frame=`*(container: Container, frame: Frame)

method add*(container: Container, control: Control)
method remove*(container: Container, control: Control)

method getPadding*(container: Container): Spacing

method setInnerSize*(container: Container, width, height: int)


# ----------------------------------------------------------------------------------------
#                                   LayoutContainer
# ----------------------------------------------------------------------------------------

proc newLayoutContainer*(layout: Layout): LayoutContainer

method layout*(container: LayoutContainer): Layout
method `layout=`*(container: LayoutContainer, layout: Layout)

method xAlign*(container: LayoutContainer): XAlign
method `xAlign=`*(container: LayoutContainer, xAlign: XAlign)

method yAlign*(container: LayoutContainer): YAlign
method `yAlign=`*(container: LayoutContainer, yAlign: YAlign)

method padding*(container: LayoutContainer): int
method `padding=`*(container: LayoutContainer, padding: int)

method spacing*(container: LayoutContainer): int
method `spacing=`*(container: LayoutContainer, spacing: int)


# ----------------------------------------------------------------------------------------
#                                        Frame
# ----------------------------------------------------------------------------------------

proc newFrame*(text = ""): Frame

proc init*(frame: Frame)
proc init*(frame: NativeFrame)

method text*(frame: Frame): string
method `text=`*(frame: Frame, text: string)

method getPadding*(frame: Frame): Spacing


# ----------------------------------------------------------------------------------------
#                                        Button
# ----------------------------------------------------------------------------------------

proc newButton*(text = ""): Button

proc init*(button: Button)
proc init*(button: NativeButton)

method text*(button: Button): string
method `text=`*(button: Button, text: string)


# ----------------------------------------------------------------------------------------
#                                        Label
# ----------------------------------------------------------------------------------------

proc newLabel*(text = ""): Label

proc init*(label: Label)
proc init*(label: NativeLabel)

method text*(label: Label): string
method `text=`*(label: Label, text: string)


# ----------------------------------------------------------------------------------------
#                                       TextBox
# ----------------------------------------------------------------------------------------

proc newTextBox*(text = ""): TextBox

proc init*(textBox: TextBox)
proc init*(textBox: NativeTextBox)

method text*(textBox: TextBox): string
method `text=`*(textBox: TextBox, text: string)


# ----------------------------------------------------------------------------------------
#                                      TextArea
# ----------------------------------------------------------------------------------------

proc newTextArea*(text = ""): TextArea

proc init*(textArea: TextArea)
proc init*(textArea: NativeTextArea)

method text*(textArea: TextArea): string
method `text=`*(textArea: TextArea, text: string)
method addText*(textArea: TextArea, text: string)
method addLine*(textArea: TextArea, text = "")

method scrollToBottom*(textArea: TextArea)

method wrap*(textArea: TextArea): bool
method `wrap=`*(textArea: TextArea, wrap: bool)


# ----------------------------------------------------------------------------------------
#                            Private Procedures Predeclaration
# ----------------------------------------------------------------------------------------

proc raiseError(msg: string, showAlert = true, title = "NiGui Error")

proc handleException()

proc runMainLoop()

proc init(window: Window)

method destroy(window: Window)

proc triggerRelayout(window: Window)

method destroy(control: Control)

proc triggerRelayout(control: Control)

proc triggerRelayoutIfModeIsAuto(control: Control)

method relayout(control: Control, availableWidth, availableHeight: int)

method realignChildControls(control: Control)

method setControlPosition(container: Container, control: Control, x, y: int)

proc countLines(s: string): int


# ========================================================================================
#
#                                    Implementation
#
# ========================================================================================

import math
import os
import strutils
import times


# ----------------------------------------------------------------------------------------
#                                   Global Variables
# ----------------------------------------------------------------------------------------

var fErrorHandler: ErrorHandlerProc = nil
var windowList: seq[Window] = @[]
var fScrollbarSize = -1

# Default style:
var fDefaultBackgroundColor: Color # initialized by platform-specific init()
var fDefaultTextColor: Color # initialized by platform-specific init()
var fDefaultFontFamily = ""
var fDefaultFontSize = 15


# ----------------------------------------------------------------------------------------
#                                  Global/App Procedures
# ----------------------------------------------------------------------------------------

proc raiseError(msg: string, showAlert = true, title = "NiGui Error") =
  if showAlert:
    alert(nil, msg & "\n\n" & getStackTrace(), title)
  raise newException(Exception, msg)

proc handleException() =
  if fErrorHandler == nil:
    raiseError(getCurrentExceptionMsg(), true, "Unhandled Exception")
  else:
    fErrorHandler()

proc rgb(red, green, blue: byte, alpha: byte = 255): Color =
  result.red = red
  result.green = green
  result.blue = blue
  result.alpha = alpha

proc countLines(s: string): int = strutils.countLines(s) + 1

proc sleep(app: App, milliSeconds: float) =
  let t = epochTime() + milliSeconds / 1000
  while epochTime() < t:
    app.processEvents()
    os.sleep(20)

proc run(app: App) =
  while true:
    try:
      runMainLoop()
      break
    except:
      handleException()

proc quit(app: App) = quit()

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

proc defaultFontSize(app: App): int = fDefaultFontSize

proc updateFontSize(control: Control) =
  if control.fUseDefaultFontSize and control.fontSize != fDefaultFontSize:
    control.setFontSize(fDefaultFontSize)
  for child in control.childControls:
    child.updateFontSize()

proc `defaultFontSize=`(app: App, fontSize: int) =
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
  result.defaultExtension = ""
  result.defaultName = ""
  result.file = ""


# ----------------------------------------------------------------------------------------
#                                       Canvas
# ----------------------------------------------------------------------------------------

proc newCanvas(control: Control = nil): CanvasImpl =
  result = new CanvasImpl
  result.fLineColor = rgb(0, 0, 0)
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

method fontSize(canvas: Canvas): int = canvas.fFontSize

method `fontSize=`(canvas: Canvas, fontSize: int) = canvas.fFontSize = fontSize

method textColor(canvas: Canvas): Color = canvas.fTextColor

method `textColor=`(canvas: Canvas, color: Color) = canvas.fTextColor = color

method lineColor(canvas: Canvas): Color = canvas.fLineColor

method `lineColor=`(canvas: Canvas, color: Color) = canvas.fLineColor = color

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
  let rx = x + (w - canvas.getTextWidth(text)) div 2
  let ry = y + (h - canvas.getTextLineHeight()) div 2
  canvas.drawText(text, rx, ry)

method fill(canvas: Canvas) = canvas.drawRectArea(0, 0, canvas.width, canvas.height)


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

proc newWindow(title: string = nil): Window =
  result = new WindowImpl
  result.WindowImpl.init()
  if title != nil:
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
    window.fControl.destroy()
  # should be extended by WindowImpl

proc disposeInner(window: Window): bool =
  var event = new WindowDisposeEvent
  event.window = window
  window.handleDisposeEvent(event)
  if event.cancel:
    return false
  window.destroy()
  let i = windowList.find(window)
  windowList.delete(i)
  if quitOnLastWindowClose and windowList.len == 0:
    quit()
  window.fDisposed = true
  return true

proc dispose(window: var Window) =
  if window.disposeInner():
    window = nil

proc dispose(window: Window) =
  discard window.disposeInner()

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
  if window.x == -1 or window.y == -1:
    window.centerOnScreen()

method show(window: Window) = window.visible = true

method showModal(window: Window, parent: Window) =
  window.visible = true
  # should be extended by WindowImpl

method hide(window: Window) = window.visible = false

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
  window.triggerRelayout()
  var event = new ResizeEvent
  event.window = window
  window.handleResizeEvent(event)

method `height=`(window: Window, height: int) =
  window.fHeight = height
  window.triggerRelayout()
  var event = new ResizeEvent
  event.window = window
  window.handleResizeEvent(event)

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

method handleDisposeEvent(window: Window, event: WindowDisposeEvent) =
  # can be overriden by custom window
  let callback = window.onDispose
  if callback != nil:
    callback(event)

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

method handleKeyDownEvent(window: Window, event: WindowKeyEvent) =
  # can be overriden by custom window
  let callback = window.onKeyDown
  if callback != nil:
    callback(event)

method onDispose(window: Window): WindowDisposeProc = window.fOnDispose
method `onDispose=`(window: Window, callback: WindowDisposeProc) = window.fOnDispose = callback

method onResize(window: Window): ResizeProc = window.fOnResize
method `onResize=`(window: Window, callback: ResizeProc) = window.fOnResize = callback

method onDropFiles(window: Window): DropFilesProc = window.fOnDropFiles
method `onDropFiles=`(window: Window, callback: DropFilesProc) = window.fOnDropFiles = callback

method onKeyDown(window: Window): WindowKeyProc = window.fOnKeyDown
method `onKeyDown=`(window: Window, callback: WindowKeyProc) = window.fOnKeyDown = callback



# ----------------------------------------------------------------------------------------
#                                       Control
# ----------------------------------------------------------------------------------------

proc newControl(): Control =
  result = new ControlImpl
  result.ControlImpl.init()

proc init(control: Control) =
  control.tag = ""
  control.fWidthMode = WidthMode_Expand
  control.fHeightMode = HeightMode_Expand
  control.fScrollableWidth = -1
  control.fScrollableHeight = -1
  control.resetFontFamily()
  control.resetFontSize()
  control.resetTextColor()
  control.resetBackgroundColor()
  control.show()
  # should be extended by WindowImpl

method destroy(control: Control) =
  discard # nothing to do here
  # should be extended by WindowImpl

proc dispose(control: var Control) =
  control.destroy()
  control = nil

proc dispose(control: Control) =
  control.destroy()
  control.fDisposed = true

proc disposed(control: Control): bool = control == nil or control.fDisposed

method visible(control: Control): bool = control.fVisible

method `visible=`(control: Control, visible: bool) =
  control.fVisible = visible
  control.triggerRelayout()
  # should be extended by WindowImpl

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

proc triggerRelayout(control: Control) =
  var con = control
  while con.parentControl != nil:
    con = con.parentControl
  if con.parentWindow != nil:
    con.parentWindow.triggerRelayout()
  if control.parentControl != nil:
    control.parentControl.realignChildControls()
  control.realignChildControls()

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

method visibleWidth(control: Control): int =
  result = control.width
  if control.fXScrollEnabled:
    result.dec(fScrollbarSize)

method visibleHeight(control: Control): int =
  result = control.height
  if control.fYScrollEnabled:
    result.dec(fScrollbarSize)

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

method setFontFamily(control: Control, fontFamily: string) =
  control.fFontFamily = fontFamily
  control.triggerRelayoutIfModeIsAuto()
  # should be extended by ControlImpl

method resetFontFamily(control: Control) =
  control.setFontFamily(fDefaultFontFamily)
  control.fUseDefaultFontFamily = true

method fontSize(control: Control): int = control.fFontSize

method `fontSize=`(control: Control, fontSize: int) =
  control.setFontSize(fontSize)
  control.fUseDefaultFontSize = false

method setFontSize(control: Control, fontSize: int) =
  control.fFontSize = fontSize
  control.triggerRelayoutIfModeIsAuto()
  # should be extended by ControlImpl

method resetFontSize(control: Control) =
  control.setFontSize(fDefaultFontSize)
  control.fUseDefaultFontSize = true

method backgroundColor(control: Control): Color = control.fBackgroundColor

method `backgroundColor=`(control: Control, color: Color) =
  control.setBackgroundColor(color)
  control.fUseDefaultBackgroundColor = false

method setBackgroundColor(control: Control, color: Color) =
  control.fBackgroundColor = color
  control.forceRedraw()
  # should be extended by ControlImpl

method resetBackgroundColor(control: Control) =
  control.setBackgroundColor(fDefaultBackgroundColor)
  control.fUseDefaultBackgroundColor = true

method textColor(control: Control): Color = control.fTextColor

method `textColor=`(control: Control, color: Color) =
  control.setTextColor(color)
  control.fUseDefaultTextColor = false

method setTextColor(control: Control, color: Color) =
  control.fTextColor = color
  control.forceRedraw()
  # should be extended by ControlImpl

method resetTextColor*(control: Control) =
  control.setTextColor(fDefaultTextColor)
  control.fUseDefaultTextColor = true

method forceRedraw(control: Control) =
  discard
  # should be implemented by ControlImpl

method canvas(control: Control): Canvas = control.fCanvas

method handleDisposeEvent(control: Control, event: ControlDisposeEvent) =
  # can be overriden by custom window
  let callback = control.onDispose
  if callback != nil:
    callback(event)

method handleDrawEvent(control: Control, event: DrawEvent) =
  # can be implemented by custom control
  let callback = control.onDraw
  if callback != nil:
    callback(event)

method handleMouseButtonDownEvent(control: Control, event: MouseButtonEvent) =
  # can be implemented by custom control
  let callback = control.onMouseButtonDown
  if callback != nil:
    callback(event)

method handleMouseButtonUpEvent(control: Control, event: MouseButtonEvent) =
  # can be implemented by custom control
  let callback = control.onMouseButtonUp
  if callback != nil:
    callback(event)

method handleClickEvent(control: Control, event: ClickEvent) =
  # can be overridden by custom button
  let callback = control.onClick
  if callback != nil:
    callback(event)

method handleKeyDownEvent(control: Control, event: ControlKeyEvent) =
  # can be implemented by custom control
  let callback = control.onKeyDown
  if callback != nil:
    callback(event)

method handleTextChangeEvent(control: Control, event: TextChangeEvent) =
  # can be implemented by custom control
  let callback = control.onTextChange
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

method onKeyDown(control: Control): ControlKeyProc = control.fOnKeyDown
method `onKeyDown=`(control: Control, callback: ControlKeyProc) = control.fOnKeyDown = callback

method onTextChange(control: Control): TextChangeProc = control.fOnTextChange
method `onTextChange=`(control: Control, callback: TextChangeProc) = control.fOnTextChange = callback


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
  control.fIndex = 0
  container.triggerRelayout()

method remove(container: Container, control: Control) =
  discard
  # if container != control.fParentControl:
    # raiseError("control can not be removed because it is not member of the container")
  # else:
    # let startIndex = control.fIndex
    # container.childControls.del(control.fIndex)
    # for i in startIndex..container.childControls.high:
      # container.childControl[i].fIndex = i
    # control.parentControl = nil

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

method getPadding(container: Container): Spacing =
  if container.frame != nil and container.frame.visible:
    result = container.frame.getPadding()

method setInnerSize(container: Container, width, height: int) = discard
  # should be extended by ContainerImpl

method updateInnerSize(container: Container, pInnerWidth, pInnerHeight: int) {.base.} =
  let padding = container.getPadding()
  let clientWidth = container.width - padding.left - padding.right
  let clientHeight = container.height - padding.top - padding.bottom
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
  container.updateInnerSize(innerWidth - padding.left - padding.right, innerHeight - padding.top - padding.bottom)

method `onDraw=`(container: ContainerImpl, callback: DrawProc) = raiseError("ContainerImpl does not allow onDraw.")


# ----------------------------------------------------------------------------------------
#                                   LayoutContainer
# ----------------------------------------------------------------------------------------

proc newLayoutContainer(layout: Layout): LayoutContainer =
  result = new LayoutContainer
  result.init()
  result.layout = layout
  result.xAlign = XAlign_Left
  result.yAlign = YAlign_Top
  result.spacing = 4
  result.padding = 2

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
  result = max(result, container.fMinHeight)

method setControlPosition(container: LayoutContainer, control: Control, x, y: int) =
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
  let clientWidth = container.width - padding.left - padding.right
  let clientHeight = container.height - padding.top - padding.bottom
  # echo "  client size: " & $clientWidth & ", " & $clientHeight
  var minInnerWidth = 0
  var minInnerHeight = 0
  var expandWidthCount = 0
  var expandHeightCount = 0

  # Calculate minimum needed size:
  for control in container.fChildControls:
    if not control.visible:
      continue

    if control.widthMode == WidthMode_Expand:
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

    if control.heightMode == HeightMode_Expand:
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
  if (container.yAlign == YAlign_Center or (container.yAlign == YAlign_Spread and container.childControls.len == 1)) and (container.layout == Layout_Horizontal or expandHeightCount == 0):
    y.inc(dynamicHeight div 2)

  for control in container.fChildControls:
    if not control.visible:
      continue
    # echo "  child: " & control.tag

    # Size:
    var width = control.width
    var height = control.height
    # echo "size old: " & $width & ", " $height
    if control.widthMode == WidthMode_Expand or control.wantedWidth == -1:
      if container.layout == Layout_Horizontal:
        if expandWidthCount > 0:
          width = control.minWidth + dynamicWidth div expandWidthCount
        else:
          width = control.minWidth + dynamicWidth
      else:
        width = clientWidth - container.padding * 2
    elif control.widthMode == WidthMode_Auto:
      width = control.wantedWidth
    elif control.widthMode == WidthMode_Fill:
      width = clientWidth - container.padding * 2

    if control.minWidth > width:
      width = control.minWidth
    if control.maxWidth > 0 and control.maxWidth < width:
      width = control.maxWidth

    if control.heightMode == HeightMode_Expand or control.wantedHeight == -1:
      if container.layout == Layout_Vertical:
        if expandHeightCount > 0:
          height = control.minHeight + dynamicHeight div expandHeightCount
        else:
          height = control.minHeight + dynamicHeight
      else:
        height = clientHeight - container.padding * 2
    elif control.heightMode == HeightMode_Auto:
      height = control.wantedHeight
    elif control.heightMode == HeightMode_Fill:
      height = clientHeight - container.padding * 2

    if control.minHeight > height:
      height = control.minHeight
    if control.maxHeight > 0 and control.maxHeight < height:
      height = control.maxHeight

    if control.width != width or control.height != height:
      # echo "  child: " & control.tag
      # echo "    new size: " & $width & ", " & $height
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
      # echo "    new pos: " & $x & ", " $y
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
  frame.fText = ""

method text(frame: Frame): string = frame.fText

method `text=`(frame: Frame, text: string) =
  frame.fText = text
  frame.tag = text
  # should be extended by NativeFrame

method getPadding(frame: Frame): Spacing =
  result.left = 4
  result.right = 4
  result.top = 4
  result.bottom = 4
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
  button.fText = ""
  button.fOnClick = nil
  button.fWidthMode = WidthMode_Auto
  button.fHeightMode = HeightMode_Auto
  button.minWidth = 15
  button.minHeight = 15

method text(button: Button): string = button.fText

method `text=`(button: Button, text: string) =
  button.fText = text
  button.tag = text
  button.triggerRelayoutIfModeIsAuto()
  # should be extended by NativeButton

method naturalWidth(button: Button): int = button.getTextWidth(button.text) + 20

method naturalHeight(button: Button): int = button.getTextLineHeight() * button.text.countLines + 12

method `onDraw=`(container: NativeButton, callback: DrawProc) = raiseError("NativeButton does not allow onDraw.")


# ----------------------------------------------------------------------------------------
#                                        Label
# ----------------------------------------------------------------------------------------

proc newLabel(text = ""): Label =
  result = new NativeLabel
  result.NativeLabel.init()
  result.text = text

proc init(label: Label) =
  label.ControlImpl.init()
  label.fText = ""
  label.fWidthMode = WidthMode_Auto
  label.fHeightMode = HeightMode_Auto
  label.minWidth = 10
  label.minHeight = 10

method text(label: Label): string = label.fText

method `text=`(label: Label, text: string) =
  label.fText = text
  label.tag = text
  label.triggerRelayoutIfModeIsAuto()

method naturalWidth(label: Label): int = label.getTextWidth(label.text)

method naturalHeight(label: Label): int = label.getTextLineHeight() * label.text.countLines

method `onDraw=`(container: NativeLabel, callback: DrawProc) = raiseError("NativeLabel does not allow onDraw.")


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
  textBox.minWidth = 20
  textBox.minHeight = 20

method naturalHeight(textBox: TextBox): int = textBox.getTextLineHeight()

method text(textBox: TextBox): string = discard
  # has to be implemented by NativeTextBox

method `text=`(textBox: TextBox, text: string) = discard
  # has to be implemented by NativeTextBox

method `onDraw=`(container: NativeTextBox, callback: DrawProc) = raiseError("NativeTextBox does not allow onDraw.")


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
  textArea.minWidth = 20
  textArea.minHeight = 20
  textArea.wrap = true

method text(textArea: TextArea): string = discard
  # has to be implemented by NativeTextBox

method `text=`(textArea: TextArea, text: string) = discard
  # has to be implemented by NativeTextBox

method addText(textArea: TextArea, text: string) = textArea.text = textArea.text & text

method addLine(textArea: TextArea, text = "") = textArea.addtext(text & "\n")

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

include nigui_platform_impl
