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

proc pRaiseGError(error: ptr GError) =
  if error == nil:
    raiseError("Unkown error")
  raiseError($error.message, false)

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

proc pWindowDeleteSignal(widgetHandle, event, data: pointer): bool {.cdecl.} =
  let window = cast[WindowImpl](data)
  window.dispose()
  return true

proc pWindowConfigureSignal(windowHandle, event, data: pointer): bool {.cdecl.} =
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
  window.triggerRelayout()

proc pKeyvalToKey(keyval: cint): Key =
  result = case keyval
  of 65289: Key_Tab
  of 65293: Key_Return
  of 65307: Key_Escape
  of 65379: Key_Insert
  of 65535: Key_Delete
  of 65288: Key_Backspace
  of 65361: Key_Left
  of 65362: Key_Up
  of 65363: Key_Right
  of 65364: Key_Down
  of 65360: Key_Home
  of 65367: Key_End
  of 65365: Key_PageUp
  of 65366: Key_PageDown
  else: cast[Key](keyval.unicodeToUpper)

proc pWindowKeyPressSignal(widget: pointer, event: var GdkEventKey, data: pointer): bool {.cdecl.} =
  # echo "window keyPressCallback"

  # echo event.keyval
  # echo event.hardware_keycode

  # echo $gdk_keyval_to_unicode(event.keyval)
  var unicode = gdk_keyval_to_unicode(event.keyval)
  # if unicode == 0:
    # unicode = event.keyval

  let window = cast[WindowImpl](data)
  var evt = new WindowKeyEvent
  evt.window = window
  evt.key = pKeyvalToKey(event.keyval)
  if evt.key == Key_None:
    echo "Unkown key value: ", event.keyval
    return

  evt.character = $event.`string`
  evt.unicode = unicode

  try:
    window.handleKeyDownEvent(evt)
  except:
    handleException()

proc pControlKeyPressSignal(widget: pointer, event: var GdkEventKey, data: pointer): bool {.cdecl.} =

  # echo "control keyPressCallback"

  # echo $gdk_keyval_to_unicode(event.keyval)
  var unicode = gdk_keyval_to_unicode(event.keyval)

  # if unicode == 0:
    # unicode = event.keyval

  let control = cast[ControlImpl](data)
  var evt = new ControlKeyEvent
  evt.control = control
  evt.key = pKeyvalToKey(event.keyval)
  if evt.key == Key_None:
    echo "Unkown key value: ", event.keyval
    return
  evt.character = $event.`string`
  evt.unicode = unicode

  try:
    control.handleKeyDownEvent(evt)
  except:
    handleException()

  return evt.cancel

method focus(control: ControlImpl) =
  gtk_widget_grab_focus(control.fHandle)

method focus(control: NativeTextArea) =
  gtk_widget_grab_focus(control.fTextViewHandle)

proc pDefaultControlButtonPressSignal(widget: pointer, event: var GdkEventButton, data: pointer): bool {.cdecl.} =
  let control = cast[ControlImpl](data)
  let x = event.x.int
  let y = event.y.int
  var evt = new MouseButtonEvent
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

proc pCustomControlButtonPressSignal(widget: pointer, event: var GdkEventButton, data: pointer): bool {.cdecl.} =
  discard pDefaultControlButtonPressSignal(widget, event, data)
  let control = cast[ControlImpl](data)
  control.focus()
  result = true # Stop propagation, required to detect clicks

proc pControlButtonReleaseSignal(widget: pointer, event: var GdkEventButton, data: pointer): bool {.cdecl.} =
  let control = cast[ControlImpl](data)
  let x = event.x.int
  let y = event.y.int
  if not (x >= 0 and x < control.width and y >= 0 and y < control.height):
    return
  var evt = new MouseButtonEvent
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

proc pControlChangedSignal(widget: pointer, data: pointer): bool {.cdecl.} =
  let control = cast[ControlImpl](data)
  var evt = new TextChangeEvent
  try:
    control.handleTextChangeEvent(evt)
  except:
    handleException()

