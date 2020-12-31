# NiGui - minimal Win32 binding

# Some functions requires Windows XP or newer.
# Windows type names are replaced with basic types.

# Type aliases for int16:
#   ATOM, SHORT, USHORT, LANGID

# Type aliases for int32:
#   int, UINT, WINUINT, DWORD, LONG, COLORREF

# Type aliases for int:
#   WPARAM, LPARAM, ULONG

# Type aliases for pointer:
#   WNDPROC, HINSTANCE, HICON, HCURSOR, HBRUSH, HWND, LPMSG, LRESULT, PACTCTX, HMODULE, HDC, HGDIOBJ, HFONT, HMONITOR, HGDIOBJ

# Type aliases for cstring:
#   LPCTSTR, LPCWSTR

{.pragma: libUser32, stdcall, dynlib: "User32.dll".}
{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}
{.pragma: libGdi32, stdcall, dynlib: "Gdi32.dll".}
{.pragma: libShell32, stdcall, dynlib: "Shell32.dll".}
{.pragma: libGdiplus, stdcall, dynlib: "Gdiplus.dll".}
{.pragma: libComdlg32, stdcall, dynlib: "Comdlg32.dll".}


# ----------------------------------------------------------------------------------------
#                                      Constants
# ----------------------------------------------------------------------------------------

