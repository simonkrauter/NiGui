# NiGui - GTK+ 3 platform-specific code - part 3

# This file will be included in "nigui.nim".

# Imports:
# math, os, strutils, times are imported by nigui.nim
import gtk3
import tables
import hashes


# ----------------------------------------------------------------------------------------
#                                    Internal Things
# ----------------------------------------------------------------------------------------

const pFontSizeFactor = 700

# needed to calculate clicks:
var pLastMouseButtonDownControl: ControlImpl
var pLastMouseButtonDownControlX: int
var pLastMouseButtonDownControlY: int

var pClipboardPtr: pointer
var pClipboardText: string
var pClipboardTextIsSet: bool

proc pRaiseGError(error: ptr GError) =
  if error == nil:
    raiseError("Unkown error")
  raiseError($error.message)

proc pColorToGdkRGBA(color: Color, rgba: var GdkRGBA) =
  rgba.red = color.red.float / 255
  rgba.green = color.green.float / 255
  rgba.blue = color.blue.float / 255
  rgba.alpha = color.alpha.float / 255

proc pGdkRGBAToColor(rgba: var GdkRGBA): Color =
  result.red = uint8(rgba.red.float * 255)
  result.green = uint8(rgba.green.float * 255)
  result.blue = uint8(rgba.blue.float * 255)
  result.alpha = uint8(rgba.alpha.float * 255)

proc pWindowDeleteSignal(widgetHandle, event, data: pointer): Gboolean {.cdecl.} =
  let window = cast[WindowImpl](data)
  window.closeClick()
  return true

proc pWindowConfigureSignal(windowHandle, event, data: pointer): Gboolean {.cdecl.} =
  # called on resize and move
  let window = cast[WindowImpl](data)
  var x, y: cint
  gtk_window_get_position(window.fHandle, x, y)
  window.fX = x
  window.fY = y
  var width, height: cint
  gtk_window_get_size(window.fHandle, width, height)
  window.fWidth = width
  window.fHeight = height
  window.fClientWidth = width
  window.fClientHeight = height
  var event = new ResizeEvent
  event.window = window
  window.handleResizeEvent(event)
  window.triggerRelayout()

proc pKeyvalToKey(keyval: cint): Key =
  result = case keyval

  # the following block is probably only correct for german keyboard layout
  of 39: Key_NumberSign
  of 42: Key_Plus
  of 58: Key_Point
  of 59: Key_Comma
  of 95: Key_Minus

  of 97: Key_A
  of 98: Key_B
  of 99: Key_C
  of 100: Key_D
  of 101: Key_E
  of 102: Key_F
  of 103: Key_G
  of 104: Key_H
  of 105: Key_I
  of 106: Key_J
  of 107: Key_K
  of 108: Key_L
  of 109: Key_M
  of 110: Key_N
  of 111: Key_O
  of 112: Key_P
  of 113: Key_Q
  of 114: Key_R
  of 115: Key_S
  of 116: Key_T
  of 117: Key_U
  of 118: Key_V
  of 119: Key_W
  of 120: Key_X
  of 121: Key_Y
  of 122: Key_Z
  of 228: Key_AE
  of 246: Key_OE
  of 252: Key_UE
  of 65027: Key_AltGr
  of 65106: Key_Circumflex
  of 65288: Key_Backspace
  of 65289: Key_Tab
  of 65293: Key_Return
  of 65299: Key_Pause
  of 65300: Key_ScrollLock
  of 65307: Key_Escape
  of 65379: Key_Insert
  of 65360: Key_Home
  of 65361: Key_Left
  of 65362: Key_Up
  of 65363: Key_Right
  of 65364: Key_Down
  of 65365: Key_PageUp
  of 65366: Key_PageDown
  of 65367: Key_End
  of 65377: Key_Print
  of 65383: Key_ContextMenu
  of 65407: Key_NumLock
  of 65421: Key_NumpadEnter
  of 65450: Key_NumpadMultiply
  of 65451: Key_NumpadAdd
  of 65452: Key_NumpadSeparator
  of 65453: Key_NumpadSubtract
  of 65454: Key_NumpadDecimal
  of 65455: Key_NumpadDivide
  of 65456: Key_Numpad0
  of 65457: Key_Numpad1
  of 65458: Key_Numpad2
  of 65459: Key_Numpad3
  of 65460: Key_Numpad4
  of 65461: Key_Numpad5
  of 65462: Key_Numpad6
  of 65463: Key_Numpad7
  of 65464: Key_Numpad8
  of 65465: Key_Numpad9
  of 65470: Key_F1
  of 65471: Key_F2
  of 65472: Key_F3
  of 65473: Key_F4
  of 65474: Key_F5
  of 65475: Key_F6
  of 65476: Key_F7
  of 65477: Key_F8
  of 65478: Key_F9
  of 65479: Key_F10
  of 65480: Key_F11
  of 65481: Key_F12
  of 65482: Key_F13
  of 65483: Key_F14
  of 65484: Key_F15
  of 65485: Key_F16
  of 65486: Key_F17
  of 65487: Key_F18
  of 65488: Key_F19
  of 65489: Key_F20
  of 65490: Key_F21
  of 65491: Key_F22
  of 65492: Key_F23
  of 65493: Key_F24
  of 65505: Key_ShiftL
  of 65506: Key_ShiftR
  of 65507: Key_ControlL
  of 65508: Key_ControlR
  of 65509: Key_CapsLock
  of 65513: Key_AltL
  of 65514: Key_AltR
  of 65515: Key_SuperL
  of 65516: Key_SuperR
  of 65535: Key_Delete
  else: cast[Key](keyval)

proc pWindowKeyPressSignal(widget: pointer, event: var GdkEventKey, data: pointer): Gboolean {.cdecl.} =
  let window = cast[WindowImpl](data)
  window.fKeyPressed = pKeyvalToKey(event.keyval)
  internalKeyDown(window.fKeyPressed)
  if gtk_im_context_filter_keypress(window.fIMContext, event) and window.fKeyPressed == Key_None:
    return
  var evt = new KeyboardEvent
  evt.window = window
  evt.key = window.fKeyPressed
  if evt.key == Key_None:
    echo "Unkown key value: ", event.keyval
    return
  evt.character = $event.`string`
  evt.unicode = gdk_keyval_to_unicode(event.keyval)
  try:
    window.handleKeyDownEvent(evt)
  except:
    handleException()
  result = evt.handled

proc pWindowKeyReleaseSignal(widget: pointer, event: var GdkEventKey): Gboolean {.cdecl.} =
  internalKeyUp(pKeyvalToKey(event.keyval))

proc pControlKeyPressSignal(widget: pointer, event: var GdkEventKey, data: pointer): Gboolean {.cdecl.} =
  let control = cast[ControlImpl](data)
  let key = pKeyvalToKey(event.keyval)
  control.fKeyPressed = key
  if gtk_im_context_filter_keypress(control.fIMContext, event):
    return control.fKeyPressed == Key_None
  var evt = new KeyboardEvent
  evt.control = control
  evt.key = key
  if evt.key == Key_None:
    echo "Unkown key value: ", event.keyval
    return
  evt.character = $event.`string`
  evt.unicode = gdk_keyval_to_unicode(event.keyval)
  try:
    control.handleKeyDownEvent(evt)
  except:
    handleException()
  result = evt.handled

proc pWindowIMContextCommitSignal(context: pointer, str: cstring, data: pointer) {.cdecl.} =
  let window = cast[WindowImpl](data)
  var evt = new KeyboardEvent
  evt.window = window
  evt.character = $str
  evt.unicode = evt.character.runeAt(0).toUpper().int
  evt.key = window.fKeyPressed
  window.fKeyPressed = Key_None
  try:
    window.handleKeyDownEvent(evt)
  except:
    handleException()

proc pControlIMContextCommitSignal(context: pointer, str: cstring, data: pointer) {.cdecl.} =
  let control = cast[ControlImpl](data)
  var evt = new KeyboardEvent
  evt.control = control
  evt.character = $str
  evt.unicode = evt.character.runeAt(0).toUpper().int
  evt.key = control.fKeyPressed
  try:
    control.handleKeyDownEvent(evt)
    if evt.handled:
      control.fKeyPressed = Key_None
  except:
    handleException()

method focus(control: ControlImpl) =
  gtk_widget_grab_focus(control.fHandle)

method focus(control: NativeTextArea) =
  gtk_widget_grab_focus(control.fTextViewHandle)

proc pDefaultControlButtonPressSignal(widget: pointer, event: var GdkEventButton, data: pointer): Gboolean {.cdecl.} =
  let control = cast[ControlImpl](data)
  let x = event.x.int
  let y = event.y.int
  var evt = new MouseEvent
  evt.control = control
  case event.button
  of 1: evt.button = MouseButton_Left
  of 2: evt.button = MouseButton_Middle
  of 3: evt.button = MouseButton_Right
  else: return # TODO
  evt.x = x
  evt.y = y

  try:
    control.handleMouseButtonDownEvent(evt)
  except:
    handleException()

  pLastMouseButtonDownControl = control
  pLastMouseButtonDownControlX = x
  pLastMouseButtonDownControlY = y

