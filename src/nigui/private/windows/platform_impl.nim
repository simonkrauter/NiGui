# NiGui - Win32 platform-specific code - part 3

# This file will be included in "nigui.nim".

# Idendifiers, which are only used in this file, are marked with a leading "p".

# Imports:
# math, os, strutils, times are imported by nigui.nim
import windows
import tables


# ----------------------------------------------------------------------------------------
#                                    Internal Things
# ----------------------------------------------------------------------------------------

const pTopLevelWindowClass = "1"
const pContainerWindowClass = "2"
const pCustomControlWindowClass = "3"

var pDefaultParentWindow: pointer
var pKeyState: KeyState

# needed to calculate clicks:
var pLastMouseButtonDownControl: Control
var pLastMouseButtonDownControlX: int
var pLastMouseButtonDownControlY: int

proc pRaiseLastOSError(showAlert = true) =
  let e = osLastError()
  raiseError(osErrorMsg(e).strip & " (OS Error Code: " & $e & ")", showAlert)

proc pCheckGdiplusStatus(status: int32, showAlert = true) =
  if status != 0:
    if status == 7:
      pRaiseLastOSError(showAlert)
    else:
      raiseError("A GDI+ error occured. (Status: " & $status & ")", showAlert)

proc pColorToRGB32(color: Color): RGB32 =
  result.red = color.red
  result.green = color.green
  result.blue = color.blue

proc pRgb32ToColor(color: RGB32): Color =
  result.red = color.red
  result.green = color.green
  result.blue = color.blue

proc pColorToARGB(color: Color): ARGB =
  result.red = color.red
  result.green = color.green
  result.blue = color.blue
  result.alpha = color.alpha

proc pUtf8ToUtf16(s: string): string =
  # result is terminated with 2 null bytes
  if s.len == 0:
    return "\0"
  var characters = MultiByteToWideChar(CP_UTF8, 0, s, s.len.int32, nil, 0) # request number of characters
  if characters == 0: pRaiseLastOSError()
  result = newString(characters * 2 + 1)
  characters = MultiByteToWideChar(CP_UTF8, 0, s, s.len.int32, result, characters.int32) # do the conversion
  result[characters * 2] = '\0'
  result[characters * 2 + 1] = '\0'
  if characters == 0: pRaiseLastOSError()

proc pUtf16ToUtf8(s: string, searchEnd = false): string =
  if s.len == 0:
    return ""
  var characters = s.len div 2
  if searchEnd:
    # Search end of utf16 string:
    var i = 0
    while i < s.len - 1 and s[i].ord != 0:
      i.inc(2)
    characters = i div 2
  var bytes = WideCharToMultiByte(CP_UTF8, 0, s, characters.int32, nil, 0, nil, nil) # request number of bytes
  if bytes == 0: pRaiseLastOSError()
  result = newString(bytes)
  bytes = WideCharToMultiByte(CP_UTF8, 0, s, characters.int32, result, bytes.int32, nil, nil) # do the conversion
  if bytes == 0: pRaiseLastOSError()

proc pUnicodeCharToUtf8(unicode: int): string =
  var widestring = newString(2)
  widestring[0] = chr(unicode mod 256)
  widestring[1] = chr(unicode div 256)
  result = widestring.pUtf16ToUtf8

proc pUtf16ToUnicode(s: string): int = s[0].ord + s[1].ord * 256

proc pShowWindow(hWnd: pointer, nCmdShow: int32) = discard ShowWindow(hWnd, nCmdShow)

proc pSetWindowLong(hWnd: pointer, nIndex, dwNewLong: int32) =
  let result = SetWindowLongA(hWnd, nIndex, dwNewLong)
  if result == 0: pRaiseLastOSError()

proc pDestroyWindow(hWnd: pointer) =
  let result = DestroyWindow(hWnd)
  if not result: pRaiseLastOSError()

proc pSetParent(hWndChild, hWndNewParent: pointer) =
  let result = SetParent(hWndChild, hWndNewParent)
  if result == nil: pRaiseLastOSError()

proc pSetWindowText(hWnd: pointer, s: string) =
  let result = SetWindowTextW(hWnd, s.pUtf8ToUtf16)
  if not result: pRaiseLastOSError()

proc pGetWindowText(hWnd: pointer): string =
  let characters = GetWindowTextLengthW(hWnd)
  result = newString(characters * 2)
  var res = GetWindowTextW(hWnd, result, characters * 2 + 1)
  if res != characters: pRaiseLastOSError()
  result = result.pUtf16ToUtf8

proc pSetWindowPos(wnd: pointer, x, y, cx, cy: int, uFlags: int32 = 0) =
  var result = SetWindowPos(wnd, nil, x.int32, y.int32, cx.int32, cy.int32, uFlags)
  if not result: pRaiseLastOSError()

proc pGetClientRect(wnd: pointer): Rect =
  if not GetClientRect(wnd, result): pRaiseLastOSError()

proc pGetWindowRect(wnd: pointer): Rect =
  if not GetWindowRect(wnd, result): pRaiseLastOSError()

proc pCreateWindowEx(dwExStyle: int32, lpClassName, lpWindowName: cstring, dwStyle: int32, x, y, nWidth, nHeight: int, hWndParent, hMenu, hInstance, lpParam: pointer): pointer =
  result = CreateWindowExA(dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
  if result == nil: pRaiseLastOSError()

proc pGetWindowLongPtr(hWnd: pointer, nIndex: int32): pointer =
  when defined(cpu64):
    result = GetWindowLongPtrW(hWnd, nIndex)
  else:
    result = GetWindowLongW(hWnd, nIndex)

proc pSetWindowLongPtr(hWnd: pointer, nIndex: int32, dwNewLong: pointer): pointer =
  when defined(cpu64):
    result = SetWindowLongPtrW(hWnd, nIndex, dwNewLong)
  else:
    result = SetWindowLongW(hWnd, nIndex, dwNewLong)

# proc pGetStockObject(fnObject: int32): pointer =
  # result = GetStockObject(fnObject)
  # if result == nil: pRaiseLastOSError()

proc pCreateWindowExWithUserdata(lpClassName: cstring, dwStyle, dwExStyle: int32, hWndParent, userdata: pointer = nil): pointer =
  result = pCreateWindowEx(dwExStyle, lpClassName, nil, dwStyle, 0, 0, 0, 0, hWndParent, nil, nil, nil)
  if userdata != nil:
    discard pSetWindowLongPtr(result, GWLP_USERDATA, userdata)
  # Set default font:
  # discard SendMessageA(result, WM_SETFONT, pGetStockObject(DEFAULT_GUI_FONT), cast[pointer](true))
  # Set window proc:
  # discard pSetWindowLongPtr(result, GWLP_WNDPROC, pCommonWndProc)

proc pEnableVisualStyles() =
  # Without this, controls have style of Windows 95
  const MaxLength = 500
  var dir = newString(MaxLength)
  if GetSystemDirectoryA(dir[0].addr, MaxLength) == 0: pRaiseLastOSError()
  var actCtx: ActCtx
  actCtx.cbSize = ActCtx.sizeof.int32
  actCtx.dwFlags = ACTCTX_FLAG_RESOURCE_NAME_VALID or ACTCTX_FLAG_SET_PROCESS_DEFAULT or ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID
  actCtx.lpSource = "shell32.dll"
  actCtx.wProcessorArchitecture = 0
  actCtx.wLangId = 0
  actCtx.lpAssemblyDirectory = dir
  actCtx.lpResourceName = cast[cstring](124)
  actCtx.lpApplicationName = nil
  actCtx.hModule = nil
  var context = CreateActCtxA(actCtx.addr)
  if context == INVALID_HANDLE_VALUE: pRaiseLastOSError()
  # has no effect:
  # var ulpActivationCookie = false
  # if not ActivateActCtx(context, ulpActivationCookie.addr): pRaiseLastOSError()

proc pRegisterWindowClass(className: cstring, wndProc: pointer, style: int32 = 0) =
  var class: WndClassEx
  class.cbSize = WndClassEx.sizeof.int32
  class.lpszClassName = className
  class.lpfnWndProc = wndProc
  class.style = style
  class.cbClsExtra = 0
  class.cbWndExtra = 0
  class.hInstance = nil
  class.hIcon = nil
  class.hCursor = LoadCursorA(nil, cast[cstring](IDC_ARROW))
  class.hbrBackground = CreateSolidBrush(GetSysColor(COLOR_BTNFACE)) # default background
  class.lpszMenuName = nil
  class.hIconSm = nil
  if RegisterClassExA(class) == 0: pRaiseLastOSError()

proc pCommonWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.cdecl.} =
  case uMsg
  of WM_COMMAND:
    if wParam.hiWord == EN_CHANGE:
      let control = cast[Control](pGetWindowLongPtr(lParam, GWLP_USERDATA))
      var evt = new TextChangeEvent
      control.handleTextChangeEvent(evt)
  of WM_CTLCOLOREDIT:
    let control = cast[Control](pGetWindowLongPtr(lParam, GWLP_USERDATA))
    discard SetTextColor(wParam, control.textColor.pColorToRGB32())
    # discard SetBkColor(wParam, control.backgroundColor.pColorToRGB32())
    # does not cover complete background
    return GetCurrentObject(wParam, OBJ_BRUSH)
  else:
    discard
  result = DefWindowProcA(hWnd, uMsg, wParam, lParam)