const
  # ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID* = 4
  # ACTCTX_FLAG_RESOURCE_NAME_VALID* = 8
  # ACTCTX_FLAG_SET_PROCESS_DEFAULT* = 16
  BIF_RETURNONLYFSDIRS* = 0x00000001
  BIF_NEWDIALOGSTYLE* = 0x00000040
  BN_CLICKED* = 0
  BM_SETSTYLE* = 244
  BM_SETIMAGE* = 247
  BM_GETCHECK* = 240
  BM_SETCHECK* = 241
  BM_GETSTATE* = 242
  BS_DEFPUSHBUTTON* = 0x00000001
  BS_AUTOCHECKBOX* = 0x00000003
  BS_GROUPBOX* = 0x00000007
  BST_UNCHECKED* = 0
  BST_CHECKED* = 1
  CB_ERR* = -1
  CB_ADDSTRING* = 0x0143
  CB_DELETESTRING* = 0x0144
  CB_GETCOUNT* = 0x0146
  CB_GETCURSEL* = 0x0147
  CB_SELECTSTRING* = 0x014D
  CB_SETCURSEL* = 0x014E
  CBS_SIMPLE* = 1
  CBS_DROPDOWN* = 2
  CBS_DROPDOWNLIST* = 3
  CF_TEXT* = 1
  COLOR_BTNFACE* = 15
  COLOR_WINDOW* = 5
  COLOR_WINDOWTEXT* = 8
  CP_UTF8* = 65001
  CS_HREDRAW* = 2
  CS_VREDRAW* = 1
  DEFAULT_GUI_FONT* = 17
  EM_SCROLLCARET* = 183
  EM_GETSEL* = 176
  EM_SETSEL* = 177
  EM_REPLACESEL* = 194
  EM_SETREADONLY* = 207
  EN_CHANGE* = 768
  ES_MULTILINE* = 4
  ES_AUTOHSCROLL* = 0x80
  GCLP_HBRBACKGROUND* = -10
  GWL_EXSTYLE* = -20
  GWL_HINSTANCE* = -6
  GWL_HWNDPARENT* = -8
  GWL_STYLE* = -16
  GWLP_USERDATA* = -21
  GWLP_WNDPROC* = -4
  HWND_TOPMOST* = -1
  HWND_NOTOPMOST* = -2
  ICON_SMALL* = 0
  ICON_BIG* = 1
  IDC_ARROW* = 32512
  INVALID_HANDLE_VALUE* = cast[pointer](-1)
  InterpolationMode_Default* = 0
  InterpolationMode_Bilinear* = 3
  InterpolationMode_NearestNeighbor* = 5
  IMAGE_BITMAP* = 0
  IMAGE_ICON* = 1
  # LR_LOADFROMFILE* = 16
  OBJ_BRUSH* = 2
  PBM_SETPOS* = 1026
  PBM_SETRANGE32* = 1030
  PM_REMOVE* = 1
  SB_HORZ* = 0
  SB_THUMBPOSITION* = 4
  SB_THUMBTRACK* = 5
  SB_VERT* = 1
  SB_LINELEFT* = 0
  SB_LINERIGHT* = 1
  SB_PAGELEFT* = 2
  SB_PAGERIGHT* = 3
  SC_MINIMIZE* = 0xF020
  SC_RESTORE* = 0xF120
  SIF_ALL* = 23
  SM_CXVSCROLL* = 2
  SPI_GETWORKAREA* = 0x0030
  SPI_SETKEYBOARDCUES* = 0x100B
  # SS_CENTERIMAGE* = 0x00000200
  SW_HIDE* = 0
  # SW_MAXIMIZE = 3
  SW_SHOW* = 5
  SW_MINIMIZE* = 6
  SW_RESTORE* = 9
  SWP_NOMOVE* = 2
  SWP_NOSIZE* = 1
  VK_RETURN* = 13
  VK_SHIFT* = 16
  VK_CONTROL* = 17
  VK_MENU* = 18
  VK_PRIOR* = 33
  VK_NEXT* = 34
  VK_END* = 35
  VK_HOME* = 36
  VK_LEFT* = 37
  VK_UP* = 38
  VK_RIGHT* = 39
  VK_DOWN* = 40
  VK_SNAPSHOT* = 44
  VK_INSERT* = 45
  VK_DELETE* = 46
  VK_LSHIFT* = 160
  VK_RSHIFT* = 161
  VK_LCONTROL* = 162
  VK_RCONTROL* = 163
  VK_LMENU* = 164
  VK_RMENU* = 165
  VK_OEM_PLUS* = 187
  VK_OEM_COMMA* = 188
  VK_OEM_MINUS* = 189
  VK_OEM_PERIOD* = 190
  VK_OEM_2* = 191
  VK_OEM_4* = 219
  VK_OEM_5* = 220
  VK_OEM_102* = 226
  WM_USER* = 0x0400
  WM_APP* = 0x8000
  WM_ACTIVATE* = 0x0006
  WM_CHANGEUISTATE* = 0x0127
  WM_CHAR* = 258
  WM_CLOSE* = 16
  WM_COMMAND* = 273
  WM_DROPFILES* = 563
  WM_ERASEBKGND* = 20
  WM_HSCROLL* = 276
  WM_KEYDOWN* = 256
  WM_KEYUP* = 257
  WM_LBUTTONDOWN* = 0x0201
  WM_LBUTTONUP* = 0x0202
  WM_MBUTTONDOWN* = 0x0207
  WM_MBUTTONUP* = 0x0208
  # WM_NCLBUTTONDOWN* = 161
  # WM_NCLBUTTONUP* = 162
  WM_MOUSEWHEEL* = 0x020A
  WM_MOVE* = 3
  WM_NEXTDLGCTL* = 0x0028
  WM_PAINT* = 15
  WM_RBUTTONDOWN* = 0x0204
  WM_RBUTTONUP* = 0x0205
  WM_SETFOCUS* = 0x0007
  WM_KILLFOCUS* = 0x0008
  WM_SETFONT* = 48
  WM_SIZE* = 5
  WM_VSCROLL* = 277
  WM_SETICON* = 128
  WM_SYSKEYDOWN* = 260
  WM_SYSKEYUP* = 261
  WM_SYSCOMMAND* = 274
  WM_CTLCOLOREDIT* = 307
  WM_CTLCOLORSTATIC* = 312
  WM_CUT* = 0x0300
  WM_COPY* = 0x0301
  WM_PASTE* = 0x0302
  WS_CLIPCHILDREN* = 0x02000000
  WS_CAPTION* = 0x00C00000
  WS_CHILD* = 0x40000000
  WS_EX_CLIENTEDGE* = 0x00000200
  WS_GROUP* = 0x00020000
  WS_HSCROLL* = 0x00100000
  WS_OVERLAPPEDWINDOW* = 0x00CF0000
  WS_SYSMENU* = 0x00080000
  WS_TABSTOP* = 0x00010000
  WS_THICKFRAME* = 0x00040000
  WS_VSCROLL* = 0x00200000
  WS_EX_CONTROLPARENT* = 0x00010000
  WS_VISIBLE* = 0x10000000
  # DT_CALCRECT* = 1024
  # OBJ_FONT* = 6
  # SM_XVIRTUALSCREEN* = 76
  # WC_LISTVIEWW* = "SysListView32"
  # WC_TABCONTROLW* = "SysTabControl32"
  # WC_TREEVIEWW* = "SysTreeView32"
  # WM_CTLCOLORSTATIC* = 312
  # WS_EX_TOOLWINDOW* = 0x00000080
  OPAQUE* = 2
  TRANSPARENT* = 1
  PS_SOLID* = 0
  PS_DASH* = 1
  PS_DOT* = 2
  PS_DASHDOT* = 3
  PS_DASHDOTDOT* = 4
  PS_NULL* = 5
  PS_USERSTYLE* = 7
  PS_INSIDEFRAME* = 6
  OFN_ALLOWMULTISELECT* = 0x00000200
  OFN_EXPLORER* = 0x00080000
  OFN_FILEMUSTEXIST* = 0x00001000
  OFN_OVERWRITEPROMPT* = 0x00000002
  # UnitWorld* = 0
  # UnitDisplay* = 1
  UnitPixel* = 2
  # UnitPoint* = 3
  # UnitInch* = 4
  # UnitDocument* = 5
  # UnitMillimeter* = 6
  GMEM_MOVEABLE* = 2
  PixelFormat32bppARGB* = 2498570
  ImageLockModeWrite* = 2
  MAPVK_VSC_TO_VK_EX* = 3
  PROCESS_DPI_UNAWARE* = 0
  PROCESS_SYSTEM_DPI_AWARE* = 1
  PROCESS_PER_MONITOR_DPI_AWARE* = 2
  FontStyleRegular* = 0
  FontStyleBold* = 1
  TextRenderingHint_AntiAlias* = 4