proc pCustomControlButtonPressSignal(widget: pointer, event: var GdkEventButton, data: pointer): Gboolean {.cdecl.} =
  discard pDefaultControlButtonPressSignal(widget, event, data)
  let control = cast[ControlImpl](data)
  control.focus()
  result = true # Stop propagation, required to detect clicks

proc pControlButtonReleaseSignal(widget: pointer, event: var GdkEventButton, data: pointer): Gboolean {.cdecl.} =
  let control = cast[ControlImpl](data)
  let x = event.x.int
  let y = event.y.int
  if not (x >= 0 and x < control.width and y >= 0 and y < control.height):
    return
  var evt = new MouseEvent
  evt.control = control
  case event.button
  of 1: evt.button = MouseButton_Left
  of 2: evt.button = MouseButton_Middle
  of 3: evt.button = MouseButton_Right
  else: return # TODO
  evt.x = x
  evt.y = y
  control.handleMouseButtonUpEvent(evt)
  if event.button == 1 and control == pLastMouseButtonDownControl and abs(x - pLastMouseButtonDownControlX) <= clickMaxXYMove and abs(y - pLastMouseButtonDownControlY) <= clickMaxXYMove:
    var clickEvent = new ClickEvent
    clickEvent.control = control
    try:
      control.handleClickEvent(clickEvent)
    except:
      handleException()
  # result = true # stop propagation

proc pControlChangedSignal(widget: pointer, data: pointer): Gboolean {.cdecl.} =
  let control = cast[TextBox](data)
  var evt = new TextChangeEvent
  evt.control = control
  try:
    control.handleTextChangeEvent(evt)
  except:
    handleException()

# proc pTextAreaEndUserActionSignal(widget: pointer, data: pointer): Gboolean {.cdecl.} =
  # let control = cast[ControlImpl](data)
  # discard

proc pSetDragDest(widget: pointer) =
  var target: GtkTargetEntry
  target.target = "text/uri-list"
  gtk_drag_dest_set(widget, GTK_DEST_DEFAULT_ALL, target.addr, 1, GDK_ACTION_COPY)

proc pCreateFont(fontFamily: string, fontSize: float, fontBold: bool): pointer =
  result = pango_font_description_new()
  pango_font_description_set_family(result, fontFamily)
  pango_font_description_set_size(result, cint(fontSize * pFontSizeFactor))
  if fontBold:
    pango_font_description_set_weight(result, 700)
  else:
    pango_font_description_set_weight(result, 400)


# ----------------------------------------------------------------------------------------
#                                    App Procedures
# ----------------------------------------------------------------------------------------

var pQueue: int

proc init(app: App) =
  gtk_init(nil, nil)

  pClipboardPtr = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD)

  # Determine default styles:
  var window = gtk_window_new(GTK_WINDOW_TOPLEVEL)
  var context = gtk_widget_get_style_context(window)
  var rgba: GdkRGBA
  gtk_style_context_get_background_color(context, GTK_STATE_FLAG_NORMAL, rgba)
  app.defaultBackgroundColor = rgba.pGdkRGBAToColor()
  gtk_style_context_get_color(context, GTK_STATE_FLAG_NORMAL, rgba)
  app.defaultTextColor = rgba.pGdkRGBAToColor()
  gtk_widget_destroy(window)

proc runMainLoop() = gtk_main()

proc platformQuit() =
  gtk_main_quit()

proc processEvents(app: App) =
  while gtk_events_pending() == 1:
    discard gtk_main_iteration()

proc runQueuedFn(data: pointer): cint {.exportc.} =
  var fn = cast[ptr proc()](data)
  fn[]()
  freeShared(fn)
  dec pQueue
  return 0

proc queueMain(app: App, fn: proc()) =
  inc pQueue
  var p = createShared(proc())
  p[] = fn
  discard gdk_threads_add_idle(runQueuedFn, p)

proc queued(app: App): int =
  return pQueue

proc pClipboardTextReceivedFunc(clipboard: pointer, text: cstring, data: pointer): Gboolean {.cdecl.} =
  pClipboardText = $text # string needs to be copied
  pClipboardTextIsSet = true

proc clipboardText(app: App): string =
  pClipboardTextIsSet = false
  gtk_clipboard_request_text(pClipboardPtr, pClipboardTextReceivedFunc, nil)
  while not pClipboardTextIsSet:
    discard gtk_main_iteration()
  result = pClipboardText

proc `clipboardText=`(app: App, text: string) =
  gtk_clipboard_set_text(pClipboardPtr, text, text.len.cint)
  gtk_clipboard_store(pClipboardPtr)


# ----------------------------------------------------------------------------------------
#                                       Dialogs
# ----------------------------------------------------------------------------------------

proc alert(window: Window, message: string, title = "Message") =
  var dialog = gtk_dialog_new()
  gtk_window_set_title(dialog, title)
  gtk_window_resize(dialog, 200, 70)
  let contentArea = gtk_dialog_get_content_area(dialog)
  gtk_container_set_border_width(contentArea, 15)
  var label = gtk_label_new(message)
  gtk_widget_show(label)
  gtk_box_pack_start(contentArea, label, 0, 0, 0)
  let actionArea = gtk_dialog_get_action_area(dialog)
  gtk_button_box_set_layout(actionArea, GTK_BUTTONBOX_EXPAND)
  gtk_widget_set_margin_top(actionArea, 15)
  discard gtk_dialog_add_button(dialog, "OK", 1)
  if window != nil:
    gtk_window_set_transient_for(dialog, cast[WindowImpl](window).fHandle)
  discard gtk_dialog_run(dialog)
  gtk_widget_hide(dialog)

method run*(dialog: OpenFileDialog) =
  dialog.files = @[]
  var chooser = gtk_file_chooser_dialog_new(dialog.title, nil, GTK_FILE_CHOOSER_ACTION_OPEN, "Cancel", GTK_RESPONSE_CANCEL, "Open", GTK_RESPONSE_ACCEPT, nil)
  discard gtk_file_chooser_set_current_folder(chooser, dialog.directory)
  gtk_file_chooser_set_select_multiple(chooser, dialog.multiple)
  let res = gtk_dialog_run(chooser)
  if res == GTK_RESPONSE_ACCEPT:
    let list = gtk_file_chooser_get_filenames(chooser)
    let count = g_slist_length(list)
    for i in 0..count - 1:
      dialog.files.add($g_slist_nth_data(list, i))
  gtk_widget_destroy(chooser)

method run(dialog: SaveFileDialog) =
  var chooser = gtk_file_chooser_dialog_new(dialog.title, nil, GTK_FILE_CHOOSER_ACTION_SAVE, "Cancel", GTK_RESPONSE_CANCEL, "Save", GTK_RESPONSE_ACCEPT, nil)
  let res = gtk_dialog_run(chooser)
  discard gtk_file_chooser_set_current_folder(chooser, dialog.directory)
  if dialog.defaultName.len > 0:
    discard gtk_file_chooser_set_current_name(chooser, dialog.defaultName) # Issue: does not work
  if res == GTK_RESPONSE_ACCEPT:
    dialog.file = $gtk_file_chooser_get_filename(chooser)
  else:
    dialog.file = ""
  gtk_widget_destroy(chooser)

method run*(dialog: SelectDirectoryDialog) =
  dialog.selectedDirectory = ""
  var chooser = gtk_file_chooser_dialog_new(dialog.title, nil, GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER, "Cancel", GTK_RESPONSE_CANCEL, "Select", GTK_RESPONSE_ACCEPT, nil)
  discard gtk_file_chooser_set_current_folder(chooser, dialog.startDirectory)
  let res = gtk_dialog_run(chooser)
  if res == GTK_RESPONSE_ACCEPT:
    dialog.selectedDirectory = $gtk_file_chooser_get_filename(chooser)
  gtk_widget_destroy(chooser)


# ----------------------------------------------------------------------------------------
#                                       Timers
# ----------------------------------------------------------------------------------------

type TimerEntry = object
  timerInternalId: cint
  timerProc: TimerProc
  data: pointer

var
  pTimers = initTable[int64, TimerEntry]()
  pNextTimerId: int = 1

proc pTimerFunction(timer: Timer): Gboolean {.cdecl.} =
  let timerEntry = pTimers.getOrDefault(cast[int](timer))
  var event = new TimerEvent
  event.timer = timer
  event.data = timerEntry.data
  timerEntry.timerProc(event)
  pTimers.del(cast[int](timer))
  # result is false to stop timer

proc pRepeatingTimerFunction(timer: Timer): Gboolean {.cdecl.} =
  let timerEntry = pTimers.getOrDefault(cast[int](timer))
  var event = new TimerEvent
  event.timer = timer
  event.data = timerEntry.data
  timerEntry.timerProc(event)
  result = true # repeat timer