# proc pTextAreaEndUserActionSignal(widget: pointer, data: pointer): bool {.cdecl.} =
  # let control = cast[ControlImpl](data)
  # discard

proc pSetDragDest(widget: pointer) =
  var target: GtkTargetEntry
  target.target = "text/uri-list"
  target.flags = 0
  target.info = 0
  gtk_drag_dest_set(widget, GTK_DEST_DEFAULT_ALL, target.addr, 1, GDK_ACTION_COPY)


# ----------------------------------------------------------------------------------------
#                                    App Procedures
# ----------------------------------------------------------------------------------------

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

proc processEvents(app: App) =
  while gtk_events_pending() == 1:
    discard gtk_main_iteration()

proc pClipboardTextReceivedFunc(clipboard: pointer, text: cstring, data: pointer): bool {.cdecl.} =
  pClipboardText = $text
  if pClipboardText == nil:
    pClipboardText = ""

proc clipboardText(app: App): string =
  pClipboardText = nil
  gtk_clipboard_request_text(pClipboardPtr, pClipboardTextReceivedFunc, nil)
  while pClipboardText == nil:
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
  var chooser = gtk_file_chooser_dialog_new(nil, nil, GTK_FILE_CHOOSER_ACTION_OPEN, "Cancel", GTK_RESPONSE_CANCEL, "Open", GTK_RESPONSE_ACCEPT, nil)
  # Issue: When a title is passed, the dialog is shown without a title
  discard gtk_file_chooser_set_current_folder(chooser, dialog.directory)
  gtk_file_chooser_set_select_multiple(chooser, dialog.multiple)
  let res = gtk_dialog_run(chooser)
  if res == GTK_RESPONSE_ACCEPT:
    let list = gtk_file_chooser_get_filenames(chooser)
    let count = g_slist_length(list)
    for i in 0..count - 1:
      dialog.files.add($g_slist_nth_data_string(list, i))
  gtk_widget_destroy(chooser)

method run(dialog: SaveFileDialog) =
  var chooser = gtk_file_chooser_dialog_new(nil, nil, GTK_FILE_CHOOSER_ACTION_SAVE, "Cancel", GTK_RESPONSE_CANCEL, "Save", GTK_RESPONSE_ACCEPT, nil)
  # Issue: When a title is passed, the dialog is shown without a title
  let res = gtk_dialog_run(chooser)
  discard gtk_file_chooser_set_current_folder(chooser, dialog.directory)
  if dialog.defaultName.len > 0:
    discard gtk_file_chooser_set_current_name(chooser, dialog.defaultName) # Issue: does not work
  if res == GTK_RESPONSE_ACCEPT:
    dialog.file = $gtk_file_chooser_get_filename(chooser)
  else:
    dialog.file = ""
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

proc pTimerFunction(timer: Timer): bool {.cdecl.} =
  let timerEntry = pTimers.getOrDefault(cast[int](timer))
  var event = new TimerEvent
  event.timer = timer
  event.data = timerEntry.data
  timerEntry.timerProc(event)
  pTimers.del(cast[int](timer))
  # result is false to stop timer

proc pRepeatingTimerFunction(timer: Timer): bool {.cdecl.} =
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
  canvasImpl.fFont = pango_font_description_new()
  pango_font_description_set_family(canvasImpl.fFont, canvas.fontFamily)
  pango_font_description_set_size(canvasImpl.fFont, cint(canvas.fontSize * pFontSizeFactor))

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

  cairo_move_to(cr, x.float, y.float)
  pango_cairo_show_layout(cr, layout)