# ----------------------------------------------------------------------------------------
#                                       Types
# ----------------------------------------------------------------------------------------

type
  WndClassEx* = object
    cbSize*: int32
    style*: int32
    lpfnWndProc*: pointer
    cbClsExtra*: int32
    cbWndExtra*: int32
    hInstance*: pointer
    hIcon*: pointer
    hCursor*: pointer
    hbrBackground*: pointer
    lpszMenuName*: cstring
    lpszClassName*: cstring
    hIconSm*: pointer

  Point* = object
    x*: int32
    y*: int32

  Size* = object
    cx*: int32
    cy*: int32

  Rect* = object
    left*:   int32
    top*:    int32
    right*:  int32
    bottom*: int32

  RectF* = object
    x*:      cfloat
    y*:      cfloat
    width*:  cfloat
    height*: cfloat

  RGB32* = object
    red*:   byte
    green*: byte
    blue*:  byte
    unused: byte

  ARGB* = object
    blue*:  byte
    green*: byte
    red*:   byte
    alpha*: byte

  Msg* = object
    hwnd*: pointer
    message*: int32
    wParam*: int
    lParam*: int
    time*: int32
    pt*: Point

  ActCtx* = object
    cbSize*: int32
    dwFlags*: int32
    lpSource*: cstring
    wProcessorArchitecture*: int16
    wLangId*: int16
    lpAssemblyDirectory*: cstring
    lpResourceName*: cstring
    lpApplicationName*: cstring
    hModule*: pointer

  ScrollInfo* = object
    cbSize*: int32
    fMask*: int32
    nMin*: int32
    nMax*: int32
    nPage*: int32
    nPos*: int32
    nTrackPos*: int32

  MonitorInfo * = object
    cbSize*: int32
    rcMonitor*: Rect
    rcWork*: Rect
    dwFlags*: int32

  PaintStruct* = array[68, byte]

  KeyState* = array[256, byte]

  GdiplusStartupInput* = object
    GdiplusVersion*: int32
    DebugEventCallback*: pointer
    SuppressBackgroundThread*: bool
    SuppressExternalCodecs*: bool

  OpenFileName* = object
    lStructSize*: int32
    hwndOwner*: pointer
    hInstance*: pointer
    lpstrFilter*: cstring
    lpstrCustomFilter*: cstring
    nMaxCustFilter*: int32
    nFilterIndex*: int32
    lpstrFile*: cstring
    nMaxFile*: int32
    lpstrFileTitle*: cstring
    nMaxFileTitle*: int32
    lpstrInitialDir*: cstring
    lpstrTitle*: cstring
    Flags*: int32
    nFileOffset*: int16
    nFileExtension*: int16
    lpstrDefExt*: cstring
    lCustData*: pointer
    lpfnHook*: pointer
    lpTemplateName*: cstring
    # pvReserved: pointer
    # dwReserved: int32
    # FlagsEx*: int32

  GUID* = object
    Data1*: int32
    Data2*: int32
    Data3*: int32
    Data4*: int32

  BitmapData* = object
    Width*: int32
    Height*: int32
    Stride*: int32
    PixelFormat*: int32
    Scan0*: ptr UncheckedArray[byte]
    Reserved: pointer

  BrowseInfo* = object
    hwndOwner*: pointer
    pidlRoot*: pointer
    pszDisplayName*: cstring
    lpszTitle*: cstring
    ulFlags*: uint
    lpfn*: pointer
    lParam*: pointer
    iImage*: int32