proc startTimer(milliSeconds: int, timerProc: TimerProc, data: pointer = nil): Timer =
  var timerEntry: TimerEntry
  timerEntry.timerInternalId = g_timeout_add(milliSeconds.cint, pTimerFunction, cast[pointer](pNextTimerId))
  timerEntry.timerProc = timerProc
  timerEntry.data = data
  pTimers[pNextTimerId] = timerEntry
  result = cast[Timer](pNextTimerId)
  pNextTimerId.inc()
  if pNextTimerId == inactiveTimer:
    pNextTimerId.inc()

proc startRepeatingTimer(milliSeconds: int, timerProc: TimerProc, data: pointer = nil): Timer =
  var timerEntry: TimerEntry
  timerEntry.timerInternalId = g_timeout_add(milliSeconds.cint, pRepeatingTimerFunction, cast[pointer](pNextTimerId))
  timerEntry.timerProc = timerProc
  timerEntry.data = data
  pTimers[pNextTimerId] = timerEntry
  result = cast[Timer](pNextTimerId)
  pNextTimerId.inc()
  if pNextTimerId == inactiveTimer:
    pNextTimerId.inc()

proc stop(timer: var Timer) =
  if cast[int](timer) != inactiveTimer:
    let timerEntry = pTimers.getOrDefault(cast[int](timer))
    pTimers.del(cast[int](timer))
    discard g_source_remove(timerEntry.timerInternalId)
    timer = cast[Timer](inactiveTimer)


# ----------------------------------------------------------------------------------------
#                                       Canvas
# ----------------------------------------------------------------------------------------

proc pUpdateFont(canvas: Canvas) =
  let canvasImpl = cast[CanvasImpl](canvas)
  canvasImpl.fFont = pCreateFont(canvas.fontFamily, canvas.fontSize, canvas.fontBold)

method drawText(canvas: Canvas, text: string, x, y = 0) =
  let canvasImpl = cast[CanvasImpl](canvas)
  let cr = canvasImpl.fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.textColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)

  var layout = pango_cairo_create_layout(cr)
  pango_layout_set_text(layout, text, text.len.cint)

  if canvasImpl.fFont == nil:
    canvas.pUpdateFont()
  pango_layout_set_font_description(layout, canvasImpl.fFont)

  cairo_save(cr)
  cairo_translate(cr, x.float, y.float)
  pango_cairo_show_layout(cr, layout)
  cairo_restore(cr)

method drawLine(canvas: Canvas, x1, y1, x2, y2: int) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.lineColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)
  cairo_move_to(cr, x1.float, y1.float)
  cairo_line_to(cr, x2.float, y2.float)
  cairo_set_line_width(cr, canvas.lineWidth)
  cairo_stroke(cr)

method drawRectArea(canvas: Canvas, x, y, width, height: int) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.areaColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)
  cairo_rectangle(cr, x.float, y.float, width.float, height.float)
  cairo_fill(cr)

method drawRectOutline(canvas: Canvas, x, y, width, height: int) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.lineColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)
  cairo_rectangle(cr, x.float, y.float, width.float, height.float)
  cairo_set_line_width(cr, canvas.lineWidth)
  cairo_stroke(cr)

method drawEllipseArea(canvas: Canvas, x, y, width, height: int) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.areaColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)
  cairo_save(cr)
  let centerX = x.float + width.float / 2
  let centerY = y.float + height.float / 2
  cairo_translate(cr, centerX, centerY)
  cairo_scale(cr, width.float / 2, height.float / 2)
  cairo_arc(cr, 0, 0, 1, 0, 2 * PI)
  cairo_fill(cr)
  cairo_restore(cr)

method drawEllipseOutline(canvas: Canvas, x, y, width, height: int) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.lineColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)
  cairo_save(cr)
  let centerX = x.float + width.float / 2
  let centerY = y.float + height.float / 2
  cairo_translate(cr, centerX, centerY)
  cairo_scale(cr, width.float / 2, height.float / 2)
  cairo_arc(cr, 0, 0, 1, 0, 2 * PI)
  cairo_set_line_width(cr, canvas.lineWidth / width.float * 2)
  # problem: width of horizontal line and vertical line is not the same
  cairo_stroke(cr)
  cairo_restore(cr)

method drawArcOutline(canvas: Canvas, centerX, centerY: int, radius, startAngle, sweepAngle: float) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.lineColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)
  cairo_arc(cr, centerX.float, centerY.float, radius, startAngle, sweepAngle)
  cairo_set_line_width(cr, canvas.lineWidth)
  cairo_stroke(cr)

method drawImage(canvas: Canvas, image: Image, x, y = 0, width, height = -1) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  let imageCanvas = cast[CanvasImpl](image.canvas)
  if imageCanvas.fSurface == nil:
    raiseError("Image is not initialized.")
  var drawWith = image.width
  var drawHeight = image.height
  if width != -1:
    drawWith = width
    drawHeight = int(drawHeight * drawWith / image.width)
  if height != -1:
    drawHeight = height
  if drawWith == image.width and drawHeight == image.height:
    cairo_set_source_surface(cr, imageCanvas.fSurface, x.cdouble, y.cdouble)
    cairo_paint(cr)
  else:
    cairo_save(cr)
    cairo_translate(cr, x.cdouble, y.cdouble)
    cairo_scale(cr, drawWith / image.width, drawHeight / image.height)
    cairo_set_source_surface(cr, imageCanvas.fSurface, 0, 0)
    case canvas.interpolationMode:
      of InterpolationMode_Default:         discard
      of InterpolationMode_NearestNeighbor: cairo_pattern_set_filter(cairo_get_source(cr), CAIRO_FILTER_NEAREST)
      of InterpolationMode_Bilinear:        cairo_pattern_set_filter(cairo_get_source(cr), CAIRO_FILTER_BILINEAR)
    cairo_paint(cr)
    cairo_restore(cr)

method setPixel(canvas: Canvas, x, y: int, color: Color) =
  let canvasImpl = cast[CanvasImpl](canvas)
  let cr = canvasImpl.fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  if canvasImpl.fData == nil:
    # For a Canvas of a Control we can't access the memory directly, so draw a rectangle (slower)
    var rgba: GdkRGBA
    color.pColorToGdkRGBA(rgba)
    gdk_cairo_set_source_rgba(cr, rgba)
    cairo_rectangle(cr, x.float, y.float, 1, 1)
    cairo_fill(cr)
  else:
    # For a Canvas of an Image we can write in the memory directly (faster)
    if x < 0 or y < 0 or x >= canvas.width or y >= canvas.height:
      raiseError("Pixel is out of range.")
    cairo_surface_flush(canvasImpl.fSurface)
    let i = y * canvasImpl.fStride + x * 4
    canvasImpl.fData[i + 0] = color.blue
    canvasImpl.fData[i + 1] = color.green
    canvasImpl.fData[i + 2] = color.red
    canvasImpl.fData[i + 3] = 255
    cairo_surface_mark_dirty(canvasImpl.fSurface)

method `fontFamily=`(canvas: CanvasImpl, fontFamily: string) =
  procCall canvas.Canvas.`fontFamily=`(fontFamily)
  canvas.fFont = nil

method `fontSize=`(canvas: CanvasImpl, fontSize: float) =
  procCall canvas.Canvas.`fontSize=`(fontSize)
  canvas.fFont = nil

method `fontBold=`(canvas: CanvasImpl, fontBold: bool) =
  procCall canvas.Canvas.`fontBold=`(fontBold)
  canvas.fFont = nil

method getTextLineWidth(canvas: CanvasImpl, text: string): int {.locks: "unknown".} =
  if canvas.fCairoContext == nil:
    raiseError("Canvas is not in drawing state.")
  var layout = pango_cairo_create_layout(canvas.fCairoContext)
  pango_layout_set_text(layout, text, text.len.cint)
  if canvas.fFont == nil:
    canvas.pUpdateFont()
  pango_layout_set_font_description(layout, canvas.fFont)
  var width: cint
  var height: cint
  pango_layout_get_pixel_size(layout, width, height)
  result = width + 2

method getTextLineHeight(canvas: CanvasImpl): int {.locks: "unknown".} =
  if canvas.fCairoContext == nil:
    raiseError("Canvas is not in drawing state.")
  var layout = pango_cairo_create_layout(canvas.fCairoContext)
  pango_layout_set_text(layout, "a", 1)
  if canvas.fFont == nil:
    canvas.pUpdateFont()
  pango_layout_set_font_description(layout, canvas.fFont)
  var width: cint
  var height: cint
  pango_layout_get_pixel_size(layout, width, height)
  result = height


# ----------------------------------------------------------------------------------------
#                                        Image
# ----------------------------------------------------------------------------------------