proc pVirtualKeyToKey(keyval: int): Key =
  case keyval
  of 37: Key_Left
  of 38: Key_Up
  of 39: Key_Right
  of 40: Key_Down
  of 35: Key_End
  of 36: Key_Home
  of 33: Key_PageUp
  of 34: Key_PageDown
  else: cast[Key](keyval.unicodeToUpper)

proc pHandleWMKEYDOWNOrWMCHAR(window: Window, control: Control, unicode: int, key: Key): bool =
  var windowEvent = new WindowKeyEvent
  windowEvent.window = window
  windowEvent.key = key
  if windowEvent.key == Key_None:
    echo "WM_CHAR: Unkown key value: ", unicode
    return

  windowEvent.unicode = unicode
  windowEvent.character = unicode.pUnicodeCharToUtf8

  window.handleKeyDownEvent(windowEvent)

  if control != nil:
    var controlEvent = new ControlKeyEvent
    controlEvent.control = control
    controlEvent.key = windowEvent.key
    controlEvent.unicode = windowEvent.unicode
    controlEvent.character = windowEvent.character
    control.handleKeyDownEvent(controlEvent)
    result = controlEvent.cancel

proc pHandleWMKEYDOWN(window: Window, control: Control, wParam, lParam: pointer): bool =
  if not GetKeyboardState(pKeyState): pRaiseLastOSError()
  var widestring = newString(2)
  let scancode = int32((cast[int](lParam) shr 8) and 0xFFFFFF00)
  let ret = ToUnicode(cast[int](wParam).int32, scancode, pKeyState, widestring, 1, 0)
  if ret == 1:
    return # Unicode characters are handled by WM_CHAR
  result = pHandleWMKEYDOWNOrWMCHAR(window, control, 0, pVirtualKeyToKey(cast[int](wParam)))

proc pHandleWMCHAR(window: Window, control: Control, wParam, lParam: pointer): bool =
  let unicode = cast[int](wParam)
  result = pHandleWMKEYDOWNOrWMCHAR(window, control, unicode, cast[Key](unicode.unicodeToUpper))