# ----------------------------------------------------------------------------------------
#                               Replacement for Windows Macros
# ----------------------------------------------------------------------------------------

import math

proc loWord*(param: pointer): int = cast[int](param) and 0x0000FFFF

proc hiWord*(param: pointer): int =
  result = (cast[int](param) shr 16) and 0xFFFF
  if result > 2^15:
    result = result - 2^16


# ----------------------------------------------------------------------------------------
#                                      Kernel32 Procs
# ----------------------------------------------------------------------------------------

proc LoadLibraryA*(lpFileName: cstring): pointer {.importc, libKernel32.}
# proc GetModuleHandleA*(lpModuleName: cstring): pointer {.importc, libKernel32.}
proc GetLastError*(): int {.importc, libKernel32.}
# proc CreateActCtxA*(pActCtx: var ActCtx): pointer {.importc, libKernel32.}
# proc GetSystemDirectoryA*(lpBuffer: pointer, uSize: int32): int32 {.importc, libKernel32.}
proc MultiByteToWideChar*(CodePage, dwFlags: int32, lpMultiByteStr: cstring, cbMultiByte: int32, lpWideCharStr: cstring, cchWideChar: int32): int32 {.importc, libKernel32.}
proc WideCharToMultiByte*(CodePage, dwFlags: int32, lpWideCharStr: cstring, cchWideChar: int32, lpMultiByteStr: cstring, cbMultiByte: int32, lpDefaultChar: cstring, lpUsedDefaultChar: pointer): int32 {.importc, libKernel32.}
proc GlobalLock*(hMem: pointer): pointer {.importc, libKernel32.}
proc GlobalUnlock*(hMem: pointer): bool {.importc, libKernel32.}
proc GlobalAlloc*(uFlags, dwBytes: int32): pointer {.importc, libKernel32.}


# ----------------------------------------------------------------------------------------
#                                      User32 Procs
# ----------------------------------------------------------------------------------------