method resize(image: Image, width, height: int) =
  let canvas = cast[CanvasImpl](image.fCanvas)
  if canvas.fSurface != nil:
    cairo_surface_destroy(canvas.fSurface)
  canvas.fSurface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width.cint, height.cint)
  canvas.fCairoContext = cairo_create(canvas.fSurface)
  canvas.fData = cairo_image_surface_get_data(canvas.fSurface)
  canvas.fStride = cairo_image_surface_get_stride(canvas.fSurface)
  image.canvas.fWidth = width
  image.canvas.fHeight = height

method loadFromFile(image: Image, filePath: string) =
  let canvas = cast[CanvasImpl](image.fCanvas)
  if canvas.fSurface != nil:
    cairo_surface_destroy(canvas.fSurface)
  image.canvas.fWidth = 0
  image.canvas.fHeight = 0
  var error: ptr GError
  var pixbuf = gdk_pixbuf_new_from_file(filePath, error.addr)
  if pixbuf == nil:
    pRaiseGError(error)
  defer: g_object_unref(pixbuf)
  var pixbufRotated = gdk_pixbuf_apply_embedded_orientation(pixbuf)
  defer: g_object_unref(pixbufRotated)
  canvas.fSurface = gdk_cairo_surface_create_from_pixbuf(pixbufRotated, 1, nil)
  canvas.fCairoContext = cairo_create(canvas.fSurface)
  canvas.fData = cairo_image_surface_get_data(canvas.fSurface)
  canvas.fStride = cairo_image_surface_get_stride(canvas.fSurface)
  image.canvas.fWidth = cairo_image_surface_get_width(canvas.fSurface)
  image.canvas.fHeight = cairo_image_surface_get_height(canvas.fSurface)

method saveToBitmapFile(image: Image, filePath: string) =
  let canvas = cast[CanvasImpl](image.fCanvas)
  var pixbuf = gdk_pixbuf_get_from_surface(canvas.fSurface, 0, 0, image.width.cint, image.height.cint)
  defer: g_object_unref(pixbuf)
  var error: ptr GError
  if not gdk_pixbuf_save(pixbuf, filePath, "bmp", error.addr, nil, nil, nil):
    pRaiseGError(error)

method saveToPngFile(image: Image, filePath: string) =
  let canvas = cast[CanvasImpl](image.fCanvas)
  var pixbuf = gdk_pixbuf_get_from_surface(canvas.fSurface, 0, 0, image.width.cint, image.height.cint)
  defer: g_object_unref(pixbuf)
  var error: ptr GError
  if not gdk_pixbuf_save(pixbuf, filePath, "png", error.addr, nil, nil, nil):
    pRaiseGError(error)

method saveToJpegFile(image: Image, filePath: string, quality = 80) =
  let canvas = cast[CanvasImpl](image.fCanvas)
  var pixbuf = gdk_pixbuf_get_from_surface(canvas.fSurface, 0, 0, image.width.cint, image.height.cint)
  defer: g_object_unref(pixbuf)
  var error: ptr GError
  if not gdk_pixbuf_save(pixbuf, filePath, "jpeg", error.addr, "quality", $quality, nil):
    pRaiseGError(error)

method beginPixelDataAccess(image: Image): ptr UncheckedArray[byte] =
  let canvas = cast[CanvasImpl](image.canvas)
  result = canvas.fData

method endPixelDataAccess(image: Image) =
  let canvas = cast[CanvasImpl](image.canvas)
  cairo_surface_mark_dirty(canvas.fSurface)


# ----------------------------------------------------------------------------------------
#                                        Window
# ----------------------------------------------------------------------------------------

proc pWindowDragDataReceivedSignal(widget, context: pointer, x, y: cint, data: pointer, info, time: cint, user_data: pointer) {.cdecl.} =
  let window = cast[WindowImpl](user_data)
  var files: seq[string] = @[]
  var p = gtk_selection_data_get_uris(data)
  while p[] != nil:
    files.add($g_filename_from_uri(p[]))
    p = cast[ptr cstring](cast[int](p) + 8)
  var event = new DropFilesEvent
  event.window = window
  event.files = files
  window.handleDropFilesEvent(event)