method drawLine(canvas: Canvas, x1, y1, x2, y2: int) =
  let cr = cast[CanvasImpl](canvas).fCairoContext
  if cr == nil:
    raiseError("Canvas is not in drawing state.")
  var rgba: GdkRGBA
  canvas.lineColor.pColorToGdkRGBA(rgba)
  gdk_cairo_set_source_rgba(cr, rgba)
  cairo_move_to(cr, x1.float, y1.float)
  cairo_line_to(cr, x2.float, y2.float)
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
  cairo_set_line_width(cr, 1)
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
    canvasImpl.fData[i + 0] = color.blue.chr
    canvasImpl.fData[i + 1] = color.green.chr
    canvasImpl.fData[i + 2] = color.red.chr
    canvasImpl.fData[i + 3] = 255.chr
    cairo_surface_mark_dirty(canvasImpl.fSurface)

method `fontFamily=`(canvas: CanvasImpl, fontFamily: string) =
  procCall canvas.Canvas.`fontFamily=`(fontFamily)
  canvas.fFont = nil

method `fontSize=`(canvas: CanvasImpl, fontSize: int) =
  procCall canvas.Canvas.`fontSize=`(fontSize)
  canvas.fFont = nil

method getTextLineWidth(canvas: CanvasImpl, text: string): int =
  if canvas.fCairoContext == nil:
    raiseError("Canvas is not in drawing state.")
  var layout = pango_cairo_create_layout(canvas.fCairoContext)
  pango_layout_set_text(layout, text, text.len.cint)
  if canvas.fFont == nil:
    canvas.pUpdateFont()
  pango_layout_set_font_description(layout, canvas.fFont)
  var width: cint = 0
  var height: cint = 0
  pango_layout_get_pixel_size(layout, width, height)
  result = width

method getTextLineHeight(canvas: CanvasImpl): int =
  if canvas.fCairoContext == nil:
    raiseError("Canvas is not in drawing state.")
  var layout = pango_cairo_create_layout(canvas.fCairoContext)
  pango_layout_set_text(layout, "a", 1)
  if canvas.fFont == nil:
    canvas.pUpdateFont()
  pango_layout_set_font_description(layout, canvas.fFont)
  var width: cint = 0
  var height: cint = 0
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
  canvas.fSurface = gdk_cairo_surface_create_from_pixbuf(pixbuf, 1, nil)
  canvas.fCairoContext = cairo_create(canvas.fSurface)
  canvas.fData = cairo_image_surface_get_data(canvas.fSurface)
  canvas.fStride = cairo_image_surface_get_stride(canvas.fSurface)
  image.canvas.fWidth = cairo_image_surface_get_width(canvas.fSurface)
  image.canvas.fHeight = cairo_image_surface_get_height(canvas.fSurface)

method saveToPngFile(image: Image, filePath: string) =
  let canvas = cast[CanvasImpl](image.fCanvas)
  var pixbuf = gdk_pixbuf_get_from_surface(canvas.fSurface, 0, 0, image.width.cint, image.height.cint)
  var error: ptr GError
  if not gdk_pixbuf_save(pixbuf, filePath, "png", error.addr, nil, nil, nil):
    pRaiseGError(error)

method saveToJpegFile(image: Image, filePath: string, quality = 80) =
  let canvas = cast[CanvasImpl](image.fCanvas)
  var pixbuf = gdk_pixbuf_get_from_surface(canvas.fSurface, 0, 0, image.width.cint, image.height.cint)
  var error: ptr GError
  if not gdk_pixbuf_save(pixbuf, filePath, "jpeg", error.addr, "quality", $quality, nil):
    pRaiseGError(error)


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