proc MessageBoxW*(hWnd: pointer, lpText, lpCaption: cstring, uType: int) {.importc, libUser32.}
proc RegisterClassExW*(lpwcx: var WndClassEx): int16 {.importc, libUser32.}
proc CreateWindowExW*(dwExStyle: int32, lpClassName, lpWindowName: cstring, dwStyle: int32, x, y, nWidth, nHeight: int, hWndParent, hMenu, hInstance, lpParam: pointer): pointer {.importc, libUser32.}
proc DestroyWindow*(hWnd: pointer): bool {.importc, libUser32.}
proc ShowWindow*(hWnd: pointer, nCmdShow: int32): bool {.importc, libUser32.}
proc EnableWindow*(hWnd: pointer, bEnable: bool): bool {.importc, libUser32.}
proc DefWindowProcW*(hWnd: pointer, uMsg: int, wParam, lParam: pointer): pointer {.importc, libUser32.}
proc GetMessageW*(lpMsg, hWnd: pointer, wMsgFilterMin, wMsgFilterMax: int32): bool {.importc, libUser32.}
proc PeekMessageW*(lpMsg, hWnd: pointer, wMsgFilterMin, wMsgFilterMax, wRemoveMsg: int32): bool {.importc, libUser32.}
proc TranslateMessage*(lpMsg: pointer): bool {.importc, libUser32.}
proc DispatchMessageW*(lpMsg: pointer): pointer {.importc, libUser32.}
proc SetParent*(hWndChild, hWndNewParent: pointer): pointer {.importc, libUser32.}
proc SetWindowLongA*(hWnd: pointer, nIndex, dwNewLong: int32): int32 {.importc, libUser32.}
proc GetWindowLongA*(hWnd: pointer, nIndex: int32): int32 {.importc, libUser32.}
proc SetWindowTextW*(hWnd: pointer, lpString: cstring): bool {.importc, libUser32.}
proc GetWindowTextW*(hWnd: pointer, lpString: cstring, nMaxCount: int32): int32 {.importc, libUser32.}
proc GetWindowTextLengthW*(hWnd: pointer): int32 {.importc, libUser32.}
proc UpdateWindow*(hWnd: pointer): bool {.importc, libUser32.}
proc SetWindowPos*(wnd, hWndInsertAfter: pointer, x, y, cx, cy: int32, uFlags: int): bool {.importc, libUser32.}
proc MoveWindow*(wnd: pointer, x, y, nWidth, nHeight: int32, bRepaint: bool): bool {.importc, libUser32.}
proc SetFocus*(hWnd: pointer): pointer {.importc, libUser32.}
proc GetWindowRect*(wnd: pointer, lpRect: var Rect): bool {.importc, libUser32.}
proc GetClientRect*(wnd: pointer, lpRect: var Rect): bool {.importc, libUser32.}
proc BeginPaint*(hWnd: pointer, lpPaint: var PaintStruct): pointer {.importc, libUser32.}
proc EndPaint*(hWnd: pointer, lpPaint: var PaintStruct): bool {.importc, libUser32.}
proc SendMessageA*(hWnd: pointer, msg: int32, wParam, lParam: pointer): pointer {.importc, libUser32.}
proc SendMessageW*(hWnd: pointer, msg: int32, wParam, lParam: pointer): pointer {.importc, libUser32.}
proc PostMessageA*(hWnd: pointer, msg: int32, wParam, lParam: pointer): bool {.importc, libUser32.}
proc GetSysColor*(nIndex: int32): RGB32 {.importc, libUser32.}
proc InvalidateRect*(hWnd: pointer, lpRect: ref Rect, bErase: bool): bool {.importc, libUser32.}
proc PostQuitMessage*(nExitCode: int32) {.importc, libUser32.}
proc GetDesktopWindow*(): pointer {.importc, libUser32.}
# proc SystemParametersInfoW*(uiAction, uiParam: int32, pvParam: pointer, fWinIni: int32): bool {.importc, libUser32.}
proc ClientToScreen*(hWnd: pointer, lpPoint: var Point): bool {.importc, libUser32.}
proc AdjustWindowRect*(lpRect: var Rect, dwStyle: int32, bMenu: bool): bool {.importc, libUser32.}
proc LoadCursorA*(hInstance: pointer, lpCursorName: cstring): pointer {.importc, libUser32.}
proc SetScrollInfo*(hWnd: pointer, fnBar: int32, lpsi: var ScrollInfo, fRedraw: bool): int32 {.importc, libUser32.}
proc GetMonitorInfoA*(hMonitor: pointer, lpmi: var MonitorInfo): bool {.importc, libUser32.}
proc MonitorFromRect*(lprc: var Rect, dwFlags: int32): pointer {.importc, libUser32.}
proc GetSystemMetrics*(nIndex: int32): int32 {.importc, libUser32.}
proc CallWindowProcW*(lpPrevWndFunc, hWnd: pointer, uMsg: int32, wParam, lParam: pointer): pointer {.importc, libUser32.}
proc IsDialogMessageW*(hDlg, lpMsg: pointer): bool {.importc, libUser32.}
proc GetNextDlgTabItem*(hDlg, hCtl: pointer, bPrevious: bool): pointer {.importc, libUser32.}
proc GetParent*(hWnd: pointer): pointer {.importc, libUser32.}
proc GetDC*(hWnd: pointer): pointer {.importc, libUser32.}
# proc DrawTextW*(hdc: pointer, lpchText: cstring, nCount: int32, lpRect: var Rect, uFormat: int32): int32 {.importc, libUser32.}
proc GetKeyboardState*(lpKeyState: var KeyState): bool {.importc, libUser32.}
proc ToUnicode*(wVirtKey, wScanCode: int32, lpKeyState: var KeyState, pwszBuff: cstring, cchBuff, wFlags: int32): int32 {.importc, libUser32.}
proc ShowScrollBar*(hWnd: pointer, wBar: int32, bShow: bool): bool {.importc, libUser32.}
proc LoadImageW*(hinst: pointer, lpszName: cstring, uType, cxDesired, cyDesired, fuLoad: int32): int32 {.importc, libUser32.}
proc SetTimer*(hWnd, nIDEvent: pointer, uElapse: int32, lpTimerFunc: pointer): pointer {.importc, libUser32.}
proc KillTimer*(hWnd, nIDEvent: pointer): bool {.importc, libUser32.}
proc FillRect*(hDC: pointer, lprc: var Rect, hbr: pointer): int32 {.importc, libUser32.}
proc FrameRect*(hDC: pointer, lprc: var Rect, hbr: pointer): int32 {.importc, libUser32.}
proc GetKeyState*(nVirtKey: int32): int16 {.importc, libUser32.}
proc OpenClipboard*(hWndNewOwner: pointer): bool {.importc, libUser32.}
proc CloseClipboard*(): bool {.importc, libUser32.}
proc GetClipboardData*(uFormat: int32): pointer {.importc, libUser32.}
proc SetClipboardData*(uFormat: int32, hMem: pointer): pointer {.importc, libUser32.}
proc EmptyClipboard*(): bool {.importc, libUser32.}
proc MapVirtualKeyW*(uCode, uMapType: int32): int32 {.importc, libUser32.}
proc GetCursorPos*(lpPoint: var Point): bool {.importc, libUser32.}
proc ScreenToClient*(hWnd: pointer, lpPoint: var Point): bool {.importc, libUser32.}
proc MonitorFromPoint*(pt: Point, dwFlags: int32): pointer {.importc, libUser32.}
proc GetScrollPos*(hWnd: pointer, nBar: int32): int32 {.importc, libUser32.}
proc LockWindowUpdate*(hWndLock: pointer): bool {.importc, libUser32.}