proc pMainScrollbarDraw(widget: pointer, cr: pointer, data: pointer): Gboolean {.cdecl.} =
  # This proc is there to get the scrollbar size
  if fScrollbarSize == -1:
    var scrollbar = gtk_scrolled_window_get_hscrollbar(widget)
    var allocation: GdkRectangle
    gtk_widget_get_allocation(scrollbar, allocation)
    gtk_scrolled_window_set_policy(widget, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
    fScrollbarSize = allocation.height
    for window in windowList:
      if window.control != nil:
        window.control.triggerRelayoutDownwards()

proc pWindowStateEventSignal(widget: pointer, event: var GdkEventWindowState, user_data: pointer): Gboolean {.cdecl.} =
  let window = cast[WindowImpl](user_data)
  window.fMinimized = (event.new_window_state and GDK_WINDOW_STATE_ICONIFIED) == GDK_WINDOW_STATE_ICONIFIED

proc pWindowFocusOutEventSignal(widget: pointer, event: var GdkEventFocus, user_data: pointer): Gboolean {.cdecl.} =
  internalAllKeysUp()

proc init(window: WindowImpl) =
  if pClipboardPtr == nil:
    gtk_init(nil, nil)
    raiseError("You need to call 'app.init()' at first.")
  window.fHandle = gtk_window_new(GTK_WINDOW_TOPLEVEL)
  window.fInnerHandle = gtk_scrolled_window_new(nil, nil)
  gtk_widget_show(window.fInnerHandle)
  gtk_container_add(window.fHandle, window.fInnerHandle)
  window.Window.init()
  discard g_signal_connect_data(window.fHandle, "delete-event", pWindowDeleteSignal, cast[pointer](window))
  discard g_signal_connect_data(window.fHandle, "configure-event", pWindowConfigureSignal, cast[pointer](window))
  discard g_signal_connect_data(window.fHandle, "key-press-event", pWindowKeyPressSignal, cast[pointer](window))
  discard g_signal_connect_data(window.fHandle, "key-release-event", pWindowKeyReleaseSignal, cast[pointer](window))
  discard g_signal_connect_data(window.fHandle, "window-state-event", pWindowStateEventSignal, cast[pointer](window))
  discard g_signal_connect_data(window.fHandle, "focus-out-event", pWindowFocusOutEventSignal, cast[pointer](window))

  # Enable drag and drop of files:
  pSetDragDest(window.fHandle)
  discard g_signal_connect_data(window.fHandle, "drag-data-received", pWindowDragDataReceivedSignal, cast[pointer](window))

  if fScrollbarSize == -1:
    gtk_scrolled_window_set_policy(window.fInnerHandle, GTK_POLICY_ALWAYS, GTK_POLICY_ALWAYS)
    discard g_signal_connect_data(window.fInnerHandle, "draw", pMainScrollbarDraw, nil)

  window.fIMContext = gtk_im_multicontext_new()
  discard g_signal_connect_data(window.fIMContext, "commit", pWindowIMContextCommitSignal, cast[pointer](window))

method destroy(window: WindowImpl) =
  procCall window.Window.destroy()
  gtk_widget_destroy(window.fHandle)
  # this destroys also child widgets
  window.fHandle = nil

method `visible=`(window: WindowImpl, visible: bool) =
  procCall window.Window.`visible=`(visible)
  if visible:
    # gtk_window_deiconify(window.fHandle)
    # gtk_widget_show(window.fHandle)
    gtk_window_present(window.fHandle)
    while fScrollbarSize == -1:
      discard gtk_main_iteration()
  else:
    gtk_widget_hide(window.fHandle)
  app.processEvents()

method showModal(window: WindowImpl, parent: Window) =
  # Overwrite base method
  gtk_window_set_modal(window.fHandle, 1)
  gtk_window_set_transient_for(window.fHandle, cast[WindowImpl](parent).fHandle)
  window.visible = true

method minimize(window: WindowImpl) =
  procCall window.Window.minimize()
  gtk_window_iconify(window.fHandle)

method `alwaysOnTop=`(window: WindowImpl, alwaysOnTop: bool) =
  procCall window.Window.`alwaysOnTop=`(alwaysOnTop)
  gtk_window_set_keep_above(window.fHandle, alwaysOnTop)

method `width=`*(window: WindowImpl, width: int) =
  procCall window.Window.`width=`(width)
  gtk_window_resize(window.fHandle, window.width.cint, window.height.cint)
  window.fClientWidth = window.width

method `height=`*(window: WindowImpl, height: int) =
  procCall window.Window.`height=`(height)
  gtk_window_resize(window.fHandle, window.width.cint, window.height.cint)
  window.fClientHeight = window.height

proc pUpdatePosition(window: WindowImpl) = gtk_window_move(window.fHandle, window.x.cint, window.y.cint)

method `x=`(window: WindowImpl, x: int) =
  procCall window.Window.`x=`(x)
  window.pUpdatePosition()

method `y=`(window: WindowImpl, y: int) =
  procCall window.Window.`y=`(y)
  window.pUpdatePosition()

method centerOnScreen(window: WindowImpl) {.locks: "unknown".} =
  let screen = gdk_screen_get_default()
  let monitor = gdk_screen_get_primary_monitor(screen)
  var rect: GdkRectangle
  gdk_screen_get_monitor_workarea(screen, monitor, rect)
  window.fX = rect.x + (rect.width - window.width) div 2
  window.fY = rect.y + (rect.height - window.height) div 2
  window.pUpdatePosition()

method `title=`(window: WindowImpl, title: string) =
  procCall window.Window.`title=`(title)
  gtk_window_set_title(window.fHandle, window.title.cstring)

method `control=`(window: WindowImpl, control: Control) =
  # Overwrite base method
  procCall window.Window.`control=`(control)
  gtk_container_add(window.fInnerHandle, cast[ControlImpl](control).fHandle)

method mousePosition(window: Window): tuple[x, y: int] =
  var x, y: cint
  gtk_widget_get_pointer(cast[WindowImpl](window).fHandle, x, y)
  result.x = x
  result.y = y

method `iconPath=`(window: WindowImpl, iconPath: string) =
  procCall window.Window.`iconPath=`(iconPath)
  if not gtk_window_set_icon_from_file(window.fHandle, iconPath, nil):
    if not fileExists(iconPath):
      raiseError("Faild to load image from file '" & iconPath & "': File does not exist")
    else:
      raiseError("Faild to load image from file '" & iconPath & "'")


# ----------------------------------------------------------------------------------------
#                                       Control
# ----------------------------------------------------------------------------------------

method pUpdateScrollBar(control: ControlImpl) {.base.}

method triggerRelayout(control: ControlImpl) =
  procCall control.Control.triggerRelayout()
  control.pUpdateScrollBar()

proc pControlDrawSignal(widget: pointer, cr: pointer, data: pointer): Gboolean {.cdecl.} =
  let control = cast[ControlImpl](data)

  # Trigger pUpdateScrollBar() in case it's not initialized, which could be because of missing fScrollbarSize
  if control.fHScrollbar == nil:
    control.pUpdateScrollBar()

  var event = new DrawEvent
  event.control = control
  var canvas = cast[CanvasImpl](control.canvas)
  if canvas == nil:
    canvas = newCanvas(control)
  canvas.fCairoContext = cr
  # canvas.fSurface = cairo_get_target(cr) # no need to set this
  # canvas.fData = cairo_image_surface_get_data(canvas.fSurface) # does not work
  try:
    # var region = gdk_window_get_clip_region(control.fHandle)
    # gdk_window_begin_paint_region(control.fHandle, region)
    # no effect

    control.handleDrawEvent(event)

    # gdk_window_end_paint(control.fHandle)
  except:
    handleException()

  canvas.fCairoContext = nil

proc pControlScollXSignal(adjustment: pointer, data: pointer) {.cdecl.} =
  let control = cast[ControlImpl](data)
  control.fXScrollPos = gtk_adjustment_get_value(adjustment).int
  control.forceRedraw()

proc pControlScollYSignal(adjustment: pointer, data: pointer) {.cdecl.} =
  let control = cast[ControlImpl](data)
  control.fYScrollPos = gtk_adjustment_get_value(adjustment).int
  control.forceRedraw()

proc pUpdateFont(control: ControlImpl) =
  var font = pCreateFont(control.fontFamily, control.fontSize, control.fontBold)
  gtk_widget_modify_font(control.fHandle, font)
  var rgba: GdkRGBA
  control.textColor.pColorToGdkRGBA(rgba)

method pAddButtonPressEvent(control: ControlImpl) {.base.} =
  gtk_widget_add_events(control.fHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(control.fHandle, "button-press-event", pCustomControlButtonPressSignal, cast[pointer](control))

method pAddKeyPressEvent(control: ControlImpl) {.base.} =
  discard g_signal_connect_data(control.fHandle, "key-press-event", pControlKeyPressSignal, cast[pointer](control))

proc init(control: ControlImpl) =

  if control.fHandle == nil:
    # Direct instance of ControlImpl:
    control.fHandle = gtk_layout_new(nil, nil)
    discard g_signal_connect_data(control.fHandle, "draw", pControlDrawSignal, cast[pointer](control))
    gtk_widget_add_events(control.fHandle, GDK_KEY_PRESS_MASK)

  control.pAddButtonPressEvent()
  control.pAddKeyPressEvent()

  gtk_widget_add_events(control.fHandle, GDK_BUTTON_RELEASE_MASK)
  discard g_signal_connect_data(control.fHandle, "button-release-event", pControlButtonReleaseSignal, cast[pointer](control))

  control.fIMContext = gtk_im_multicontext_new()
  discard g_signal_connect_data(control.fIMContext, "commit", pControlIMContextCommitSignal, cast[pointer](control))

  procCall control.Control.init()

method destroy(control: ControlImpl) =
  procCall control.Control.destroy()
  gtk_widget_destroy(control.fHandle)
  # this destroys also child widgets

method `visible=`(control: ControlImpl, visible: bool) =
  procCall control.Control.`visible=`(visible)
  if visible:
    gtk_widget_show(control.fHandle)
  else:
    gtk_widget_hide(control.fHandle)

# proc dummy(widget: pointer, event: var GdkEventButton, data: pointer): Gboolean {.cdecl.} =
  # echo "dummy"
  # result = true # Stop propagation

method pUpdateScrollBar(control: ControlImpl) =
  if control.fScrollableWidth == -1 and control.fScrollableHeight == -1:
    return
  echo "control.pUpdateScrollBar"
  if control.fHScrollbar == nil:
    if fScrollbarSize == -1:
      return
    # Init scrolling:
    # echo "fScrollbarSize ", fScrollbarSize
    control.fHAdjust = gtk_adjustment_new(0, 0, 0, 10, 10, 0)
    control.fVAdjust = gtk_adjustment_new(0, 0, 0, 10, 10, 0)
    control.fHScrollbar = gtk_scrollbar_new(GTK_ORIENTATION_HORIZONTAL, control.fHAdjust)
    control.fVScrollbar = gtk_scrollbar_new(GTK_ORIENTATION_VERTICAL, control.fVAdjust)
    gtk_container_add(control.fHandle, control.fHScrollbar)
    gtk_container_add(control.fHandle, control.fVScrollbar)
    discard g_signal_connect_data(control.fHAdjust, "value-changed", pControlScollXSignal, cast[pointer](control))
    discard g_signal_connect_data(control.fVAdjust, "value-changed", pControlScollYSignal, cast[pointer](control))

    # The dead corner is an area which just needs to be covered with a control without function and the default background color
    control.fDeadCornerHandle = gtk_label_new("")
    # control.fDeadCornerHandle = gtk_fixed_new()
    gtk_container_add(control.fHandle, control.fDeadCornerHandle)
    var rgba: GdkRGBA
    pColorToGdkRGBA(app.defaultBackgroundColor, rgba)
    gtk_widget_override_background_color(control.fDeadCornerHandle, GTK_STATE_FLAG_NORMAL, rgba)
    gtk_widget_set_size_request(control.fDeadCornerHandle, fScrollbarSize.cint, fScrollbarSize.cint)

    # Prevent that a click on the dead corner triggers the onClick event of the Control:
    # gtk_widget_add_events(control.fDeadCornerHandle, GDK_BUTTON_PRESS_MASK)
    # discard g_signal_connect_data(control.fDeadCornerHandle, "button-press-event", dummy, nil)
    # gtk_widget_add_events(control.fDeadCornerHandle, GDK_BUTTON_RELEASE_MASK)
    # discard g_signal_connect_data(control.fDeadCornerHandle, "button-release-event", dummy, nil)
    # TODO: does not work. try EventBox

  # Calculation of scrollbar settings:

  control.fXScrollEnabled = false
  control.fYScrollEnabled = false

  if control.scrollableWidth > control.width:
    control.fXScrollEnabled = true
  if control.scrollableHeight > control.height:
    control.fYScrollEnabled = true

  if control.fXScrollEnabled and not control.fYScrollEnabled and control.scrollableHeight > control.height - fScrollbarSize:
    control.fYScrollEnabled = true
  if control.fYScrollEnabled and not control.fXScrollEnabled and control.scrollableWidth > control.width - fScrollbarSize:
    control.fXScrollEnabled = true

  # Update horizontal scrollbar:
  if control.fXScrollEnabled:
    var upper = control.scrollableWidth
    var size = control.width
    if control.fYScrollEnabled:
      upper.inc(fScrollbarSize)
      size.dec(fScrollbarSize)
    gtk_adjustment_set_upper(control.fHAdjust, upper.cdouble)
    let value = gtk_adjustment_get_value(control.fHAdjust).int
    let maxValue = upper - control.width
    if value > maxValue:
      gtk_adjustment_set_value(control.fHAdjust, maxValue.float)
    gtk_adjustment_set_page_size(control.fHAdjust, control.width.float)
    gtk_widget_set_size_request(control.fHScrollbar, size.cint, 0)
    gtk_layout_move(control.fHandle, control.fHScrollbar, 0, (control.height - fScrollbarSize).cint)
    gtk_widget_show(control.fHScrollbar)
    # Ensure that scroll pos is within range:
    control.fXScrollPos = max(min(control.fXScrollPos, maxValue), 0)
  else:
    gtk_widget_hide(control.fHScrollbar)
    control.fXScrollPos = 0

  # Update vertical scrollbar:
  if control.fYScrollEnabled:
    var upper = control.scrollableHeight
    var size = control.height
    if control.fXScrollEnabled:
      upper.inc(fScrollbarSize)
      size.dec(fScrollbarSize)
    gtk_adjustment_set_upper(control.fVAdjust, upper.cdouble)
    let value = gtk_adjustment_get_value(control.fVAdjust).int
    let maxValue = upper - control.height
    if value > maxValue:
      gtk_adjustment_set_value(control.fVAdjust, maxValue.float)
    gtk_adjustment_set_page_size(control.fVAdjust, control.height.float)
    gtk_widget_set_size_request(control.fVScrollbar, 0, size.cint)
    gtk_layout_move(control.fHandle, control.fVScrollbar, (control.width - fScrollbarSize).cint, 0)
    gtk_widget_show(control.fVScrollbar)
    # Ensure that scroll pos is within range:
    control.fYScrollPos = max(min(control.fYScrollPos, maxValue), 0)
  else:
    gtk_widget_hide(control.fVScrollbar)
    control.fYScrollPos = 0

  # Update dead corner:
  if control.fXScrollEnabled and control.fYScrollEnabled:
    gtk_layout_move(control.fHandle, control.fDeadCornerHandle, (control.width - fScrollbarSize).cint, (control.height - fScrollbarSize).cint)
    gtk_widget_show(control.fDeadCornerHandle)
  else:
    gtk_widget_hide(control.fDeadCornerHandle)


method setSize(control: ControlImpl, width, height: int) =
  if width == control.fWidth and height == control.fHeight:
    return
  procCall control.Control.setSize(width, height)
  gtk_widget_set_size_request(control.fHandle, width.cint, height.cint)
  pUpdateScrollBar(control)

method setPosition(control: ControlImpl, x, y: int) =
  procCall control.Control.setPosition(x, y)
  if control.fParentControl != nil:
    gtk_layout_move(cast[ContainerImpl](control.fParentControl).fInnerHandle, control.fHandle, x.cint, y.cint)

method forceRedraw(control: ControlImpl) = gtk_widget_queue_draw(control.fHandle)

# proc removeWidgetInternal(container: WidgetContainer, widget: Widget) = gtk_container_remove(container.innerHandle, widget.handle)

method setFontFamily(control: ControlImpl, fontFamily: string) =
  procCall control.Control.setFontFamily(fontFamily)
  control.pUpdateFont()

method setFontSize(control: ControlImpl, fontSize: float) =
  procCall control.Control.setFontSize(fontSize)
  control.pUpdateFont()

method setFontBold(control: ControlImpl, fontBold: bool) =
  procCall control.Control.setFontBold(fontBold)
  control.pUpdateFont()

method setTextColor(control: ControlImpl, color: Color) =
  procCall control.Control.setTextColor(color)
  var rgba: GdkRGBA
  color.pColorToGdkRGBA(rgba)
  gtk_widget_override_color(control.fHandle, GTK_STATE_FLAG_NORMAL, rgba)

method setBackgroundColor(control: ControlImpl, color: Color) =
  procCall control.Control.setBackgroundColor(color)
  var rgba: GdkRGBA
  color.pColorToGdkRGBA(rgba)
  gtk_widget_override_background_color(control.fHandle, GTK_STATE_FLAG_NORMAL, rgba)

method getTextLineWidth(control: ControlImpl, text: string): int {.locks: "unknown".} =
  var layout = gtk_widget_create_pango_layout(control.fHandle, text)
  var width: cint
  var height: cint
  pango_layout_get_pixel_size(layout, width, height)
  result = width + 2

method getTextLineHeight(control: ControlImpl): int {.locks: "unknown".} =
  var layout = gtk_widget_create_pango_layout(control.fHandle, "a")

  # Because the widget's font size is not always regarded, we have to set the font here again:
  var font = pCreateFont(control.fontFamily, control.fontSize, control.fontBold)
  pango_layout_set_font_description(layout, font)

  var width: cint
  var height: cint
  pango_layout_get_pixel_size(layout, width, height)
  result = height

discard """ method `xScrollPos=`(control: ControlImpl, xScrollPos: int) =
  procCall control.Control.`xScrollPos=`(xScrollPos)
  control.pUpdateScrollBar()

method `yScrollPos=`(control: ControlImpl, yScrollPos: int) =
  procCall control.Control.`yScrollPos=`(yScrollPos)
  control.pUpdateScrollBar() """

method `scrollableWidth=`(control: ControlImpl, scrollableWidth: int) =
  if scrollableWidth == control.fScrollableWidth:
    return
  procCall control.Control.`scrollableWidth=`(scrollableWidth)
  control.pUpdateScrollBar()

method `scrollableHeight=`(control: ControlImpl, scrollableHeight: int) =
  if scrollableHeight == control.fScrollableHeight:
    return
  procCall control.Control.`scrollableHeight=`(scrollableHeight)
  control.pUpdateScrollBar()

method mousePosition(control: Control): tuple[x, y: int] =
  var x, y: cint
  gtk_widget_get_pointer(cast[ControlImpl](control).fHandle, x, y)
  result.x = x
  result.y = y


# ----------------------------------------------------------------------------------------
#                                      Container
# ----------------------------------------------------------------------------------------

proc init(container: ContainerImpl) =
  container.fHandle = gtk_fixed_new()
  # ScrollWnd:
  container.fScrollWndHandle = gtk_scrolled_window_new(nil, nil)
  gtk_widget_show(container.fScrollWndHandle)
  gtk_container_add(container.fHandle, container.fScrollWndHandle)
  # Inner:
  container.fInnerHandle = gtk_layout_new(nil, nil)
  gtk_widget_show(container.fInnerHandle)
  gtk_container_add(container.fScrollWndHandle, container.fInnerHandle)
  container.Container.init()

  discard g_signal_connect_data(container.fInnerHandle, "draw", pControlDrawSignal, cast[pointer](container))

method pAddButtonPressEvent(container: ContainerImpl) =
  # Overwrite base method
  gtk_widget_add_events(container.fInnerHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(container.fInnerHandle, "button-press-event", pCustomControlButtonPressSignal, cast[pointer](container))

method pUpdateScrollWnd(container: ContainerImpl) {.base.} =
  let padding = container.getPadding()
  let width = container.width - padding.left - padding.right
  let height = container.height - padding.top - padding.bottom
  gtk_widget_set_size_request(container.fScrollWndHandle, width.cint, height.cint)
  gtk_fixed_move(container.fHandle, container.fScrollWndHandle, padding.left.cint, padding.top.cint)

method `frame=`(container: ContainerImpl, frame: Frame) =
  procCall container.Container.`frame=`(frame)
  if frame != nil:
    gtk_container_add(container.fHandle, frame.fHandle)
  container.pUpdateScrollWnd()

method add(container: ContainerImpl, control: Control) =
  # Overwrite base method
  gtk_container_add(container.fInnerHandle, cast[ControlImpl](control).fHandle)
  procCall container.Container.add(control)

method remove(container: ContainerImpl, control: Control) =
  gtk_container_remove(container.fInnerHandle, cast[ControlImpl](control).fHandle)
  procCall container.Container.remove(control)

method paddingLeft(container: ContainerImpl): int {.base.} = 5 # TODO
method paddingRight(container: ContainerImpl): int {.base.} = 5 # TODO
method paddingTop(container: ContainerImpl): int {.base.} = 15 # TODO
method paddingBottom(container: ContainerImpl): int {.base.} = 5 # TODO

method setInnerSize(container: ContainerImpl, width, height: int) =
  procCall container.Container.setInnerSize(width, height)
  gtk_widget_set_size_request(container.fInnerHandle, width.cint, height.cint)

method setSize(container: ContainerImpl, width, height: int) =
  procCall container.Container.setSize(width, height)
  container.pUpdateScrollWnd()

method pUpdateScrollBar(container: ContainerImpl) =
  # Overwrite base method
  if container.fScrollableWidth == -1 and container.fScrollableHeight == -1:
    return

  if fScrollbarSize == -1:
    return

  gtk_layout_set_size(container.fInnerHandle, container.scrollableWidth.cint, container.scrollableHeight.cint)

  container.fXScrollEnabled = false
  container.fYScrollEnabled = false

  if container.scrollableWidth > container.width:
    container.fXScrollEnabled = true
  if container.scrollableHeight > container.height:
    container.fYScrollEnabled = true

  if container.fXScrollEnabled and not container.fYScrollEnabled and container.scrollableHeight > container.height - fScrollbarSize:
    container.fYScrollEnabled = true
  if container.fYScrollEnabled and not container.fXScrollEnabled and container.scrollableWidth > container.width - fScrollbarSize:
    container.fXScrollEnabled = true

method handleDrawEvent(container: ContainerImpl, event: DrawEvent) =
  # Overwrites base method
  let callback = container.onDraw
  if callback != nil:
    callback(event)
  else:
    # Draw regular window background
    container.canvas.areaColor = app.defaultBackgroundColor
    container.canvas.fill()


# ----------------------------------------------------------------------------------------
#                                        Frame
# ----------------------------------------------------------------------------------------

proc init(frame: NativeFrame) =
  frame.fHandle = gtk_frame_new("")
  frame.Frame.init()

method `text=`(frame: NativeFrame, text: string) =
  procCall frame.Frame.`text=`(text)
  gtk_frame_set_label(frame.fHandle, text)

method getPadding(frame: NativeFrame): Spacing =
  result = procCall frame.Frame.getPadding()
  result.top = frame.getTextLineHeight() * frame.text.countLines + 2


# ----------------------------------------------------------------------------------------
#                                        Button
# ----------------------------------------------------------------------------------------

proc init(button: NativeButton) =
  button.fHandle = gtk_button_new()
  button.Button.init()

method `text=`(button: NativeButton, text: string) =
  procCall button.Button.`text=`(text)
  gtk_button_set_label(button.fHandle, text)
  # Don't let the button expand:
  let list = gtk_container_get_children(button.fHandle)
  if list != nil:
    gtk_label_set_ellipsize(list.data, PANGO_ELLIPSIZE_END)
  app.processEvents()

method naturalWidth(button: NativeButton): int {.locks: "unknown".} =
  # Override parent method, to make it big enough for the text to fit in.
  var context = gtk_widget_get_style_context(button.fHandle)
  var padding: GtkBorder
  gtk_style_context_get_padding(context, GTK_STATE_FLAG_NORMAL, padding)
  result = button.getTextLineWidth(button.text) + padding.left + padding.right + 5

method `enabled=`(button: NativeButton, enabled: bool) =
  button.fEnabled = enabled
  gtk_widget_set_sensitive(button.fHandle, enabled)


# ----------------------------------------------------------------------------------------
#                                        Checkbox
# ----------------------------------------------------------------------------------------

proc pControlToggledSignal(widget: pointer, data: pointer): Gboolean {.cdecl.} =
  let control = cast[Checkbox](data)
  var evt = new ToggleEvent
  evt.control = control
  try:
    control.handleToggleEvent(evt)
  except:
    handleException()

proc init(checkbox: NativeCheckbox) =
  checkbox.fHandle = gtk_check_button_new()
  discard g_signal_connect_data(checkbox.fHandle, "toggled", pControlToggledSignal, cast[pointer](checkbox))
  checkbox.Checkbox.init()
  gtk_widget_show(checkbox.fHandle)

method `text=`(checkbox: NativeCheckbox, text: string) =
  procCall checkbox.Checkbox.`text=`(text)
  gtk_button_set_label(checkbox.fHandle, text)
  app.processEvents()

method naturalWidth(checkbox: NativeCheckbox): int {.locks: "unknown".} =
  # Override parent method, to make it big enough for the text to fit in.
  var context = gtk_widget_get_style_context(checkbox.fHandle)
  var padding: GtkBorder
  gtk_style_context_get_padding(context, GTK_STATE_FLAG_NORMAL, padding)
  result = checkbox.getTextLineWidth(checkbox.text) + padding.left + padding.right + 25.scaleToDpi

method `enabled=`(checkbox: NativeCheckbox, enabled: bool) =
  checkbox.fEnabled = enabled
  gtk_widget_set_sensitive(checkbox.fHandle, enabled)

method checked(checkbox: NativeCheckbox): bool =
  result = gtk_toggle_button_get_active(checkbox.fHandle)

method `checked=`(checkbox: NativeCheckbox, checked: bool) =
  g_signal_handlers_block_matched(checkbox.fHandle, G_SIGNAL_MATCH_FUNC, 0, nil, nil, pControlToggledSignal)
  gtk_toggle_button_set_active(checkbox.fHandle, checked)
  g_signal_handlers_unblock_matched(checkbox.fHandle, G_SIGNAL_MATCH_FUNC, 0, nil, nil, pControlToggledSignal)

method pAddButtonPressEvent(checkbox: NativeCheckbox) = discard # don't override default handler


# ----------------------------------------------------------------------------------------
#                                        ComboBox
# ----------------------------------------------------------------------------------------

proc init(comboBox: NativeComboBox) =
  comboBox.fHandle = gtk_combo_box_text_new()
  comboBox.ComboBox.init()
  gtk_widget_show(comboBox.fHandle)

method naturalWidth(comboBox: NativeComboBox): int =
  result = comboBox.fMaxTextWidth.scaleToDpi

method naturalHeight(comboBox: NativeComboBox): int =
  result = scaleToDpi(comboBox.getTextLineHeight() + 12)

method `options=`(comboBox: NativeComboBox, options: seq[string]) =
  let oldIndex = comboBox.index
  comboBox.fOptions = options

  gtk_combo_box_text_remove_all(comboBox.fHandle)

  var maxWidth = 0
  for option in options:
    gtk_combo_box_text_append_text(comboBox.fHandle, option)
    maxWidth = max(maxWidth, comboBox.getTextWidth(option))

  comboBox.fMaxTextWidth = maxWidth
  comboBox.triggerRelayout()

  if oldIndex < len(options):
    comboBox.index = oldIndex
  else:
    comboBox.index = len(options) - 1

method `enabled=`(comboBox: NativeComboBox, enabled: bool) =
  comboBox.fEnabled = enabled
  gtk_widget_set_sensitive(comboBox.fHandle, enabled)

method value(comboBox: NativeComboBox): string =
  result = $gtk_combo_box_text_get_active_text(comboBox.fHandle)

method `value=`(comboBox: NativeComboBox, value: string) =
  let idx = comboBox.fOptions.find(value)
  if idx != -1:
    comboBox.index = idx

method index(comboBox: NativeComboBox): int =
  result = gtk_combo_box_get_active(comboBox.fHandle)

method `index=`(comboBox: NativeComboBox, index: int) =
  gtk_combo_box_set_active(comboBox.fHandle, index.cint)


# ----------------------------------------------------------------------------------------
#                                        Label
# ----------------------------------------------------------------------------------------

proc init(label: NativeLabel) =
  label.Label.init()
  label.fFontSize = app.defaultFontSize * 0.95


# ----------------------------------------------------------------------------------------
#                                      ProgressBar
# ----------------------------------------------------------------------------------------

proc init(progressBar: NativeProgressBar) =
  progressBar.fHandle = gtk_progress_bar_new()
  progressBar.ProgressBar.init()
  progressBar.height = 8.scaleToDpi # adjust control height to bar height

method `value=`(progressBar: NativeProgressBar, value: float) =
  procCall progressBar.ProgressBar.`value=`(value)
  gtk_progress_bar_set_fraction(progressBar.fHandle, value)
  app.processEvents()


# ----------------------------------------------------------------------------------------
#                                       TextBox
# ----------------------------------------------------------------------------------------

proc pTextBoxKeyPressSignal(widget: pointer, event: var GdkEventKey, data: pointer): Gboolean {.cdecl.} =
  result = pControlKeyPressSignal(widget, event, data)

  # Implement own "copy to clipboard", because by default the clipboard is non-persistent
  if not result:
    let modifiers = gtk_accelerator_get_default_mod_mask()
    if event.keyval == 'c'.ord and (event.state and modifiers) == GDK_CONTROL_MASK:
      let textBox = cast[NativeTextBox](data)
      app.clipboardText = textBox.selectedText
      return true # prevent default "copy to clipboard"

proc init(textBox: NativeTextBox) =
  textBox.fHandle = gtk_entry_new()
  discard g_signal_connect_data(textBox.fHandle, "changed", pControlChangedSignal, cast[pointer](textBox))
  textBox.TextBox.init()

method initStyle(textBox: NativeTextBox) =
  procCall textBox.TextBox.initStyle()
  var context = gtk_widget_get_style_context(textBox.fHandle)
  var rgba: GdkRGBA
  gtk_style_context_get_background_color(context, GTK_STATE_FLAG_NORMAL, rgba)
  textBox.fBackgroundColor = rgba.pGdkRGBAToColor()
  gtk_style_context_get_color(context, GTK_STATE_FLAG_NORMAL, rgba)
  textBox.fTextColor = rgba.pGdkRGBAToColor()
  textBox.fUseDefaultBackgroundColor = false
  textBox.fUseDefaultTextColor = false

method text(textBox: NativeTextBox): string {.locks: "unknown".} = $gtk_entry_get_text(textBox.fHandle)

method `text=`(textBox: NativeTextBox, text: string) {.locks: "unknown".} =
  gtk_entry_set_text(textBox.fHandle, text)
  app.processEvents()

method naturalHeight(textBox: NativeTextBox): int {.locks: "unknown".} = textBox.getTextLineHeight() + 12 # add padding

method setSize(textBox: NativeTextBox, width, height: int) =
  gtk_entry_set_width_chars(textBox.fHandle, 1)
  procCall textBox.ControlImpl.setSize(width, height)

method pAddButtonPressEvent(textBox: NativeTextBox) =
  gtk_widget_add_events(textBox.fHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(textBox.fHandle, "button-press-event", pDefaultControlButtonPressSignal, cast[pointer](textBox))

method pAddKeyPressEvent(textBox: NativeTextBox) =
  discard g_signal_connect_data(textBox.fHandle, "key-press-event", pTextBoxKeyPressSignal, cast[pointer](textBox))

method `editable=`(textBox: NativeTextBox, editable: bool) =
  textBox.fEditable = editable
  gtk_editable_set_editable(textBox.fHandle, editable)

method cursorPos(textBox: NativeTextBox): int =
  result = gtk_editable_get_position(textBox.fHandle)

method `cursorPos=`(textBox: NativeTextBox, cursorPos: int) =
  # side effect: clears selection
  gtk_editable_set_position(textBox.fHandle, cursorPos.cint)

method selectionStart(textBox: NativeTextBox): int =
  var startPos: cint
  var endPos: cint
  discard gtk_editable_get_selection_bounds(textBox.fHandle, startPos, endPos)
  result = startPos

method selectionEnd(textBox: NativeTextBox): int =
  var startPos: cint
  var endPos: cint
  discard gtk_editable_get_selection_bounds(textBox.fHandle, startPos, endPos)
  result = endPos

method `selectionStart=`(textBox: NativeTextBox, selectionStart: int) =
  gtk_editable_select_region(textBox.fHandle, selectionStart.cint, textBox.selectionEnd.cint)
  # side effect: sets cursor to end of selection

method `selectionEnd=`(textBox: NativeTextBox, selectionEnd: int) =
  gtk_editable_select_region(textBox.fHandle, textBox.selectionStart.cint, selectionEnd.cint)
  # side effect: sets cursor to end of selection


# ----------------------------------------------------------------------------------------
#                                      TextArea
# ----------------------------------------------------------------------------------------

proc pTextAreaKeyPressSignal(widget: pointer, event: var GdkEventKey, data: pointer): Gboolean {.cdecl.} =
  result = pControlKeyPressSignal(widget, event, data)

  # Implement own "copy to clipboard", because by default the clipboard is non-persistent
  if not result:
    let modifiers = gtk_accelerator_get_default_mod_mask()
    if event.keyval == 'c'.ord and (event.state and modifiers) == GDK_CONTROL_MASK:
      let textArea = cast[NativeTextBox](data)
      app.clipboardText = textArea.selectedText
      return true # prevent default "copy to clipboard"

proc init(textArea: NativeTextArea) =
  textArea.fHandle = gtk_scrolled_window_new(nil, nil)
  # gtk_scrolled_window_set_policy(textArea.fHandle, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC)
  gtk_scrolled_window_set_policy(textArea.fHandle, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
  textArea.fTextViewHandle = gtk_text_view_new()
  gtk_text_view_set_left_margin(textArea.fTextViewHandle, 5)
  gtk_text_view_set_right_margin(textArea.fTextViewHandle, 5)
  gtk_text_view_set_top_margin(textArea.fTextViewHandle, 5)
  gtk_text_view_set_bottom_margin(textArea.fTextViewHandle, 5)
  gtk_container_add(textArea.fHandle, textArea.fTextViewHandle)
  gtk_widget_show(textArea.fTextViewHandle)
  textArea.fBufferHandle = gtk_text_view_get_buffer(textArea.fTextViewHandle)
  discard g_signal_connect_data(textArea.fBufferHandle, "changed", pControlChangedSignal, cast[pointer](textArea))
  textArea.TextArea.init()

method setSize(textBox: NativeTextArea, width, height: int) =
  # Need to override method of NativeTextBox
  procCall textBox.ControlImpl.setSize(width, height)

method text(textArea: NativeTextArea): string {.locks: "unknown".} =
  var startIter, endIter: GtkTextIter
  gtk_text_buffer_get_start_iter(textArea.fBufferHandle, startIter)
  gtk_text_buffer_get_end_iter(textArea.fBufferHandle, endIter)
  result = $gtk_text_buffer_get_text(textArea.fBufferHandle, startIter, endIter, true)

method `text=`(textArea: NativeTextArea, text: string) {.locks: "unknown".} =
  gtk_text_buffer_set_text(textArea.fBufferHandle, text, text.len.cint)
  app.processEvents()

method addText(textArea: NativeTextArea, text: string) {.locks: "unknown".} =
  # overide base method for better performance and to prevent automatic scrolling to top
  var iter: GtkTextIter
  gtk_text_buffer_get_end_iter(textArea.fBufferHandle, iter)
  gtk_text_buffer_insert(textArea.fBufferHandle, iter, text, text.len.cint)
  app.processEvents()

method scrollToBottom(textArea: NativeTextArea) =
  var iter: GtkTextIter
  gtk_text_buffer_get_end_iter(textArea.fBufferHandle, iter)
  gtk_text_view_scroll_to_iter(textArea.fTextViewHandle, iter, 0, false, 0, 0)
  app.processEvents()

method `wrap=`(textArea: NativeTextArea, wrap: bool) =
  procCall textArea.TextArea.`wrap=`(wrap)
  if wrap:
    gtk_text_view_set_wrap_mode(textArea.fTextViewHandle, GTK_WRAP_WORD_CHAR)
  else:
    gtk_text_view_set_wrap_mode(textArea.fTextViewHandle, GTK_WRAP_NONE)

method pAddKeyPressEvent(textArea: NativeTextArea) =
  discard g_signal_connect_data(textArea.fTextViewHandle, "key-press-event", pTextAreaKeyPressSignal, cast[pointer](textArea))

method `editable=`(textArea: NativeTextArea, editable: bool) =
  textArea.fEditable = editable
  gtk_text_view_set_editable(textArea.fTextViewHandle, editable)

method cursorPos(textArea: NativeTextArea): int =
  let mark = gtk_text_buffer_get_insert(textArea.fBufferHandle)
  var iter: GtkTextIter
  gtk_text_buffer_get_iter_at_mark(textArea.fBufferHandle, iter, mark)
  result = gtk_text_iter_get_offset(iter)

method `cursorPos=`(textArea: NativeTextArea, cursorPos: int) =
  # side effect: clears selection
  var iter: GtkTextIter
  gtk_text_buffer_get_iter_at_offset(textArea.fBufferHandle, iter, cursorPos.cint)
  gtk_text_buffer_select_range(textArea.fBufferHandle, iter, iter)

method selectionStart(textArea: NativeTextArea): int =
  var startIter: GtkTextIter
  var endIter: GtkTextIter
  discard gtk_text_buffer_get_selection_bounds(textArea.fBufferHandle, startIter, endIter)
  result = gtk_text_iter_get_offset(startIter)

method selectionEnd(textArea: NativeTextArea): int =
  var startIter: GtkTextIter
  var endIter: GtkTextIter
  discard gtk_text_buffer_get_selection_bounds(textArea.fBufferHandle, startIter, endIter)
  result = gtk_text_iter_get_offset(endIter)

method `selectionStart=`(textArea: NativeTextArea, selectionStart: int) =
  var startIter: GtkTextIter
  var endIter: GtkTextIter
  gtk_text_buffer_get_iter_at_offset(textArea.fBufferHandle, startIter, selectionStart.cint)
  gtk_text_buffer_get_iter_at_offset(textArea.fBufferHandle, endIter, textArea.selectionEnd.cint)
  gtk_text_buffer_select_range(textArea.fBufferHandle, startIter, endIter)
  # side effect: sets cursor to start of selection

method `selectionEnd=`(textArea: NativeTextArea, selectionEnd: int) =
  var startIter: GtkTextIter
  var endIter: GtkTextIter
  gtk_text_buffer_get_iter_at_offset(textArea.fBufferHandle, startIter, textArea.selectionStart.cint)
  gtk_text_buffer_get_iter_at_offset(textArea.fBufferHandle, endIter, selectionEnd.cint)
  gtk_text_buffer_select_range(textArea.fBufferHandle, startIter, endIter)
  # side effect: sets cursor to start of selection
