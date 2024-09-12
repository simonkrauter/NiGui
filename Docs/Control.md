-   [Types](#7)
    -   [Control](#Control "Control = ref object of RootObj
          fDisposed: bool
          fParentControl: Control
          fParentWindow: Window
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
          fOnKeyDown: KeyboardProc
          tag*: string")
    -   [ControlDisposeEvent](#ControlDisposeEvent "ControlDisposeEvent = ref object
          control*: Control")
    -   [ControlDisposeProc](#ControlDisposeProc "ControlDisposeProc = proc (event: ControlDisposeEvent)")
    -   [DrawEvent](#DrawEvent "DrawEvent = ref object
          control*: Control")
    -   [DrawProc](#DrawProc "DrawProc = proc (event: DrawEvent)")
    -   [ClickEvent](#ClickEvent "ClickEvent = ref object
          control*: Control")
    -   [ClickProc](#ClickProc "ClickProc = proc (event: ClickEvent)")
    -   [TextChangeEvent](#TextChangeEvent "TextChangeEvent = ref object
          control*: Control")
    -   [TextChangeProc](#TextChangeProc "TextChangeProc = proc (event: TextChangeEvent)")
    -   [ToggleEvent](#ToggleEvent "ToggleEvent = ref object
          control*: Control")
    -   [ToggleProc](#ToggleProc "ToggleProc = proc (event: ToggleEvent)")
-   [Procs](#12)
    -   [newControlControl](#newControl "newControl(): Control")
    -   [initControl](#init%2CControl "init(control: Control)")
    -   [disposeControl](#dispose%2CControl "dispose(control: var Control)")
    -   [disposedControl](#disposed%2CControl "disposed(control: Control): bool")
-   [Methods](#14)
    -   [disposeControl](#dispose.e%2CControl "dispose(control: Control)")
    -   [visibleControl](#visible.e%2CControl "visible(control: Control): bool")
    -   [visible=Control](#visible%3D.e%2CControl%2Cbool "visible=(control: Control; visible: bool)")
    -   [showControl](#show.e%2CControl "show(control: Control)")
    -   [hideControl](#hide.e%2CControl "hide(control: Control)")
    -   [widthControl](#width.e%2CControl "width(control: Control): int")
    -   [heightControl](#height.e%2CControl "height(control: Control): int")
    -   [width=Control](#width%3D.e%2CControl%2Cint "width=(control: Control; width: int)")
    -   [height=Control](#height%3D.e%2CControl%2Cint "height=(control: Control; height: int)")
    -   [minWidthControl](#minWidth.e%2CControl "minWidth(control: Control): int")
    -   [minWidth=Control](#minWidth%3D.e%2CControl%2Cint "minWidth=(control: Control; minWidth: int)")
    -   [minHeightControl](#minHeight.e%2CControl "minHeight(control: Control): int")
    -   [minHeight=Control](#minHeight%3D.e%2CControl%2Cint "minHeight=(control: Control; minHeight: int)")
    -   [maxWidthControl](#maxWidth.e%2CControl "maxWidth(control: Control): int")
    -   [maxWidth=Control](#maxWidth%3D.e%2CControl%2Cint "maxWidth=(control: Control; maxWidth: int)")
    -   [maxHeightControl](#maxHeight.e%2CControl "maxHeight(control: Control): int")
    -   [maxHeight=Control](#maxHeight%3D.e%2CControl%2Cint "maxHeight=(control: Control; maxHeight: int)")
    -   [setSizeControl](#setSize.e%2CControl%2Cint%2Cint "setSize(control: Control; width, height: int)")
    -   [x=Control](#x%3D.e%2CControl%2Cint "x=(control: Control; x: int)")
    -   [xControl](#x.e%2CControl "x(control: Control): int")
    -   [y=Control](#y%3D.e%2CControl%2Cint "y=(control: Control; y: int)")
    -   [yControl](#y.e%2CControl "y(control: Control): int")
    -   [setPositionControl](#setPosition.e%2CControl%2Cint%2Cint "setPosition(control: Control; x, y: int)")
    -   [naturalWidthControl](#naturalWidth.e%2CControl "naturalWidth(control: Control): int")
    -   [naturalHeightControl](#naturalHeight.e%2CControl "naturalHeight(control: Control): int")
    -   [wantedWidthControl](#wantedWidth.e%2CControl "wantedWidth(control: Control): int")
    -   [wantedHeightControl](#wantedHeight.e%2CControl "wantedHeight(control: Control): int")
    -   [widthMode=Control](#widthMode%3D.e%2CControl%2CWidthMode "widthMode=(control: Control; mode: WidthMode)")
    -   [heightMode=Control](#heightMode%3D.e%2CControl%2CHeightMode "heightMode=(control: Control; mode: HeightMode)")
    -   [widthModeControl](#widthMode.e%2CControl "widthMode(control: Control): WidthMode")
    -   [heightModeControl](#heightMode.e%2CControl "heightMode(control: Control): HeightMode")
    -   [childControlsControl](#childControls.e%2CControl "childControls(control: Control): seq[Control]")
    -   [parentControlControl](#parentControl.e%2CControl "parentControl(control: Control): Control")
    -   [parentWindowControl](#parentWindow.e%2CControl "parentWindow(control: Control): WindowImpl")
    -   [focusControl](#focus.e%2CControl "focus(control: Control)")
    -   [getTextLineWidthControl](#getTextLineWidth.e%2CControl%2Cstring "getTextLineWidth(control: Control; text: string): int")
    -   [getTextLineHeightControl](#getTextLineHeight.e%2CControl "getTextLineHeight(control: Control): int")
    -   [getTextWidthControl](#getTextWidth.e%2CControl%2Cstring "getTextWidth(control: Control; text: string): int")
    -   [visibleWidthControl](#visibleWidth.e%2CControl "visibleWidth(control: Control): int")
    -   [visibleHeightControl](#visibleHeight.e%2CControl "visibleHeight(control: Control): int")
    -   [xScrollPosControl](#xScrollPos.e%2CControl "xScrollPos(control: Control): int")
    -   [xScrollPos=Control](#xScrollPos%3D.e%2CControl%2Cint "xScrollPos=(control: Control; xScrollPos: int)")
    -   [yScrollPosControl](#yScrollPos.e%2CControl "yScrollPos(control: Control): int")
    -   [yScrollPos=Control](#yScrollPos%3D.e%2CControl%2Cint "yScrollPos=(control: Control; yScrollPos: int)")
    -   [scrollableWidthControl](#scrollableWidth.e%2CControl "scrollableWidth(control: Control): int")
    -   [scrollableWidth=Control](#scrollableWidth%3D.e%2CControl%2Cint "scrollableWidth=(control: Control; scrollableWidth: int)")
    -   [scrollableHeightControl](#scrollableHeight.e%2CControl "scrollableHeight(control: Control): int")
    -   [scrollableHeight=Control](#scrollableHeight%3D.e%2CControl%2Cint "scrollableHeight=(control: Control; scrollableHeight: int)")
    -   [fontFamilyControl](#fontFamily.e%2CControl "fontFamily(control: Control): string")
    -   [fontFamily=Control](#fontFamily%3D.e%2CControl%2Cstring "fontFamily=(control: Control; fontFamily: string)")
    -   [setFontFamilyControl](#setFontFamily.e%2CControl%2Cstring "setFontFamily(control: Control; fontFamily: string)")
    -   [fontSizeControl](#fontSize.e%2CControl "fontSize(control: Control): float")
    -   [fontSize=Control](#fontSize%3D.e%2CControl%2Cfloat "fontSize=(control: Control; fontSize: float)")
    -   [setFontSizeControl](#setFontSize.e%2CControl%2Cfloat "setFontSize(control: Control; fontSize: float)")
    -   [fontBoldControl](#fontBold.e%2CControl "fontBold(control: Control): bool")
    -   [fontBold=Control](#fontBold%3D.e%2CControl%2Cbool "fontBold=(control: Control; fontBold: bool)")
    -   [setFontBoldControl](#setFontBold.e%2CControl%2Cbool "setFontBold(control: Control; fontBold: bool)")
    -   [backgroundColorControl](#backgroundColor.e%2CControl "backgroundColor(control: Control): Color")
    -   [backgroundColor=Control](#backgroundColor%3D.e%2CControl%2CColor "backgroundColor=(control: Control; color: Color)")
    -   [setBackgroundColorControl](#setBackgroundColor.e%2CControl%2CColor "setBackgroundColor(control: Control; color: Color)")
    -   [initStyleControl](#initStyle.e%2CControl "initStyle(control: Control)")
    -   [textColorControl](#textColor.e%2CControl "textColor(control: Control): Color")
    -   [textColor=Control](#textColor%3D.e%2CControl%2CColor "textColor=(control: Control; color: Color)")
    -   [setTextColorControl](#setTextColor.e%2CControl%2CColor "setTextColor(control: Control; color: Color)")
    -   [forceRedrawControl](#forceRedraw.e%2CControl "forceRedraw(control: Control)")
    -   [canvasControl](#canvas.e%2CControl "canvas(control: Control): Canvas")
    -   [handleDrawEventControl](#handleDrawEvent.e%2CControl%2CDrawEvent "handleDrawEvent(control: Control; event: DrawEvent)")
    -   [handleMouseButtonDownEventControl](#handleMouseButtonDownEvent.e%2CControl%2CMouseEvent "handleMouseButtonDownEvent(control: Control; event: MouseEvent)")
    -   [handleMouseButtonUpEventControl](#handleMouseButtonUpEvent.e%2CControl%2CMouseEvent "handleMouseButtonUpEvent(control: Control; event: MouseEvent)")
    -   [handleClickEventControl](#handleClickEvent.e%2CControl%2CClickEvent "handleClickEvent(control: Control; event: ClickEvent)")
    -   [handleKeyDownEventControl](#handleKeyDownEvent.e%2CControl%2CKeyboardEvent "handleKeyDownEvent(control: Control; event: KeyboardEvent)")
    -   [onDisposeControl](#onDispose.e%2CControl "onDispose(control: Control): ControlDisposeProc")
    -   [onDispose=Control](#onDispose%3D.e%2CControl%2CControlDisposeProc "onDispose=(control: Control; callback: ControlDisposeProc)")
    -   [onDrawControl](#onDraw.e%2CControl "onDraw(control: Control): DrawProc")
    -   [onDraw=Control](#onDraw%3D.e%2CControl%2CDrawProc "onDraw=(control: Control; callback: DrawProc)")
    -   [onMouseButtonDownControl](#onMouseButtonDown.e%2CControl "onMouseButtonDown(control: Control): MouseButtonProc")
    -   [onMouseButtonDown=Control](#onMouseButtonDown%3D.e%2CControl%2CMouseButtonProc "onMouseButtonDown=(control: Control; callback: MouseButtonProc)")
    -   [onMouseButtonUpControl](#onMouseButtonUp.e%2CControl "onMouseButtonUp(control: Control): MouseButtonProc")
    -   [onMouseButtonUp=Control](#onMouseButtonUp%3D.e%2CControl%2CMouseButtonProc "onMouseButtonUp=(control: Control; callback: MouseButtonProc)")
    -   [onClickControl](#onClick.e%2CControl "onClick(control: Control): ClickProc")
    -   [onClick=Control](#onClick%3D.e%2CControl%2CClickProc "onClick=(control: Control; callback: ClickProc)")
    -   [onKeyDownControl](#onKeyDown.e%2CControl "onKeyDown(control: Control): KeyboardProc")
    -   [onKeyDown=Control](#onKeyDown%3D.e%2CControl%2CKeyboardProc "onKeyDown=(control: Control; callback: KeyboardProc)")

[Types](#7)
===========

    Control = ref object of RootObj
      fDisposed: bool
      fParentControl: Control
      fParentWindow: Window
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
      fOnKeyDown: KeyboardProc
      tag*: string

    ControlDisposeEvent = ref object
      control*: Control

    ControlDisposeProc = proc (event: ControlDisposeEvent)

    DrawEvent = ref object
      control*: Control

    DrawProc = proc (event: DrawEvent)

    ClickEvent = ref object
      control*: Control

    ClickProc = proc (event: ClickEvent)

    TextChangeEvent = ref object
      control*: Control

    TextChangeProc = proc (event: TextChangeEvent)

    ToggleEvent = ref object
      control*: Control

    ToggleProc = proc (event: ToggleEvent)

[Procs](#12)
============

    proc newControl(): Control {...}{.raises: [Exception], tags: [RootEffect].}

    proc init(control: Control) {...}{.raises: [Exception], tags: [RootEffect].}

    proc dispose(control: var Control) {...}{.raises: [Exception], tags: [RootEffect].}

    proc disposed(control: Control): bool {...}{.raises: [], tags: [].}

[Methods](#14)
==============

    method dispose(control: Control) {...}{.base, raises: [Exception], tags: [RootEffect].}

    method visible(control: Control): bool {...}{.base, raises: [], tags: [].}

    method visible=(control: Control; visible: bool) {...}{.base, raises: [], tags: [].}

    method show(control: Control) {...}{.base, raises: [], tags: [].}

    method hide(control: Control) {...}{.base, raises: [], tags: [].}

    method width(control: Control): int {...}{.base, raises: [], tags: [].}

    method height(control: Control): int {...}{.base, raises: [], tags: [].}

    method width=(control: Control; width: int) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method height=(control: Control; height: int) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method minWidth(control: Control): int {...}{.base, locks: "unknown", raises: [], tags: [].}

    method minWidth=(control: Control; minWidth: int) {...}{.base, raises: [], tags: [].}

    method minHeight(control: Control): int {...}{.base, locks: "unknown", raises: [], tags: [].}

    method minHeight=(control: Control; minHeight: int) {...}{.base, raises: [], tags: [].}

    method maxWidth(control: Control): int {...}{.base, raises: [], tags: [].}

    method maxWidth=(control: Control; maxWidth: int) {...}{.base, raises: [], tags: [].}

    method maxHeight(control: Control): int {...}{.base, raises: [], tags: [].}

    method maxHeight=(control: Control; maxHeight: int) {...}{.base, raises: [], tags: [].}

    method setSize(control: Control; width, height: int) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method x=(control: Control; x: int) {...}{.base, raises: [], tags: [].}

    method x(control: Control): int {...}{.base, raises: [], tags: [].}

    method y=(control: Control; y: int) {...}{.base, raises: [], tags: [].}

    method y(control: Control): int {...}{.base, raises: [], tags: [].}

    method setPosition(control: Control; x, y: int) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method naturalWidth(control: Control): int {...}{.base, locks: "unknown", raises: [], tags: [].}

    method naturalHeight(control: Control): int {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method wantedWidth(control: Control): int {...}{.base, raises: [Exception],
                                            tags: [RootEffect].}

    method wantedHeight(control: Control): int {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method widthMode=(control: Control; mode: WidthMode) {...}{.base, raises: [], tags: [].}

    method heightMode=(control: Control; mode: HeightMode) {...}{.base, raises: [], tags: [].}

    method widthMode(control: Control): WidthMode {...}{.base, raises: [], tags: [].}

    method heightMode(control: Control): HeightMode {...}{.base, raises: [], tags: [].}

    method childControls(control: Control): seq[Control] {...}{.base, raises: [], tags: [].}

    method parentControl(control: Control): Control {...}{.base, raises: [], tags: [].}

    method parentWindow(control: Control): WindowImpl {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method focus(control: Control) {...}{.base, raises: [], tags: [].}

    method getTextLineWidth(control: Control; text: string): int {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method getTextLineHeight(control: Control): int {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method getTextWidth(control: Control; text: string): int {...}{.base, raises: [], tags: [].}

    method visibleWidth(control: Control): int {...}{.base, raises: [], tags: [].}

    method visibleHeight(control: Control): int {...}{.base, raises: [], tags: [].}

    method xScrollPos(control: Control): int {...}{.base, raises: [], tags: [].}

    method xScrollPos=(control: Control; xScrollPos: int) {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method yScrollPos(control: Control): int {...}{.base, raises: [], tags: [].}

    method yScrollPos=(control: Control; yScrollPos: int) {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method scrollableWidth(control: Control): int {...}{.base, raises: [], tags: [].}

    method scrollableWidth=(control: Control; scrollableWidth: int) {...}{.base, raises: [],
        tags: [].}

    method scrollableHeight(control: Control): int {...}{.base, raises: [], tags: [].}

    method scrollableHeight=(control: Control; scrollableHeight: int) {...}{.base, raises: [],
        tags: [].}

    method fontFamily(control: Control): string {...}{.base, raises: [], tags: [].}

    method fontFamily=(control: Control; fontFamily: string) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method setFontFamily(control: Control; fontFamily: string) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method fontSize(control: Control): float {...}{.base, raises: [], tags: [].}

    method fontSize=(control: Control; fontSize: float) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method setFontSize(control: Control; fontSize: float) {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method fontBold(control: Control): bool {...}{.base, raises: [], tags: [].}

    method fontBold=(control: Control; fontBold: bool) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method setFontBold(control: Control; fontBold: bool) {...}{.base, locks: "unknown",
        raises: [], tags: [].}

    method backgroundColor(control: Control): Color {...}{.base, raises: [], tags: [].}

    method backgroundColor=(control: Control; color: Color) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method setBackgroundColor(control: Control; color: Color) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method initStyle(control: Control) {...}{.base, raises: [Exception], tags: [RootEffect].}

    method textColor(control: Control): Color {...}{.base, raises: [], tags: [].}

    method textColor=(control: Control; color: Color) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method setTextColor(control: Control; color: Color) {...}{.base, raises: [Exception],
        tags: [RootEffect].}

    method forceRedraw(control: Control) {...}{.base, raises: [], tags: [].}

    method canvas(control: Control): Canvas {...}{.base, raises: [], tags: [].}

    method handleDrawEvent(control: Control; event: DrawEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method handleMouseButtonDownEvent(control: Control; event: MouseEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method handleMouseButtonUpEvent(control: Control; event: MouseEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method handleClickEvent(control: Control; event: ClickEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method handleKeyDownEvent(control: Control; event: KeyboardEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method onDispose(control: Control): ControlDisposeProc {...}{.base, raises: [], tags: [].}

    method onDispose=(control: Control; callback: ControlDisposeProc) {...}{.base, raises: [],
        tags: [].}

    method onDraw(control: Control): DrawProc {...}{.base, raises: [], tags: [].}

    method onDraw=(control: Control; callback: DrawProc) {...}{.base, raises: [], tags: [].}

    method onMouseButtonDown(control: Control): MouseButtonProc {...}{.base, raises: [],
        tags: [].}

    method onMouseButtonDown=(control: Control; callback: MouseButtonProc) {...}{.base,
        raises: [], tags: [].}

    method onMouseButtonUp(control: Control): MouseButtonProc {...}{.base, raises: [], tags: [].}

    method onMouseButtonUp=(control: Control; callback: MouseButtonProc) {...}{.base,
        raises: [], tags: [].}

    method onClick(control: Control): ClickProc {...}{.base, raises: [], tags: [].}

    method onClick=(control: Control; callback: ClickProc) {...}{.base, raises: [], tags: [].}

    method onKeyDown(control: Control): KeyboardProc {...}{.base, raises: [], tags: [].}

    method onKeyDown=(control: Control; callback: KeyboardProc) {...}{.base, raises: [], tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:30:50 UTC