proc pWindowWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.cdecl.} =
  case uMsg
  of WM_CLOSE:
    let window = cast[WindowImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    window.closeClick()
    return cast[pointer](true) # keeps the window open, else the window will be destroyed
  of WM_SIZE:
    let window = cast[WindowImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if window != nil:
      var rect = pGetWindowRect(window.fHandle)
      window.width = rect.right - rect.left
      window.height = rect.bottom - rect.top
      rect = pGetClientRect(window.fHandle)
      window.fClientWidth = rect.right - rect.left
      window.fClientHeight = rect.bottom - rect.top
      window.triggerRelayout()
  of WM_MOVE:
    let window = cast[WindowImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if window != nil:
      var rect = pGetWindowRect(window.fHandle)
      window.fX = rect.left
      window.fY = rect.top
      # echo "WM_MOVE: " & $rect.left & ", " & $rect.top
  of WM_SETFOCUS:
    discard
    #echo "window WM_SETFOCUS"
    # not called?
  of WM_DROPFILES:
    let window = cast[WindowImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    var files: seq[string] = @[]
    let count = DragQueryFileW(wParam, 0xFFFFFFFF.uint32, nil, 0)
    for i in 0..count - 1:
      let characters = DragQueryFileW(wParam, i.uint32 , nil, 0)
      var filename = newString(characters * 2)
      discard DragQueryFileW(wParam, i.uint32, filename, characters + 1)
      files.add(filename.pUtf16ToUtf8)
    DragFinish(wParam)
    var event = new DropFilesEvent
    event.window = window
    event.files = files
    window.handleDropFilesEvent(event)
  of WM_KEYDOWN:
    let window = cast[Window](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if window != nil and pHandleWMKEYDOWN(window, nil, wParam, lParam):
      return
  of WM_CHAR:
    let window = cast[Window](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if window != nil and pHandleWMCHAR(window, nil, wParam, lParam):
      return
  of WM_SYSCOMMAND:
    let window = cast[Window](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if window != nil:
      if cast[int](wParam) == SC_MINIMIZE:
        window.fMinimized = true
        echo "a"
      elif cast[int](wParam) == SC_RESTORE:
        window.fMinimized = false
        echo "b"
  else:
    discard
  result = pCommonWndProc(hWnd, uMsg, wParam, lParam)

proc pContainerWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.cdecl.}

proc pCommonControlWndProc(origWndProc, hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer

proc pCustomControlWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.cdecl.}

proc pInitGdiplus() =
  var input: GdiplusStartupInput
  input.GdiplusVersion = 1
  var gidplus: pointer = nil
  pCheckGdiplusStatus(GdiplusStartup(gidplus, input, nil))

proc pGetTextSize(hDC, font: pointer, text: string): Size =
  let wideText = text.pUtf8ToUtf16
  discard SelectObject(hdc, font)
  discard GetTextExtentPoint32W(hdc, wideText, (wideText.len div 2).int32, result)


# ----------------------------------------------------------------------------------------
#                                    App Procedures
# ----------------------------------------------------------------------------------------

proc init(app: App) =
  pInitGdiplus()
  pEnableVisualStyles()
  pRegisterWindowClass(pTopLevelWindowClass, pWindowWndProc)
  pRegisterWindowClass(pCustomControlWindowClass, pCustomControlWndProc, CS_HREDRAW or CS_VREDRAW)
  pRegisterWindowClass(pContainerWindowClass, pContainerWndProc)
  pDefaultParentWindow = pCreateWindowEx(0, pTopLevelWindowClass, nil, 0, 0, 0, 0, 0, nil, nil, nil, nil)
  app.defaultTextColor = GetSysColor(COLOR_WINDOWTEXT).pRgb32ToColor()
  app.defaultBackgroundColor = GetSysColor(COLOR_BTNFACE).pRgb32ToColor()
  app.defaultFontFamily = "Arial"
  fScrollbarSize = GetSystemMetrics(SM_CXVSCROLL)

proc runMainLoop() =
  var msg: Msg
  while GetMessageA(msg.addr, nil, 0, 0):
    discard TranslateMessage(msg.addr)
    discard DispatchMessageA(msg.addr)

proc processEvents(app: App) =
  var msg: Msg
  while PeekMessageA(msg.addr, nil, 0, 0, PM_REMOVE):
    discard TranslateMessage(msg.addr)
    discard DispatchMessageA(msg.addr)

proc clipboardText(app: App): string =
  result = ""
  if not OpenClipboard(nil):
    return
  let data = GetClipboardData(CF_TEXT)
  if data == nil:
    return
  let text = cast[cstring](GlobalLock(data))
  if text == nil:
    return
  result = $text
  discard GlobalUnlock(data)
  discard CloseClipboard()

proc `clipboardText=`(app: App, text: string) =
  if not OpenClipboard(nil):
    return
  let size = text.len + 1
  let data = GlobalAlloc(GMEM_MOVEABLE, size.int32)
  if data == nil:
    return
  let mem = GlobalLock(data)
  if mem == nil:
    return
  copyMem(mem, text.cstring, size)
  discard GlobalUnlock(data)
  discard EmptyClipboard()
  discard SetClipboardData(CF_TEXT, data)
  discard CloseClipboard()


# ----------------------------------------------------------------------------------------
#                                       Dialogs
# ----------------------------------------------------------------------------------------

proc alert(window: Window, message: string, title = "Message") =
  var hWnd: pointer
  if window != nil:
    hWnd = cast[WindowImpl](window).fHandle
  MessageBoxW(hWnd, message.pUtf8ToUtf16, title.pUtf8ToUtf16, 0)

method run*(dialog: OpenFileDialog) =
  const maxCharacters = 5000
  dialog.files = @[]
  var ofn: OpenFileName
  ofn.lStructSize = OpenFileName.sizeOf.int32
  ofn.nMaxFile = maxCharacters
  ofn.lpstrInitialDir = getCurrentDir().pUtf8ToUtf16()
  ofn.Flags = OFN_FILEMUSTEXIST
  if dialog.multiple:
    ofn.Flags = ofn.Flags or OFN_ALLOWMULTISELECT or OFN_EXPLORER
  var s = newString(maxCharacters * 2)
  ofn.lpstrFile = s
  let ret = GetOpenFileNameW(ofn)
  if ret:
    var dirOrFirstFile: string
    # Split selected file names:
    while s[0].ord != 0:
      var i = 0
      while i < s.len - 1 and s[i].ord != 0:
        i.inc(2)
      let filename = s.substr(0, i - 1).pUtf16ToUtf8()
      if dirOrFirstFile == nil:
        dirOrFirstFile = filename
      else:
        dialog.files.add(dirOrFirstFile / filename)
      s = s.substr(i + 2)
    if dialog.files.len == 0:
      dialog.files.add(dirOrFirstFile)
  else:
    let e = CommDlgExtendedError()
    if e != 0:
      raiseError("CommDlg Error Code: " & $e)

method run(dialog: SaveFileDialog) =
  const maxCharacters = 500
  var ofn: OpenFileName
  ofn.lStructSize = OpenFileName.sizeOf.int32
  ofn.nMaxFile = maxCharacters
  ofn.lpstrInitialDir = getCurrentDir().pUtf8ToUtf16()
  if dialog.defaultExtension.len > 0:
    ofn.lpstrDefExt = pUtf8ToUtf16(dialog.defaultExtension)
    ofn.lpstrFilter = pUtf8ToUtf16(dialog.defaultExtension & "\0*." & dialog.defaultExtension & "\0All files\0*.*")
  ofn.Flags = OFN_OVERWRITEPROMPT
  var s = newString(maxCharacters * 2)
  if dialog.defaultName.len > 0:
    let temp = pUtf8ToUtf16(dialog.defaultName)
    for i in 0..temp.len:
      s[i] = temp[i]
  ofn.lpstrFile = s
  let ret = GetSaveFileNameW(ofn)
  if ret:
    dialog.file = pUtf16ToUtf8(s, true)
  else:
    dialog.file = ""
    let e = CommDlgExtendedError()
    if e != 0:
      raiseError("CommDlg Error Code: " & $e)


# ----------------------------------------------------------------------------------------
#                                       Timers
# ----------------------------------------------------------------------------------------

type TimerEntry = object
  timerProc: TimerProc
  data: pointer

var pTimers = initTable[int64, TimerEntry]()

proc pTimerFunction(hwnd: pointer, uMsg: int32, idEvent: pointer, dwTime: int32) {.cdecl.} =
  discard KillTimer(hwnd, idEvent)
  let timerEntry = pTimers.getOrDefault(cast[int](idEvent))
  var event = new TimerEvent
  event.timer = cast[Timer](idEvent)
  event.data = timerEntry.data
  timerEntry.timerProc(event)
  pTimers.del(cast[int](idEvent))

proc pRepeatingTimerFunction(hwnd: pointer, uMsg: int32, idEvent: pointer, dwTime: int32) {.cdecl.} =
  let timerEntry = pTimers.getOrDefault(cast[int](idEvent))
  var event = new TimerEvent
  event.timer = cast[Timer](idEvent)
  event.data = timerEntry.data
  timerEntry.timerProc(event)

proc startTimer(milliSeconds: int, timerProc: TimerProc, data: pointer = nil): Timer =
  result = cast[Timer](SetTimer(nil, nil, milliSeconds.int32, pTimerFunction))
  var timerEntry: TimerEntry
  timerEntry.timerProc = timerProc
  timerEntry.data = data
  pTimers[cast[int](result)] = timerEntry

proc startRepeatingTimer(milliSeconds: int, timerProc: TimerProc, data: pointer = nil): Timer =
  result = cast[Timer](SetTimer(nil, nil, milliSeconds.int32, pRepeatingTimerFunction))
  var timerEntry: TimerEntry
  timerEntry.timerProc = timerProc
  timerEntry.data = data
  pTimers[cast[int](result)] = timerEntry

proc stop(timer: var Timer) =
  if cast[int](timer) != inactiveTimer:
    let timerEntry = pTimers.getOrDefault(cast[int](timer))
    pTimers.del(cast[int](timer))
    discard KillTimer(nil, cast[pointer](timer))
    timer = cast[Timer](inactiveTimer)


# ----------------------------------------------------------------------------------------
#                                       Canvas
# ----------------------------------------------------------------------------------------

proc pUpdateFont(canvas: Canvas) =
  let canvasImpl = cast[CanvasImpl](canvas)
  if canvasImpl.fFont == nil:
    var fontFamily: pointer
    pCheckGdiplusStatus(GdipCreateFontFamilyFromName(canvas.fontFamily.pUtf8ToUtf16(), nil, fontFamily))
    pCheckGdiplusStatus(GdipCreateFont(fontFamily, canvas.fontSize.float, 0, UnitPixel, canvasImpl.fFont))
    pCheckGdiplusStatus(GdipDeleteFontFamily(fontFamily))

proc pDeleteFont(canvas: CanvasImpl) =
  if canvas.fFont != nil:
    pCheckGdiplusStatus(GdipDeleteFont(canvas.fFont))
    canvas.fFont = nil

proc pDeleteFontBrush(canvas: CanvasImpl) =
  if canvas.fFontBrush != nil:
    pCheckGdiplusStatus(GdipDeleteBrush(canvas.fFontBrush))
    canvas.fFontBrush = nil

proc pDeleteAreaBrush(canvas: CanvasImpl) =
  if canvas.fAreaBrush != nil:
    pCheckGdiplusStatus(GdipDeleteBrush(canvas.fAreaBrush))
    canvas.fAreaBrush = nil

proc pDeleteLinePen(canvas: CanvasImpl) =
  if canvas.fLinePen != nil:
    pCheckGdiplusStatus(GdipDeletePen(canvas.fLinePen))
    canvas.fLinePen = nil

method destroy(canvas: CanvasImpl) =
  procCall canvas.Canvas.destroy()
  let canvasImpl = cast[CanvasImpl](canvas)
  if canvasImpl.fBitmap == nil:
    pDeleteFont(canvas)
    pDeleteFontBrush(canvas)
    pDeleteLinePen(canvas)
    pDeleteAreaBrush(canvas)
    if canvas.fGraphics != nil:
      pCheckGdiplusStatus(GdipDeleteGraphics(canvas.fGraphics))

method drawText(canvas: Canvas, text: string, x, y = 0) =
  let canvasImpl = cast[CanvasImpl](canvas)
  if canvasImpl.fGraphics == nil:
    raiseError("Canvas is not in drawing state.")
  canvas.pUpdateFont()
  if canvasImpl.fFontBrush == nil:
    pCheckGdiplusStatus(GdipCreateSolidFill(canvas.textColor.pColorToARGB(), canvasImpl.fFontBrush))
  var rect: RectF
  rect.x = x.float
  rect.y = y.float
  pCheckGdiplusStatus(GdipDrawString(canvasImpl.fGraphics, text.pUtf8ToUtf16(), -1, canvasImpl.fFont, rect, nil, canvasImpl.fFontBrush))

method drawLine(canvas: Canvas, x1, y1, x2, y2: int) =
  let canvasImpl = cast[CanvasImpl](canvas)
  if canvasImpl.fGraphics == nil:
    raiseError("Canvas is not in drawing state.")
  if canvasImpl.fLinePen == nil:
    pCheckGdiplusStatus(GdipCreatePen1(canvas.lineColor.pColorToARGB(), 1, UnitPixel, canvasImpl.fLinePen))
  pCheckGdiplusStatus(GdipDrawLineI(canvasImpl.fGraphics, canvasImpl.fLinePen, x1.int32, y1.int32, x2.int32, y2.int32))

method drawRectArea(canvas: Canvas, x, y, width, height: int) =
  let canvasImpl = cast[CanvasImpl](canvas)
  if canvasImpl.fGraphics == nil:
    raiseError("Canvas is not in drawing state.")
  if canvasImpl.fAreaBrush == nil:
    pCheckGdiplusStatus(GdipCreateSolidFill(canvas.areaColor.pColorToARGB(), canvasImpl.fAreaBrush))
  pCheckGdiplusStatus(GdipFillRectangleI(canvasImpl.fGraphics, canvasImpl.fAreaBrush, x.int32, y.int32, width.int32, height.int32))

method drawRectOutline(canvas: Canvas, x, y, width, height: int) =
  let canvasImpl = cast[CanvasImpl](canvas)
  if canvasImpl.fGraphics == nil:
    raiseError("Canvas is not in drawing state.")
  var pen: pointer
  pCheckGdiplusStatus(GdipCreatePen1(canvas.lineColor.pColorToARGB(), 1, UnitPixel, pen))
  pCheckGdiplusStatus(GdipDrawRectangleI(canvasImpl.fGraphics, pen, x.int32, y.int32, width.int32, height.int32))

method drawImage(canvas: Canvas, image: Image, x, y = 0, width, height = -1) =
  var drawWith = image.width
  var drawHeight = image.height
  if width != -1:
    drawWith = width
    drawHeight = int(drawHeight * drawWith / image.width)
  if height != -1:
    drawHeight = height
  let canvasImpl = cast[CanvasImpl](canvas)
  let imageCanvas = cast[CanvasImpl](image.canvas)
  if canvasImpl.fGraphics == nil:
    raiseError("Canvas is not in drawing state.")
  pCheckGdiplusStatus(GdipDrawImageRectI(canvasImpl.fGraphics, imageCanvas.fBitmap, x.int32, y.int32, drawWith.int32, drawHeight.int32))

method setPixel(canvas: Canvas, x, y: int, color: Color) =
  let canvasImpl = cast[CanvasImpl](canvas)
  if canvasImpl.fBitmap == nil:
    if canvasImpl.fDC == nil:
      raiseError("Canvas is not in drawing state.")
    discard SetPixel(canvasImpl.fDC, x.int32, y.int32, color.pColorToRGB32)
  else:
    let imageCanvas = cast[CanvasImpl](canvas)
    pCheckGdiplusStatus(GdipBitmapSetPixel(imageCanvas.fBitmap, x.int32, y.int32, color.pColorToARGB()))

method `fontFamily=`(canvas: CanvasImpl, fontFamily: string) =
  procCall canvas.Canvas.`fontFamily=`(fontFamily)
  canvas.pDeleteFont()

method `fontSize=`(canvas: CanvasImpl, fontSize: int) =
  procCall canvas.Canvas.`fontSize=`(fontSize)
  canvas.pDeleteFont()

method `textColor=`(canvas: CanvasImpl, color: Color) =
  procCall canvas.Canvas.`textColor=`(color)
  canvas.pDeleteFontBrush()

method `lineColor=`(canvas: CanvasImpl, color: Color) =
  procCall canvas.Canvas.`lineColor=`(color)
  pDeleteLinePen(canvas)

method `areaColor=`(canvas: CanvasImpl, color: Color) =
  procCall canvas.Canvas.`areaColor=`(color)
  pDeleteAreaBrush(canvas)

proc pGetTextSize(canvas: Canvas, text: string): Size =
  let canvasImpl = cast[CanvasImpl](canvas)
  canvas.pUpdateFont()
  var rect: RectF
  var boundingBox: RectF
  pCheckGdiplusStatus(GdipMeasureString(canvasImpl.fGraphics, text.pUtf8ToUtf16(), -1, canvasImpl.fFont, rect, nil, boundingBox, nil, nil))
  result.cx = boundingBox.width.int32
  result.cy = boundingBox.height.int32

method getTextLineWidth(canvas: CanvasImpl, text: string): int = canvas.pGetTextSize(text).cx

method getTextLineHeight(canvas: CanvasImpl): int = canvas.pGetTextSize("a").cy


# ----------------------------------------------------------------------------------------
#                                        Image
# ----------------------------------------------------------------------------------------

method resize(image: Image, width, height: int) =
  let canvas = cast[CanvasImpl](image.canvas)
  if canvas.fBitmap != nil:
    pCheckGdiplusStatus(GdipDisposeImage(canvas.fBitmap), false)
    pCheckGdiplusStatus(GdipDeleteGraphics(canvas.fGraphics))
    canvas.fBitmap = nil
    canvas.fGraphics = nil
  var dc = CreateCompatibleDC(nil)
  pCheckGdiplusStatus(GdipCreateFromHDC(dc, canvas.fGraphics))
  pCheckGdiplusStatus(GdipCreateBitmapFromGraphics(width.int32, height.int32, canvas.fGraphics, canvas.fBitmap))
  pCheckGdiplusStatus(GdipGetImageGraphicsContext(canvas.fBitmap, canvas.fGraphics)) # it's a new Graphic
  image.canvas.fWidth = width
  image.canvas.fHeight = height

method loadFromFile(image: Image, filePath: string) =
  let canvas = cast[CanvasImpl](image.canvas)
  if canvas.fBitmap != nil:
    pCheckGdiplusStatus(GdipDisposeImage(canvas.fBitmap), false)
    pCheckGdiplusStatus(GdipDeleteGraphics(canvas.fGraphics))
    canvas.fBitmap = nil
    canvas.fGraphics = nil
  image.canvas.fWidth = 0
  image.canvas.fHeight = 0
  pCheckGdiplusStatus(GdipCreateBitmapFromFile(filePath.pUtf8ToUtf16(), canvas.fBitmap), false)
  pCheckGdiplusStatus(GdipGetImageGraphicsContext(canvas.fBitmap, canvas.fGraphics))
  var width, height: int32
  pCheckGdiplusStatus(GdipGetImageWidth(canvas.fBitmap, width))
  pCheckGdiplusStatus(GdipGetImageHeight(canvas.fBitmap, height))
  image.canvas.fWidth = width
  image.canvas.fHeight = height

method saveToPngFile(image: Image, filePath: string) =
  let canvas = cast[CanvasImpl](image.canvas)
  var clsidEncoder: GUID
  clsidEncoder.Data1 = 0x557cf406
  clsidEncoder.Data2 = 0x11d31a04
  clsidEncoder.Data3 = 0x0000739a
  clsidEncoder.Data4 = 0x2ef31ef8
  pCheckGdiplusStatus(GdipSaveImageToFile(canvas.fBitmap, filePath.pUtf8ToUtf16(), clsidEncoder.addr, nil), false)

method saveToJpegFile(image: Image, filePath: string, quality = 80) =
  let canvas = cast[CanvasImpl](image.canvas)
  var clsidEncoder: GUID
  clsidEncoder.Data1 = 0x557cf401
  clsidEncoder.Data2 = 0x11d31a04
  clsidEncoder.Data3 = 0x0000739a
  clsidEncoder.Data4 = 0x2ef31ef8
  # TODO: pass quality
  pCheckGdiplusStatus(GdipSaveImageToFile(canvas.fBitmap, filePath.pUtf8ToUtf16(), clsidEncoder.addr, nil), false)


# ----------------------------------------------------------------------------------------
#                                        Window
# ----------------------------------------------------------------------------------------

proc init(window: WindowImpl) =
  if pDefaultParentWindow == nil:
    raiseError("You need to call 'app.init()' at first.")
  var dwStyle: int32 = WS_OVERLAPPEDWINDOW
  window.fHandle = pCreateWindowExWithUserdata(pTopLevelWindowClass, dwStyle, 0, nil, cast[pointer](window))
  DragAcceptFiles(window.fHandle, true)
  window.Window.init()

method destroy(window: WindowImpl) =
  if window.fModalParent != nil:
    discard EnableWindow(window.fModalParent.fHandle, true)
  procCall window.Window.destroy()
  pDestroyWindow(window.fHandle)
  window.fHandle = nil

method `visible=`(window: WindowImpl, visible: bool) =
  procCall window.Window.`visible=`(visible)
  if visible:
    # pShowWindow(window.fHandle, SW_SHOW)
    pShowWindow(window.fHandle, SW_RESTORE)
  else:
    pShowWindow(window.fHandle, SW_HIDE)

method showModal(window, parent: WindowImpl) =
  # Set window owner, to hide it from the taskbar
  discard pSetWindowLongPtr(window.fHandle, GWL_HWNDPARENT, parent.fHandle)

  # Hide minimize and maximize buttons:
  pSetWindowLong(window.fHandle, GWL_STYLE, WS_CAPTION or WS_THICKFRAME or WS_SYSMENU)
  # pSetWindowLong(window.fHandle, GWL_EXSTYLE, WS_EX_TOOLWINDOW) # does not look good

  window.fModalParent = parent
  window.visible = true
  discard EnableWindow(parent.fHandle, false)

method minimize(window: WindowImpl) =
  procCall window.Window.minimize()
  pShowWindow(window.fHandle, SW_MINIMIZE)

proc pUpdatePosition(window: WindowImpl) =
  pSetWindowPos(window.fHandle, window.x, window.y, -1, -1, SWP_NOSIZE)
  # discard MoveWindow(window.fHandle, window.x.int32, window.y.int32, window.width.int32, window.height.int32, false)
  # no difference

proc pUpdateSize(window: WindowImpl) = pSetWindowPos(window.fHandle, -1, -1, window.width, window.height, SWP_NOMOVE)

method `x=`(window: WindowImpl, x: int) =
  procCall window.Window.`x=`(x)
  window.pUpdatePosition()

method `y=`(window: WindowImpl, y: int) =
  procCall window.Window.`y=`(y)
  window.pUpdatePosition()

method centerOnScreen(window: WindowImpl) =
  let desktop = GetDesktopWindow()
  var rect: Rect
  discard SystemParametersInfoA(SPI_GETWORKAREA, 0, rect.addr, 0)
  window.fX = rect.left + (rect.right - window.width) div 2
  window.fY = rect.top + (rect.bottom - window.height) div 2
  window.pUpdatePosition()

  # TODO: regard multiple monitors
  # var m = MonitorFromRect(rect, 0)
  # var mi: MonitorInfo
  # discard GetMonitorInfoA(m, mi)
  # echo "GetMonitorInfoA: " & $mi.rcMonitor.left
  # echo "GetMonitorInfoA: " & $mi.rcWork.left

method `width=`*(window: WindowImpl, width: int) =
  procCall window.Window.`width=`(width)
  window.pUpdateSize()

method `height=`*(window: WindowImpl, height: int) =
  procCall window.Window.`height=`(height)
  window.pUpdateSize()

method `title=`(window: WindowImpl, title: string) =
  procCall window.Window.`title=`(title)
  pSetWindowText(window.fHandle, window.title)

method `control=`(window: WindowImpl, control: ControlImpl) =
  if window.control != nil:
    pSetParent(cast[ControlImpl](window.control).fHandle, pDefaultParentWindow)
    window.control.fParentWindow = nil
  procCall window.Window.`control=`(control)
  pSetParent(control.fHandle, window.fHandle)

method `iconPath=`(window: WindowImpl, iconPath: string) =
  procCall window.Window.`iconPath=`(iconPath)
  var bitmap: pointer
  pCheckGdiplusStatus(GdipCreateBitmapFromFile(iconPath.pUtf8ToUtf16(), bitmap))
  var icon: pointer
  pCheckGdiplusStatus(GdipGetHicon(bitmap, icon))
  discard SendMessageA(window.fHandle, WM_SETICON, cast[pointer](ICON_BIG), icon)
  discard SendMessageA(window.fHandle, WM_SETICON, cast[pointer](ICON_SMALL), icon)


# ----------------------------------------------------------------------------------------
#                                       Control
# ----------------------------------------------------------------------------------------

method pUpdateScrollBar(control: ControlImpl)

proc init(control: ControlImpl) =
  if control.fHandle == nil:
    var dwStyle: int32 = WS_CHILD
    control.fHandle = pCreateWindowExWithUserdata(pCustomControlWindowClass, dwStyle, 0, pDefaultParentWindow, cast[pointer](control))
  procCall control.Control.init()

method destroy(control: ControlImpl) =
  procCall control.Control.destroy()
  if control.canvas != nil:
    control.canvas.destroy()
  pDestroyWindow(control.fHandle)

method `visible=`(control: ControlImpl, visible: bool) =
  procCall control.Control.`visible=`(visible)
  if visible:
    pShowWindow(control.fHandle, SW_SHOW)
  else:
    pShowWindow(control.fHandle, SW_HIDE)

method setSize(control: ControlImpl, width, height: int) =
  procCall control.Control.setSize(width, height)
  pSetWindowPos(control.fHandle, -1, -1, width, height, SWP_NOMOVE)
  pUpdateScrollBar(control)

method setPosition(control: ControlImpl, x, y: int) =
  procCall control.Control.setPosition(x, y)
  pSetWindowPos(control.fHandle, x, y, -1, -1, SWP_NOSIZE)

method pUpdateScrollBar(control: ControlImpl) =
  if control.fScrollableWidth == -1 and control.fScrollableHeight == -1:
    return
  # echo "control.pUpdateScrollBar " & control.tag

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

  # Apply settings:

  discard ShowScrollBar(control.fHandle, SB_HORZ, control.fXScrollEnabled)
  if control.fXScrollEnabled:
    var si: ScrollInfo
    si.cbSize = ScrollInfo.sizeOf.int32
    si.fMask = SIF_ALL
    si.nMin = 0
    si.nMax = control.fScrollableWidth.int32
    if control.fYScrollEnabled:
      si.nMax.inc(fScrollbarSize)
    si.nPage = control.width.int32
    si.nPos = control.fXScrollPos.int32
    si.nTrackPos = 0
    discard SetScrollInfo(control.fHandle, SB_HORZ, si, false)
    # Ensure that scroll pos is within range:
    control.fXScrollPos = max(min(control.fXScrollPos, si.nMax - control.width), 0)
  else:
    control.fXScrollPos = 0

  discard ShowScrollBar(control.fHandle, SB_VERT, control.fYScrollEnabled)
  if control.fYScrollEnabled:
    var si: ScrollInfo
    si.cbSize = ScrollInfo.sizeOf.int32
    si.fMask = SIF_ALL
    si.nMin = 0
    si.nMax = control.fScrollableHeight.int32
    if control.fXScrollEnabled:
      si.nMax.inc(fScrollbarSize)
    si.nPage = control.height.int32
    si.nPos = control.fYScrollPos.int32
    si.nTrackPos = 0
    discard SetScrollInfo(control.fHandle, SB_VERT, si, false)
    # Ensure that scroll pos is within range:
    control.fYScrollPos = max(min(control.fYScrollPos, si.nMax - control.height), 0)
  else:
    control.fYScrollPos = 0

method `xScrollPos=`(control: ControlImpl, xScrollPos: int) =
  procCall control.Control.`xScrollPos=`(xScrollPos)
  control.pUpdateScrollBar()
  control.forceRedraw()

method `yScrollPos=`(control: ControlImpl, yScrollPos: int) =
  procCall control.Control.`yScrollPos=`(yScrollPos)
  control.pUpdateScrollBar()
  control.forceRedraw()

method `scrollableWidth=`(control: ControlImpl, scrollableWidth: int) =
  procCall control.Control.`scrollableWidth=`(scrollableWidth)
  control.pUpdateScrollBar()

method `scrollableHeight=`(control: ControlImpl, scrollableHeight: int) =
  procCall control.Control.`scrollableHeight=`(scrollableHeight)
  control.pUpdateScrollBar()

method forceRedraw(control: ControlImpl) = discard InvalidateRect(control.fHandle, nil, true)

proc pUpdateFont(control: ControlImpl) =
  if control.fFont != nil:
    discard DeleteObject(control.fFont)
  control.fFont = CreateFontA(control.fontSize.int32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, control.fontFamily)
  discard SendMessageA(control.fHandle, WM_SETFONT, control.fFont, cast[pointer](true))

method setFontFamily(control: ControlImpl, fontFamily: string) =
  procCall control.Control.setFontFamily(fontFamily)
  control.pUpdateFont()

method setFontSize(control: ControlImpl, fontSize: int) =
  procCall control.Control.setFontSize(fontSize)
  control.pUpdateFont()

# method `setBackgroundColor=`(control: ControlImpl, color: Color) =
  # procCall control.Control.setBackgroundColor(color)
  # var brush = CreateSolidBrush(color.pColorToRGB32())
  # discard SetClassLongPtrA(control.fHandle, GCLP_HBRBACKGROUND, brush)
  # no effect

proc pGetTextSize(control: ControlImpl, text: string): Size =
  let hdc = GetDC(control.fHandle)
  result = pGetTextSize(hdc, control.fFont, text)
  discard DeleteDC(hdc)

method focus(control: ControlImpl) =
  discard SetFocus(control.fHandle)

method getTextLineWidth(control: ControlImpl, text: string): int = control.pGetTextSize(text).cx

method getTextLineHeight(control: ControlImpl): int = control.pGetTextSize("a").cy

proc pCommonControlWndProc_Scroll(origWndProc, hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer =
  const lineSize = 15
  case wParam.loWord
  of SB_THUMBPOSITION, SB_THUMBTRACK:
    let control = cast[ControlImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if control != nil:
      if uMsg == WM_HSCROLL:
        control.xScrollPos = wParam.hiWord
      else:
        control.yScrollPos = wParam.hiWord
  of SB_LINELEFT:
    let control = cast[ControlImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if uMsg == WM_HSCROLL:
      control.xScrollPos = control.xScrollPos - lineSize
    else:
      control.yScrollPos = control.yScrollPos - lineSize
  of SB_PAGELEFT:
    let control = cast[ControlImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if uMsg == WM_HSCROLL:
      control.xScrollPos = control.xScrollPos - control.width
    else:
      control.yScrollPos = control.yScrollPos - control.height
  of SB_LINERIGHT:
    let control = cast[ControlImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if uMsg == WM_HSCROLL:
      control.xScrollPos = control.xScrollPos + lineSize
    else:
      control.yScrollPos = control.yScrollPos + lineSize
  of SB_PAGERIGHT:
    let control = cast[ControlImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if uMsg == WM_HSCROLL:
      control.xScrollPos = control.xScrollPos + control.width
    else:
      control.yScrollPos = control.yScrollPos + control.height
  else:
    discard

proc pCommonControlWndProc(origWndProc, hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer =
  case uMsg

  # Note: A WM_KEYDOWN is sent for every key, for some (mostly visual) keys WM_CHAR is sent in addition.
  # To discard a character in text input, WM_CHAR must return without calling the default window proc.
  # Because we should not to trigger two events for one key press, WM_KEYDOWN must ignore all keys,
  # which are handled by WM_CHAR.

  of WM_KEYDOWN:
    let control = cast[Control](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if control != nil and pHandleWMKEYDOWN(control.parentWindow, control, wParam, lParam):
      return nil

  of WM_CHAR:
    let control = cast[Control](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if control != nil and pHandleWMCHAR(control.parentWindow, control, wParam, lParam):
      return nil

  # of WM_KEYUP:
    # return nil # key is still inserted in text area

  of WM_LBUTTONDOWN, WM_RBUTTONDOWN, WM_MBUTTONDOWN:
    let control = cast[Control](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if control != nil:
      discard SetFocus(control.parentWindow.fHandle)
      # TODO: request if is focusable
      var button: MouseButton
      var x = loWord(lParam)
      var y = hiWord(lParam)
      case uMsg
      of WM_LBUTTONDOWN: button = MouseButton_Left
      of WM_RBUTTONDOWN: button = MouseButton_Right
      of WM_MBUTTONDOWN: button = MouseButton_Middle
      else: discard
      var event = new MouseButtonEvent
      event.control = control
      event.button = button
      event.x = x
      event.y = y
      control.handleMouseButtonDownEvent(event)
      pLastMouseButtonDownControl = control
      pLastMouseButtonDownControlX = x
      pLastMouseButtonDownControlY = y
  of WM_LBUTTONUP, WM_RBUTTONUP, WM_MBUTTONUP:
    let control = cast[Control](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if control != nil:
      var button: MouseButton
      var x = loWord(lParam)
      var y = hiWord(lParam)
      if x >= 0 and x < control.width and y >= 0 and y < control.height:
        # send event only, when mouse was over control
        case uMsg
        of WM_LBUTTONUP: button = MouseButton_Left
        of WM_RBUTTONUP: button = MouseButton_Right
        of WM_MBUTTONUP: button = MouseButton_Middle
        else: discard
        var event = new MouseButtonEvent
        event.control = control
        event.button = button
        event.x = x
        event.y = y
        control.handleMouseButtonUpEvent(event)
        if uMsg == WM_LBUTTONUP and control == pLastMouseButtonDownControl and abs(x - pLastMouseButtonDownControlX) <= clickMaxXYMove and abs(y - pLastMouseButtonDownControlY) <= clickMaxXYMove:
          var clickEvent = new ClickEvent
          clickEvent.control = control
          control.handleClickEvent(clickEvent)
  of WM_HSCROLL, WM_VSCROLL:
    result = pCommonControlWndProc_Scroll(origWndProc, hWnd, uMsg, wParam, lParam)
  else:
    discard
  result = CallWindowProcW(origWndProc, hWnd, uMsg, wParam, lParam)

proc pCustomControlWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer =
  case uMsg
  of WM_PAINT:
    let control = cast[ControlImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if control != nil:
      var ps: PaintStruct
      var dc = BeginPaint(hWnd, ps)
      if dc == nil: pRaiseLastOSError()
      var event = new DrawEvent
      event.control = control
      var canvas = cast[CanvasImpl](control.canvas)
      if canvas == nil:
        canvas = newCanvas(control)
      else:
        if canvas.fFont != nil:
          discard SelectObject(dc, canvas.fFont)
      canvas.fDC = dc
      pCheckGdiplusStatus(GdipCreateFromHDC(dc, canvas.fGraphics))
      discard SetBkMode(dc, TRANSPARENT)
      control.handleDrawEvent(event)
      discard EndPaint(hWnd, ps)
      canvas.fDC = nil
      canvas.fGraphics = nil
  of WM_MOUSEWHEEL:
    let scrolled = wParam.hiWord div 120
    echo "wheel: " & $scrolled
  # of WM_ERASEBKGND: # no effect
    # return false
  of WM_SETFOCUS:
    # echo "control WM_SETFOCUS"
    discard
  else:
    discard
  result = pCommonControlWndProc(pCommonWndProc, hWnd, uMsg, wParam, lParam)


# ----------------------------------------------------------------------------------------
#                                      Container
# ----------------------------------------------------------------------------------------

proc pContainerWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer =
  case uMsg
  of WM_ERASEBKGND:
    let control = cast[ControlImpl](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    if control != nil:
      var brush = CreateSolidBrush(control.backgroundColor.pColorToRGB32)
      var rect = pGetClientRect(control.fHandle)
      discard FillRect(wParam, rect, brush)
      return
  else:
    discard
  result = pCustomControlWndProc(hWnd, uMsg, wParam, lParam)

proc init(container: ContainerImpl) =
  var dwStyle: int32 = WS_CHILD
  container.fHandle = pCreateWindowExWithUserdata(pContainerWindowClass, dwStyle, 0, pDefaultParentWindow, cast[pointer](container))
  # ScrollWnd:
  container.fScrollWndHandle = pCreateWindowExWithUserdata(pContainerWindowClass, dwStyle, 0, container.fHandle, cast[pointer](container))
  pShowWindow(container.fScrollWndHandle, SW_SHOW)
  # Inner:
  container.fInnerHandle = pCreateWindowExWithUserdata(pContainerWindowClass, dwStyle, 0, container.fScrollWndHandle, cast[pointer](container))
  pShowWindow(container.fInnerHandle, SW_SHOW)
  container.Container.init()

proc pUpdateScrollWnd(container: ContainerImpl) =
  let padding = container.getPadding()
  let width = container.width - padding.left - padding.right
  let height = container.height - padding.top - padding.bottom
  pSetWindowPos(container.fScrollWndHandle, padding.left, padding.top, width, height)

method `frame=`(container: ContainerImpl, frame: Frame) =
  procCall container.Container.`frame=`(frame)
  if frame != nil:
    pSetParent(frame.fHandle, container.fHandle)
  container.pUpdateScrollWnd()

method add(container: ContainerImpl, control: ControlImpl) =
  procCall container.Container.add(control)
  pSetParent(control.fHandle, container.fInnerHandle)

method remove(container: ContainerImpl, control: ControlImpl) =
  procCall container.Container.remove(control)
  pSetParent(control.fHandle, pDefaultParentWindow)

method setInnerSize(container: ContainerImpl, width, height: int) =
  procCall container.Container.setInnerSize(width, height)
  pSetWindowPos(container.fInnerHandle, -1, -1, width, height, SWP_NOMOVE)

method setSize(container: ContainerImpl, width, height: int) =
  procCall container.Container.setSize(width, height)
  container.pUpdateScrollWnd()

proc pSetInnerPos(container: ContainerImpl) =
  pSetWindowPos(container.fInnerHandle, -container.xScrollPos, -container.yScrollPos, -1, -1, SWP_NOSIZE)

method `xScrollPos=`(container: ContainerImpl, xScrollPos: int) =
  procCall container.ControlImpl.`xScrollPos=`(xScrollPos)
  container.pSetInnerPos()

method `yScrollPos=`(container: ContainerImpl, yScrollPos: int) =
  procCall container.ControlImpl.`yScrollPos=`(yScrollPos)
  container.pSetInnerPos()


# ----------------------------------------------------------------------------------------
#                                        Frame
# ----------------------------------------------------------------------------------------

proc init(frame: NativeFrame) =
  const dwStyle = WS_CHILD or BS_GROUPBOX or WS_GROUP
  frame.fHandle = pCreateWindowExWithUserdata("BUTTON", dwStyle, 0, pDefaultParentWindow, cast[pointer](frame))
  frame.Frame.init()

method `text=`(frame: NativeFrame, text: string) =
  procCall frame.Frame.`text=`(text)
  pSetWindowText(frame.fHandle, text)

method naturalWidth(frame: NativeFrame): int = frame.getTextLineWidth(frame.text) + 10

method getPadding(frame: NativeFrame): Spacing =
  result = procCall frame.Frame.getPadding()
  result.top = frame.getTextLineHeight() * frame.text.countLines + 2


# ----------------------------------------------------------------------------------------
#                                        Button
# ----------------------------------------------------------------------------------------

var pButtonOrigWndProc: pointer

proc pButtonWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.cdecl.} =
  case uMsg
  of WM_KEYDOWN:
    let button = cast[Button](pGetWindowLongPtr(hWnd, GWLP_USERDATA))
    # if button != nil and (cast[int](wParam) == 13 or cast[int](wParam) == 32):
    if button != nil and cast[int](wParam) == 13:
      var event = new ClickEvent
      event.control = button
      button.handleClickEvent(event)
  else:
    discard
  result = pCommonControlWndProc(pButtonOrigWndProc, hWnd, uMsg, wParam, lParam)

proc init(button: NativeButton) =
  button.fHandle = pCreateWindowExWithUserdata("BUTTON", WS_CHILD or WS_TABSTOP, 0, pDefaultParentWindow, cast[pointer](button))
  # WS_TABSTOP does not work, why?
  pButtonOrigWndProc = pSetWindowLongPtr(button.fHandle, GWLP_WNDPROC, pButtonWndProc)
  button.Button.init()

method `text=`(button: NativeButton, text: string) =
  procCall button.Button.`text=`(text)
  pSetWindowText(button.fHandle, text)

method `enabled=`(button: NativeButton, enabled: bool) =
  button.fEnabled = enabled
  discard EnableWindow(button.fHandle, enabled)


# ----------------------------------------------------------------------------------------
#                                        Label
# ----------------------------------------------------------------------------------------

proc init(label: NativeLabel) =
  label.fHandle = pCreateWindowExWithUserdata("STATIC", WS_CHILD or SS_CENTERIMAGE, 0, pDefaultParentWindow, cast[pointer](label))
  label.Label.init()

method `text=`(label: NativeLabel, text: string) =
  procCall label.Label.`text=`(text)
  pSetWindowText(label.fHandle, text)


# ----------------------------------------------------------------------------------------
#                                       TextBox
# ----------------------------------------------------------------------------------------

var pTextBoxOrigWndProc: pointer

proc pTextBoxWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.cdecl.} =
  result = pCommonControlWndProc(pTextBoxOrigWndProc, hWnd, uMsg, wParam, lParam)

proc init(textBox: NativeTextBox) =
  textBox.fHandle = pCreateWindowExWithUserdata("EDIT", WS_CHILD, WS_EX_CLIENTEDGE, pDefaultParentWindow, cast[pointer](textBox))
  pTextBoxOrigWndProc = pSetWindowLongPtr(textBox.fHandle, GWLP_WNDPROC, pTextBoxWndProc)
  textBox.TextBox.init()

method text(textBox: NativeTextBox): string = pGetWindowText(textBox.fHandle)

method `text=`(textBox: NativeTextBox, text: string) = pSetWindowText(textBox.fHandle, text)

method naturalHeight(textBox: NativeTextBox): int = textBox.getTextLineHeight() + 9 # add padding

method `editable=`(textBox: NativeTextBox, editable: bool) =
  textBox.fEditable = editable
  discard SendMessageA(textBox.fHandle, EM_SETREADONLY, cast[pointer](not editable), nil)

method cursorPos(textBox: NativeTextBox): int =
  var startPos: int32
  discard SendMessageA(textBox.fHandle, EM_GETSEL, startPos.addr, nil)
  result = startPos
  # Not really the cursor position, but the start of selection

method `cursorPos=`(textBox: NativeTextBox, cursorPos: int) =
  discard SendMessageA(textBox.fHandle, EM_SETSEL, cast[pointer](cursorPos), cast[pointer](cursorPos))
  # Side effect: clears selection

method selectionStart(textBox: NativeTextBox): int =
  var startPos: int32
  discard SendMessageA(textBox.fHandle, EM_GETSEL, startPos.addr, nil)
  result = startPos

method selectionEnd(textBox: NativeTextBox): int =
  var endPos: int32
  discard SendMessageA(textBox.fHandle, EM_GETSEL, nil, endPos.addr)
  result = endPos

method `selectionStart=`(textBox: NativeTextBox, selectionStart: int) =
  discard SendMessageA(textBox.fHandle, EM_SETSEL, cast[pointer](selectionStart), cast[pointer](textBox.selectionEnd))

method `selectionEnd=`(textBox: NativeTextBox, selectionEnd: int) =
  discard SendMessageA(textBox.fHandle, EM_SETSEL, cast[pointer](textBox.selectionStart), cast[pointer](selectionEnd))


# ----------------------------------------------------------------------------------------
#                                       TextArea
# ----------------------------------------------------------------------------------------

var pTextAreaOrigWndProc: pointer

proc pTextAreaWndProc(hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.cdecl.} =
  # Handle Ctrl+A:
  # TODO: Move this to handleKeyDownEvent(), so it's overridable by the control
  if uMsg == WM_KEYDOWN and cast[char](wParam) == 'A' and GetKeyState(VK_CONTROL) <= -127:
    discard SendMessageA(hwnd, EM_SETSEL, nil, cast[pointer](-1))
    return nil
  result = pCommonControlWndProc(pTextAreaOrigWndProc, hWnd, uMsg, wParam, lParam)

proc init(textArea: NativeTextArea) =
  var dwStyle: int32 = WS_CHILD or ES_MULTILINE or WS_VSCROLL # with wrap
  # var dwStyle: int32 = WS_CHILD or ES_MULTILINE or WS_VSCROLL or WS_HSCROLL # no wrap
  var dwExStyle: int32 = WS_EX_CLIENTEDGE
  textArea.fHandle = pCreateWindowExWithUserdata("EDIT", dwStyle, dwExStyle, pDefaultParentWindow, cast[pointer](textArea))
  pTextAreaOrigWndProc = pSetWindowLongPtr(textArea.fHandle, GWLP_WNDPROC, pTextAreaWndProc)
  textArea.TextArea.init()

# method text(textArea: NativeTextArea): string = pGetWindowText(textArea.fHandle)
# not needed any more

# method `text=`(textArea: NativeTextArea, text: string) = pSetWindowText(textArea.fHandle, text)
# not needed any more

method scrollToBottom(textArea: NativeTextArea) =
  # select all
  discard SendMessageA(textArea.fHandle, EM_SETSEL, nil, cast[pointer](-1))
  # unselect and stay at the end pos
  discard SendMessageA(textArea.fHandle, EM_SETSEL, cast[pointer](-1), cast[pointer](-1))
  # set scrollcaret to the current pos
  discard SendMessageA(textArea.fHandle, EM_SCROLLCARET, nil, nil)

method `wrap=`(textArea: NativeTextArea, wrap: bool) =
  procCall textArea.TextArea.`wrap=`(wrap)
  # TODO: allow to enable/disable word draw at runtime
  # It seems that this is not possible.
  # Word wrap depends on whether dwStyle contains WS_HSCROLL at window creation.
  # Changing the style later has not the wanted effect.