type GetDpiForWindowType* = proc(hWnd: pointer): int32 {.gcsafe, stdcall.} # not available on Windows 7

when defined(cpu64):
  # Only available on 64-bit Windows:
  proc GetWindowLongPtrW*(hWnd: pointer, nIndex: int32): pointer {.importc, libUser32.}
  proc SetWindowLongPtrW*(hWnd: pointer, nIndex: int32, dwNewLong: pointer): pointer {.importc, libUser32.}
else:
  # Should only be used on 32-bit Windows:
  proc GetWindowLongW*(hWnd: pointer, nIndex: int32): pointer {.importc, libUser32.}
  proc SetWindowLongW*(hWnd: pointer, nIndex: int32, dwNewLong: pointer): pointer {.importc, libUser32.}


# ----------------------------------------------------------------------------------------
#                                       GDI Procs
# ----------------------------------------------------------------------------------------

proc DeleteDC*(hdc: pointer): bool {.importc, libGdi32.}
proc DeleteObject*(hObject: pointer): bool {.importc, libGdi32.}
proc GetCurrentObject*(hdc: pointer, uObjectType: int32): pointer {.importc, libGdi32.}
proc SelectObject*(hdc, hgdiobj: pointer): pointer {.importc, libGdi32.}
proc TextOutW*(hdc: pointer, nXStart, nYStart: int32, lpString: cstring, cchString: int32): bool {.importc, libGdi32.}
proc CreateSolidBrush*(crColor: RGB32): pointer {.importc, libGdi32.}
proc CreatePen*(fnPenStyle, nWidth: int32, crColor: RGB32): pointer {.importc, libGdi32.}
# proc GetStockObject*(fnObject: int32): pointer {.importc, libGdi32.}
proc CreateFontW*(nHeight, nWidth, nEscapement, nOrientation, fnWeight, fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily: int32, lpszFace: cstring): pointer {.importc, libGdi32.}
proc GetTextExtentPoint32W*(hdc: pointer, lpString: cstring, c: int32, lpSize: var Size): bool {.importc, libGdi32.}
proc SetBkMode*(hdc: pointer, iBkMode: int32): int32 {.importc, libGdi32.}
proc SetTextColor*(hdc: pointer, crColor: RGB32): RGB32 {.importc, libGdi32.}
proc SetBkColor*(hdc: pointer, crColor: RGB32): RGB32 {.importc, libGdi32.}
proc MoveToEx*(hdc: pointer, x, y: int32, lpPoint: pointer): bool {.importc, libGdi32.}
proc LineTo*(hdc: pointer, nXEnd, nYEnd: int): bool {.importc, libGdi32.}
proc CreateCompatibleDC*(hdc: pointer): pointer {.importc, libGdi32.}
proc SetPixel*(hdc: pointer, x, y: int32, crColor: RGB32): int32 {.importc, libGdi32.}
# proc BitBlt*(hdcDest: pointer, nXDest, nYDest, nWidth, nHeight: int32, hdcSrc: pointer, nXSrc, nYSrc, dwRop: int32): bool {.importc, libGdi32.}


