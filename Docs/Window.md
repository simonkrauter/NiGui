-   [Types](#7)
    -   [Window](#Window "Window = ref object of RootObj
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
          fOnKeyDown: KeyboardProc")
    -   [WindowDisposeEvent](#WindowDisposeEvent "WindowDisposeEvent = ref object
          window*: Window")
    -   [WindowDisposeProc](#WindowDisposeProc "WindowDisposeProc = proc (event: WindowDisposeEvent)")
    -   [CloseClickEvent](#CloseClickEvent "CloseClickEvent = ref object
          window*: Window")
    -   [CloseClickProc](#CloseClickProc "CloseClickProc = proc (event: CloseClickEvent)")
    -   [ResizeEvent](#ResizeEvent "ResizeEvent = ref object
          window*: Window")
    -   [ResizeProc](#ResizeProc "ResizeProc = proc (event: ResizeEvent)")
    -   [DropFilesEvent](#DropFilesEvent "DropFilesEvent = ref object
          window*: Window
          files*: seq[string]")
    -   [DropFilesProc](#DropFilesProc "DropFilesProc = proc (event: DropFilesEvent)")
-   [Procs](#12)
    -   [newWindowWindow](#newWindow%2Cstring "newWindow(title: string = ""): Window")
    -   [disposeWindow](#dispose%2CWindow "dispose(window: var Window)")
    -   [disposedWindow](#disposed%2CWindow "disposed(window: Window): bool")
-   [Methods](#14)
    -   [disposeWindow](#dispose.e%2CWindow "dispose(window: Window)")
    -   [titleWindow](#title.e%2CWindow "title(window: Window): string")
    -   [title=Window](#title%3D.e%2CWindow%2Cstring "title=(window: Window; title: string)")
    -   [controlWindow](#control.e%2CWindow "control(window: Window): Control")
    -   [control=Window](#control%3D.e%2CWindow%2CControl "control=(window: Window; control: Control)")
    -   [addWindow](#add.e%2CWindow%2CControl "add(window: Window; control: Control)")
    -   [visibleWindow](#visible.e%2CWindow "visible(window: Window): bool")
    -   [visible=Window](#visible%3D.e%2CWindow%2Cbool "visible=(window: Window; visible: bool)")
    -   [showWindow](#show.e%2CWindow "show(window: Window)")
    -   [showModalWindow](#showModal.e%2CWindow%2CWindow "showModal(window: Window; parent: Window)")
    -   [hideWindow](#hide.e%2CWindow "hide(window: Window)")
    -   [minimizedWindow](#minimized.e%2CWindow "minimized(window: Window): bool")
    -   [minimized=Window](#minimized%3D.e%2CWindow%2Cbool "minimized=(window: Window; minimized: bool)")
    -   [minimizeWindow](#minimize.e%2CWindow "minimize(window: Window)")
    -   [alwaysOnTopWindow](#alwaysOnTop.e%2CWindow "alwaysOnTop(window: Window): bool")
    -   [alwaysOnTop=Window](#alwaysOnTop%3D.e%2CWindow%2Cbool "alwaysOnTop=(window: Window; alwaysOnTop: bool)")
    -   [xWindow](#x.e%2CWindow "x(window: Window): int")
    -   [x=Window](#x%3D.e%2CWindow%2Cint "x=(window: Window; x: int)")
    -   [yWindow](#y.e%2CWindow "y(window: Window): int")
    -   [y=Window](#y%3D.e%2CWindow%2Cint "y=(window: Window; y: int)")
    -   [centerOnScreenWindow](#centerOnScreen.e%2CWindow "centerOnScreen(window: Window)")
    -   [widthWindow](#width.e%2CWindow "width(window: Window): int")
    -   [heightWindow](#height.e%2CWindow "height(window: Window): int")
    -   [width=Window](#width%3D.e%2CWindow%2Cint "width=(window: Window; width: int)")
    -   [height=Window](#height%3D.e%2CWindow%2Cint "height=(window: Window; height: int)")
    -   [clientWidthWindow](#clientWidth.e%2CWindow "clientWidth(window: Window): int")
    -   [clientHeightWindow](#clientHeight.e%2CWindow "clientHeight(window: Window): int")
    -   [iconPathWindow](#iconPath.e%2CWindow "iconPath(window: Window): string")
    -   [iconPath=Window](#iconPath%3D.e%2CWindow%2Cstring "iconPath=(window: Window; iconPath: string)")
    -   [closeClickWindow](#closeClick.e%2CWindow "closeClick(window: Window)")
    -   [handleResizeEventWindow](#handleResizeEvent.e%2CWindow%2CResizeEvent "handleResizeEvent(window: Window; event: ResizeEvent)")
    -   [handleDropFilesEventWindow](#handleDropFilesEvent.e%2CWindow%2CDropFilesEvent "handleDropFilesEvent(window: Window; event: DropFilesEvent)")
    -   [handleKeyDownEventWindow](#handleKeyDownEvent.e%2CWindow%2CKeyboardEvent "handleKeyDownEvent(window: Window; event: KeyboardEvent)")
    -   [onDisposeWindow](#onDispose.e%2CWindow "onDispose(window: Window): WindowDisposeProc")
    -   [onDispose=Window](#onDispose%3D.e%2CWindow%2CWindowDisposeProc "onDispose=(window: Window; callback: WindowDisposeProc)")
    -   [onCloseClickWindow](#onCloseClick.e%2CWindow "onCloseClick(window: Window): CloseClickProc")
    -   [onCloseClick=Window](#onCloseClick%3D.e%2CWindow%2CCloseClickProc "onCloseClick=(window: Window; callback: CloseClickProc)")
    -   [onResizeWindow](#onResize.e%2CWindow "onResize(window: Window): ResizeProc")
    -   [onResize=Window](#onResize%3D.e%2CWindow%2CResizeProc "onResize=(window: Window; callback: ResizeProc)")
    -   [onDropFilesWindow](#onDropFiles.e%2CWindow "onDropFiles(window: Window): DropFilesProc")
    -   [onDropFiles=Window](#onDropFiles%3D.e%2CWindow%2CDropFilesProc "onDropFiles=(window: Window; callback: DropFilesProc)")
    -   [onKeyDownWindow](#onKeyDown.e%2CWindow "onKeyDown(window: Window): KeyboardProc")
    -   [onKeyDown=Window](#onKeyDown%3D.e%2CWindow%2CKeyboardProc "onKeyDown=(window: Window; callback: KeyboardProc)")

Constructor for a Window object. If the title is empty, it will be set
to the application filename.Initialize a WindowImpl object Only needed
for own constructors.

[Types](#7)
===========

    Window = ref object of RootObj
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

    WindowDisposeEvent = ref object
      window*: Window

    WindowDisposeProc = proc (event: WindowDisposeEvent)

    CloseClickEvent = ref object
      window*: Window

    CloseClickProc = proc (event: CloseClickEvent)

    ResizeEvent = ref object
      window*: Window

    ResizeProc = proc (event: ResizeEvent)

    DropFilesEvent = ref object
      window*: Window
      files*: seq[string]

    DropFilesProc = proc (event: DropFilesEvent)

[Procs](#12)
============

    proc newWindow(title: string = ""): Window {...}{.raises: [Exception], tags: [RootEffect].}

    proc dispose(window: var Window) {...}{.raises: [Exception], tags: [RootEffect].}

    proc disposed(window: Window): bool {...}{.raises: [], tags: [].}

[Methods](#14)
==============

    method dispose(window: Window) {...}{.base, raises: [Exception], tags: [RootEffect].}

    method title(window: Window): string {...}{.base, raises: [], tags: [].}

    method title=(window: Window; title: string) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method control(window: Window): Control {...}{.base, raises: [], tags: [].}

    method control=(window: Window; control: Control) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method add(window: Window; control: Control) {...}{.base, raises: [], tags: [].}

    method visible(window: Window): bool {...}{.base, raises: [], tags: [].}

    method visible=(window: Window; visible: bool) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method show(window: Window) {...}{.base, raises: [Exception], tags: [RootEffect].}

    method showModal(window: Window; parent: Window) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method hide(window: Window) {...}{.base, raises: [Exception], tags: [RootEffect].}

    method minimized(window: Window): bool {...}{.base, raises: [], tags: [].}

    method minimized=(window: Window; minimized: bool) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method minimize(window: Window) {...}{.base, raises: [], tags: [].}

    method alwaysOnTop(window: Window): bool {...}{.base, raises: [], tags: [].}

    method alwaysOnTop=(window: Window; alwaysOnTop: bool) {...}{.base, raises: [], tags: [].}

    method x(window: Window): int {...}{.base, raises: [], tags: [].}

    method x=(window: Window; x: int) {...}{.base, locks: "unknown", raises: [], tags: [].}

    method y(window: Window): int {...}{.base, raises: [], tags: [].}

    method y=(window: Window; y: int) {...}{.base, locks: "unknown", raises: [], tags: [].}

    method centerOnScreen(window: Window) {...}{.base, locks: "unknown", raises: [], tags: [].}

    method width(window: Window): int {...}{.base, raises: [], tags: [].}

    method height(window: Window): int {...}{.base, raises: [], tags: [].}

    method width=(window: Window; width: int) {...}{.base, locks: "unknown", raises: [], tags: [].}

    method height=(window: Window; height: int) {...}{.base, locks: "unknown", raises: [], tags: [].}

    method clientWidth(window: Window): int {...}{.base, raises: [], tags: [].}

    method clientHeight(window: Window): int {...}{.base, raises: [], tags: [].}

    method iconPath(window: Window): string {...}{.base, raises: [], tags: [].}

    method iconPath=(window: Window; iconPath: string) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method closeClick(window: Window) {...}{.base, raises: [Exception], tags: [RootEffect].}

    method handleResizeEvent(window: Window; event: ResizeEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method handleDropFilesEvent(window: Window; event: DropFilesEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method handleKeyDownEvent(window: Window; event: KeyboardEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method onDispose(window: Window): WindowDisposeProc {...}{.base, raises: [], tags: [].}

    method onDispose=(window: Window; callback: WindowDisposeProc) {...}{.base, raises: [],
        tags: [].}

    method onCloseClick(window: Window): CloseClickProc {...}{.base, raises: [], tags: [].}

    method onCloseClick=(window: Window; callback: CloseClickProc) {...}{.base, raises: [],
        tags: [].}

    method onResize(window: Window): ResizeProc {...}{.base, raises: [], tags: [].}

    method onResize=(window: Window; callback: ResizeProc) {...}{.base, raises: [], tags: [].}

    method onDropFiles(window: Window): DropFilesProc {...}{.base, raises: [], tags: [].}

    method onDropFiles=(window: Window; callback: DropFilesProc) {...}{.base, raises: [],
        tags: [].}

    method onKeyDown(window: Window): KeyboardProc {...}{.base, raises: [], tags: [].}

    method onKeyDown=(window: Window; callback: KeyboardProc) {...}{.base, raises: [], tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:33:10 UTC