proc pMainScrollbarDraw(widget: pointer, cr: pointer, data: pointer): bool {.cdecl.} =
  # This proc is there to get the scrollbar size
  if fScrollbarSize == -1:
    var scrollbar = gtk_scrolled_window_get_hscrollbar(widget)
    var allocation: GdkRectangle
    gtk_widget_get_allocation(scrollbar, allocation)
    gtk_scrolled_window_set_policy(widget, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
    fScrollbarSize = allocation.height

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

  # Enable drag and drop of files:
  pSetDragDest(window.fHandle)
  discard g_signal_connect_data(window.fHandle, "drag-data-received", pWindowDragDataReceivedSignal, cast[pointer](window))

  if fScrollbarSize == -1:
    gtk_scrolled_window_set_policy(window.fInnerHandle, GTK_POLICY_ALWAYS, GTK_POLICY_ALWAYS)
    discard g_signal_connect_data(window.fInnerHandle, "draw", pMainScrollbarDraw, nil)

method destroy(window: WindowImpl) =
  procCall window.Window.destroy()
  gtk_widget_destroy(window.fHandle)
  # this destroys also child widgets
  window.fHandle = nil

method `visible=`(window: WindowImpl, visible: bool) =
  procCall window.Window.`visible=`(visible)
  if visible:
    gtk_widget_show(window.fHandle)
    while fScrollbarSize == -1:
      discard gtk_main_iteration()
  else:
    gtk_widget_hide(window.fHandle)
  app.processEvents()

method showModal(window, parent: WindowImpl) =
  gtk_window_set_modal(window.fHandle, 1)
  gtk_window_set_transient_for(window.fHandle, parent.fHandle)
  window.visible = true

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

method centerOnScreen(window: WindowImpl) =
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

method `control=`(window: WindowImpl, control: ControlImpl) =
  procCall window.Window.`control=`(control)
  gtk_container_add(window.fInnerHandle, control.fHandle)

method `iconPath=`(window: WindowImpl, iconPath: string) =
  procCall window.Window.`iconPath=`(iconPath)
  gtk_window_set_icon_from_file(window.fHandle, iconPath, nil)


# ----------------------------------------------------------------------------------------
#                                       Control
# ----------------------------------------------------------------------------------------

method pUpdateScrollBar(control: ControlImpl)

proc pControlDrawSignal(widget: pointer, cr: pointer, data: pointer): bool {.cdecl.} =
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
  var font = pango_font_description_new()
  pango_font_description_set_family(font, control.fontFamily)
  pango_font_description_set_size(font, cint(control.fontSize * pFontSizeFactor))
  gtk_widget_modify_font(control.fHandle, font)
  var rgba: GdkRGBA
  control.textColor.pColorToGdkRGBA(rgba)
  gtk_widget_override_color(control.fHandle, GTK_STATE_FLAG_NORMAL, rgba)

method pAddButtonPressEvent(control: ControlImpl) =
  gtk_widget_add_events(control.fHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(control.fHandle, "button-press-event", pCustomControlButtonPressSignal, cast[pointer](control))

proc init(control: ControlImpl) =

  if control.fHandle == nil:
    # Direct instance of ControlImpl:
    control.fHandle = gtk_layout_new(nil, nil)
    discard g_signal_connect_data(control.fHandle, "draw", pControlDrawSignal, cast[pointer](control))
    gtk_widget_add_events(control.fHandle, GDK_KEY_PRESS_MASK)
    discard g_signal_connect_data(control.fHandle, "key-press-event", pControlKeyPressSignal, cast[pointer](control))

  control.pAddButtonPressEvent()

  gtk_widget_add_events(control.fHandle, GDK_BUTTON_RELEASE_MASK)
  discard g_signal_connect_data(control.fHandle, "button-release-event", pControlButtonReleaseSignal, cast[pointer](control))

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

proc dummy(widget: pointer, event: var GdkEventButton, data: pointer): bool {.cdecl.} =
  echo "dummy"
  result = true # Stop propagation

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
    gtk_fixed_move(cast[ContainerImpl](control.fParentControl).fInnerHandle, control.fHandle, x.cint, y.cint)
    # gtk_layout_move(cast[ContainerImpl](control.fParentControl).fHandle, control.fHandle, x.cint, y.cint)

method forceRedraw(control: ControlImpl) = gtk_widget_queue_draw(control.fHandle)

# proc removeWidgetInternal(container: WidgetContainer, widget: Widget) = gtk_container_remove(container.innerHandle, widget.handle)

method setFontFamily(control: ControlImpl, fontFamily: string) =
  procCall control.Control.setFontFamily(fontFamily)
  control.pUpdateFont()

method setFontSize(control: ControlImpl, fontSize: int) =
  procCall control.Control.setFontSize(fontSize)
  control.pUpdateFont()

method setTextColor(control: ControlImpl, color: Color) =
  procCall control.Control.setTextColor(color)
  control.pUpdateFont()

method `setBackgroundColor=`(control: ControlImpl, color: Color) =
  procCall control.Control.setBackgroundColor(color)
  var rgba: GdkRGBA
  color.pColorToGdkRGBA(rgba)
  gtk_widget_override_background_color(control.fHandle, GTK_STATE_FLAG_NORMAL, rgba)
  # TODO: check why it has no effect

method getTextLineWidth(control: ControlImpl, text: string): int =
  var layout = gtk_widget_create_pango_layout(control.fHandle, text)
  var width: cint = 0
  var height: cint = 0
  pango_layout_get_pixel_size(layout, width, height)
  result = width

method getTextLineHeight(control: ControlImpl): int =
  var layout = gtk_widget_create_pango_layout(control.fHandle, "a")
  var width: cint = 0
  var height: cint = 0
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
  container.fInnerHandle = gtk_fixed_new()
  gtk_widget_show(container.fInnerHandle)
  gtk_container_add(container.fScrollWndHandle, container.fInnerHandle)
  container.Container.init()

method pUpdateScrollWnd(container: ContainerImpl) =
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

method add(container: ContainerImpl, control: ControlImpl) =
  gtk_container_add(container.fInnerHandle, control.fHandle)
  procCall container.Container.add(control)

method paddingLeft(container: ContainerImpl): int = 5 # TODO
method paddingRight(container: ContainerImpl): int = 5 # TODO
method paddingTop(container: ContainerImpl): int = 15 # TODO
method paddingBottom(container: ContainerImpl): int = 5 # TODO

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
  # echo "container.pUpdateScrollBar"

  var xPolicy: cint = GTK_POLICY_NEVER
  var yPolicy: cint = GTK_POLICY_NEVER
  if container.fXScrollEnabled:
    xPolicy = GTK_POLICY_AUTOMATIC
  if container.fYScrollEnabled:
    yPolicy = GTK_POLICY_AUTOMATIC
  gtk_scrolled_window_set_policy(container.fScrollWndHandle, xPolicy, yPolicy)


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
  # discard g_signal_connect_data(button.fHandle, "clicked", pWidgetClickSignal, cast[pointer](button))

method `text=`(button: NativeButton, text: string) =
  procCall button.Button.`text=`(text)
  gtk_button_set_label(button.fHandle, text)
  # Don't let the button expand:
  let list = gtk_container_get_children(button.fHandle)
  if list != nil:
    gtk_label_set_ellipsize(list.data, PANGO_ELLIPSIZE_END)
  app.processEvents()

method naturalWidth(button: NativeButton): int =
  # Override parent method, to make it big enough for the text to fit in.
  var context = gtk_widget_get_style_context(button.fHandle)
  var padding: GtkBorder
  gtk_style_context_get_padding(context, GTK_STATE_FLAG_NORMAL, padding)
  result = button.getTextLineWidth(button.text) + padding.left + padding.right + 5

method pAddButtonPressEvent(control: NativeButton) =
  gtk_widget_add_events(control.fHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(control.fHandle, "button-press-event", pDefaultControlButtonPressSignal, cast[pointer](control))

method `enabled=`(button: NativeButton, enabled: bool) =
  button.fEnabled = enabled
  gtk_widget_set_sensitive(button.fHandle, enabled)


# ----------------------------------------------------------------------------------------
#                                        Label
# ----------------------------------------------------------------------------------------

proc init(label: NativeLabel) =
  label.fHandle = gtk_label_new("")
  gtk_label_set_xalign(label.fHandle, 0)
  gtk_label_set_yalign(label.fHandle, 0.5)
  gtk_label_set_ellipsize(label.fHandle, PANGO_ELLIPSIZE_END)
  label.Label.init()

method `text=`(label: NativeLabel, text: string) =
  procCall label.Label.`text=`(text)
  gtk_label_set_text(label.fHandle, text)
  app.processEvents()

method naturalWidth(label: NativeLabel): int = label.getTextLineWidth(label.text) + 10
# Override parent method, to make it big enough for the text to fit in.

method pAddButtonPressEvent(control: NativeLabel) =
  gtk_widget_add_events(control.fHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(control.fHandle, "button-press-event", pDefaultControlButtonPressSignal, cast[pointer](control))


# ----------------------------------------------------------------------------------------
#                                       TextBox
# ----------------------------------------------------------------------------------------

proc pTextBoxKeyPressSignal(widget: pointer, event: var GdkEventKey, data: pointer): bool {.cdecl.} =
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
  discard g_signal_connect_data(textBox.fHandle, "key-press-event", pTextBoxKeyPressSignal, cast[pointer](textBox))
  discard g_signal_connect_data(textBox.fHandle, "changed", pControlChangedSignal, cast[pointer](textBox))
  textBox.TextBox.init()

method text(textBox: NativeTextBox): string = $gtk_entry_get_text(textBox.fHandle)

method `text=`(textBox: NativeTextBox, text: string) =
  gtk_entry_set_text(textBox.fHandle, text)
  app.processEvents()

method naturalHeight(textBox: NativeTextBox): int = textBox.getTextLineHeight() + 12 # add padding

method setSize(textBox: NativeTextBox, width, height: int) =
  gtk_entry_set_width_chars(textBox.fHandle, 1)
  procCall textBox.ControlImpl.setSize(width, height)

method pAddButtonPressEvent(control: NativeTextBox) =
  gtk_widget_add_events(control.fHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(control.fHandle, "button-press-event", pDefaultControlButtonPressSignal, cast[pointer](control))

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
  discard g_signal_connect_data(textArea.fTextViewHandle, "key-press-event", pTextBoxKeyPressSignal, cast[pointer](textArea))
  textArea.fBufferHandle = gtk_text_view_get_buffer(textArea.fTextViewHandle)
  discard g_signal_connect_data(textArea.fBufferHandle, "changed", pControlChangedSignal, cast[pointer](textArea))
  textArea.TextArea.init()

method setSize(textBox: NativeTextArea, width, height: int) =
  # Need to override method of NativeTextBox
  procCall textBox.ControlImpl.setSize(width, height)

method text(textArea: NativeTextArea): string =
  var startIter, endIter: GtkTextIter
  gtk_text_buffer_get_start_iter(textArea.fBufferHandle, startIter)
  gtk_text_buffer_get_end_iter(textArea.fBufferHandle, endIter)
  result = $gtk_text_buffer_get_text(textArea.fBufferHandle, startIter, endIter, true)

method `text=`(textArea: NativeTextArea, text: string) =
  gtk_text_buffer_set_text(textArea.fBufferHandle, text, text.len.cint)
  app.processEvents()

method addText(textArea: NativeTextArea, text: string) =
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

method pAddButtonPressEvent(control: NativeTextArea) =
  gtk_widget_add_events(control.fHandle, GDK_BUTTON_PRESS_MASK)
  discard g_signal_connect_data(control.fHandle, "button-press-event", pDefaultControlButtonPressSignal, cast[pointer](control))

method `wrap=`(textArea: NativeTextArea, wrap: bool) =
  procCall textArea.TextArea.`wrap=`(wrap)
  if wrap:
    gtk_text_view_set_wrap_mode(textArea.fTextViewHandle, GTK_WRAP_WORD_CHAR)
  else:
    gtk_text_view_set_wrap_mode(textArea.fTextViewHandle, GTK_WRAP_NONE)

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