# ----------------------------------------------------------------------------------------
#                                       GDI+ Procs
# ----------------------------------------------------------------------------------------

proc GdiplusStartup*(token: var pointer, input: var GdiplusStartupInput, output: pointer): int32 {.importc, libGdiplus.}
proc GdipCreateBitmapFromFile*(filename: cstring, bitmap: var pointer): int32 {.importc, libGdiplus.}
# proc GdipLoadImageFromFile*(filename: cstring, image: var pointer): int32 {.importc, libGdiplus.}
proc GdipCreateHICONFromBitmap*(bitmap: pointer, hicon: var pointer): int32 {.importc, libGdiplus.}
proc GdipCreateFromHDC*(hdc: pointer, graphics: var pointer): int32 {.importc, libGdiplus.}
proc GdipDeleteGraphics*(graphics: pointer): int32 {.importc, libGdiplus.}
proc GdipDrawImageRectI*(graphics, image: pointer, x, y, width, height: int32): int32 {.importc, libGdiplus.}
proc GdipGetImageWidth*(image: pointer, width: var int32): int32 {.importc, libGdiplus.}
proc GdipGetImageHeight*(image: pointer, height: var int32): int32 {.importc, libGdiplus.}
# proc GdipGetImageDimension*(image: pointer, width, height: var float): int32 {.importc, libGdiplus.}
proc GdipCreateBitmapFromGraphics*(width, height: int32, target: pointer, bitmap: var pointer): int32 {.importc, libGdiplus.}
proc GdipBitmapSetPixel*(bitmap: pointer, x, y: int32, color: ARGB): int32 {.importc, libGdiplus.}
proc GdipSaveImageToFile*(image: pointer, filename: cstring, clsidEncoder, encoderParams: pointer): int32 {.importc, libGdiplus.}
# proc GdipGetImageEncodersSize*(numEncoders, size: var int32): int32 {.importc, libGdiplus.}
# proc GdipGetImageEncoders*(numEncoders, size: int32, encoders: pointer): int32 {.importc, libGdiplus.}
proc GdipGetImageGraphicsContext*(image: pointer, graphics: var pointer): int32 {.importc, libGdiplus.} # does not exist
proc GdipDisposeImage*(image: pointer): int32 {.importc, libGdiplus.}
proc GdipFillRectangleI*(graphics, brush: pointer, x, y, width, height: int32): int32 {.importc, libGdiplus.}
proc GdipDrawRectangleI*(graphics, pen: pointer, x, y, width, height: int32): int32 {.importc, libGdiplus.}
proc GdipDrawLineI*(graphics, pen: pointer, x1, y1, x2, y2: int32): int32 {.importc, libGdiplus.}
proc GdipDrawArc*(graphics, pen: pointer, x, y, width, height, startAngle, sweepAngle: cfloat): int32 {.importc, libGdiplus.}
proc GdipFillEllipseI*(graphics, brush: pointer, x, y, width, height: int32): int32 {.importc, libGdiplus.}
proc GdipDrawEllipseI*(graphics, pen: pointer, x, y, width, height: int32): int32 {.importc, libGdiplus.}
proc GdipCreateSolidFill*(color: ARGB, brush: var pointer): int32 {.importc, libGdiplus.}
proc GdipDeleteBrush*(brush: pointer): int32 {.importc, libGdiplus.}
proc GdipCreatePen1*(color: ARGB, width: cfloat, unit: int32, pen: var pointer): int32 {.importc, libGdiplus.}
proc GdipDeletePen*(pen: pointer): int32 {.importc, libGdiplus.}
proc GdipDrawString*(graphics: pointer, `string`: cstring, length: int32, font: pointer, layoutRect: var RectF, stringFormat, brush: pointer): int32 {.importc, libGdiplus.}
proc GdipMeasureString*(graphics: pointer, `string`: cstring, length: int32, font: pointer, layoutRect: var RectF, stringFormat: pointer, boundingBox: var RectF, codepointsFitted, linesFilled: pointer): int32 {.importc, libGdiplus.}
proc GdipCreateFont*(fontFamily: pointer, emSize: cfloat, style, unit: int32, font: var pointer): int32 {.importc, libGdiplus.}
proc GdipDeleteFont*(font: pointer): int32 {.importc, libGdiplus.}
proc GdipCreateFontFamilyFromName*(name: cstring, fontCollection: pointer, fontFamily: var pointer): int32 {.importc, libGdiplus.}
proc GdipDeleteFontFamily*(fontFamily: pointer): int32 {.importc, libGdiplus.}
proc GdipBitmapLockBits*(bitmap: pointer, rect: var Rect, flags: int32, format: int32, lockedBitmapData: var BitmapData): int32 {.importc, libGdiplus.}
proc GdipBitmapUnlockBits*(bitmap: pointer, lockedBitmapData: var BitmapData): int32 {.importc, libGdiplus.}
proc GdipSetTextRenderingHint*(graphics: pointer, mode: int32): int32 {.importc, libGdiplus.}
proc GdipSetInterpolationMode*(graphics: pointer, interpolationMode: int32): int32 {.importc, libGdiplus.}


