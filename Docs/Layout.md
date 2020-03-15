Layout
======
*   [Types](#7)
    *   [Layout](#Layout "Layout = enum
          Layout_Horizontal, Layout_Vertical")
    *   [LayoutContainer](#LayoutContainer "LayoutContainer = ref object of ContainerImpl
          fLayout: Layout
          fXAlign: XAlign
          fYAlign: YAlign
          fPadding: int
          fSpacing: int")
*   [Procs](#12)
    *   [newLayoutContainerLayout](#newLayoutContainer%2CLayout "newLayoutContainer(layout: Layout): LayoutContainer")
*   [Methods](#14)
    *   [layoutLayoutContainer](#layout.e%2CLayoutContainer "layout(container: LayoutContainer): Layout")
    *   [layout=LayoutContainer](#layout%3D.e%2CLayoutContainer%2CLayout "layout=(container: LayoutContainer; layout: Layout)")
    *   [xAlignLayoutContainer](#xAlign.e%2CLayoutContainer "xAlign(container: LayoutContainer): XAlign")
    *   [xAlign=LayoutContainer](#xAlign%3D.e%2CLayoutContainer%2CXAlign "xAlign=(container: LayoutContainer; xAlign: XAlign)")
    *   [yAlignLayoutContainer](#yAlign.e%2CLayoutContainer "yAlign(container: LayoutContainer): YAlign")
    *   [yAlign=LayoutContainer](#yAlign%3D.e%2CLayoutContainer%2CYAlign "yAlign=(container: LayoutContainer; yAlign: YAlign)")
    *   [paddingLayoutContainer](#padding.e%2CLayoutContainer "padding(container: LayoutContainer): int")
    *   [padding=LayoutContainer](#padding%3D.e%2CLayoutContainer%2Cint "padding=(container: LayoutContainer; padding: int)")
    *   [spacingLayoutContainer](#spacing.e%2CLayoutContainer "spacing(container: LayoutContainer): int")
    *   [spacing=LayoutContainer](#spacing%3D.e%2CLayoutContainer%2Cint "spacing=(container: LayoutContainer; spacing: int)")

[Types](#7)
===========

[Layout](Layout.html#Layout) \= enum
  Layout\_Horizontal, Layout\_Vertical

[LayoutContainer](Layout.html#LayoutContainer) \= ref object of ContainerImpl
  fLayout: [Layout](Layout.html#Layout)
  fXAlign: XAlign
  fYAlign: YAlign
  fPadding: int
  fSpacing: int

[Procs](#12)
============

proc [newLayoutContainer](#newLayoutContainer%2CLayout)(layout: [Layout](Layout.html#Layout)): [LayoutContainer](Layout.html#LayoutContainer) {...}{.raises: \[Exception\],
    tags: \[RootEffect\].}

[Methods](#14)
==============

method [layout](#layout.e%2CLayoutContainer)(container: [LayoutContainer](Layout.html#LayoutContainer)): [Layout](Layout.html#Layout) {...}{.base, raises: \[\], tags: \[\].}

method [layout=](#layout%3D.e%2CLayoutContainer%2CLayout)(container: [LayoutContainer](Layout.html#LayoutContainer); layout: [Layout](Layout.html#Layout)) {...}{.base, raises: \[\], tags: \[\].}

method [xAlign](#xAlign.e%2CLayoutContainer)(container: [LayoutContainer](Layout.html#LayoutContainer)): XAlign {...}{.base, raises: \[\], tags: \[\].}

method [xAlign=](#xAlign%3D.e%2CLayoutContainer%2CXAlign)(container: [LayoutContainer](Layout.html#LayoutContainer); xAlign: XAlign) {...}{.base, raises: \[\], tags: \[\].}

method [yAlign](#yAlign.e%2CLayoutContainer)(container: [LayoutContainer](Layout.html#LayoutContainer)): YAlign {...}{.base, raises: \[\], tags: \[\].}

method [yAlign=](#yAlign%3D.e%2CLayoutContainer%2CYAlign)(container: [LayoutContainer](Layout.html#LayoutContainer); yAlign: YAlign) {...}{.base, raises: \[\], tags: \[\].}

method [padding](#padding.e%2CLayoutContainer)(container: [LayoutContainer](Layout.html#LayoutContainer)): int {...}{.base, raises: \[\], tags: \[\].}

method [padding=](#padding%3D.e%2CLayoutContainer%2Cint)(container: [LayoutContainer](Layout.html#LayoutContainer); padding: int) {...}{.base, raises: \[\], tags: \[\].}

method [spacing](#spacing.e%2CLayoutContainer)(container: [LayoutContainer](Layout.html#LayoutContainer)): int {...}{.base, raises: \[\], tags: \[\].}

method [spacing=](#spacing%3D.e%2CLayoutContainer%2Cint)(container: [LayoutContainer](Layout.html#LayoutContainer); spacing: int) {...}{.base, raises: \[\], tags: \[\].}

  
Made with Nim. Generated: 2020-03-15 04:31:32 UTC