# ----------------------------------------------------------------------------------------
#                                       Shell32 Procs
# ----------------------------------------------------------------------------------------

proc DragAcceptFiles*(hWnd: pointer, fAccept: bool) {.importc, libShell32.}
proc DragQueryFileW*(hDrop: pointer, iFile: uint32, lpszFile: cstring, cch: int32): int32 {.importc, libShell32.}
proc DragFinish*(hDrop: pointer) {.importc, libShell32.}
proc SHBrowseForFolderW*(lpbi: var BrowseInfo): pointer {.importc, libShell32.}
proc SHGetPathFromIDListW*(pidl: pointer, pszPath: cstring) {.importc, libShell32.}


# ----------------------------------------------------------------------------------------
#                                       Comdlg32 Procs
# ----------------------------------------------------------------------------------------

proc CommDlgExtendedError*(): int32 {.importc, libComdlg32.}
proc GetOpenFileNameW*(lpofn: var OpenFileName): bool {.importc, libComdlg32.}
proc GetSaveFileNameW*(lpofn: var OpenFileName): bool {.importc, libComdlg32.}


# ----------------------------------------------------------------------------------------
#                                       Shcore Procs
# ----------------------------------------------------------------------------------------

type SetProcessDpiAwarenessType* = proc(value: int32): int32 {.gcsafe, stdcall.} # not available on Windows 7
