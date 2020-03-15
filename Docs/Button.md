-   [Types](#7)
    -   [Button](#Button "Button = ref object of ControlImpl
          fText: string
          fEnabled: bool")
-   [Procs](#12)
    -   [newButtonButton](#newButton%2Cstring "newButton(text = ""): Button")
    -   [initButton](#init%2CButton "init(button: Button)")
-   [Methods](#14)
    -   [textButton](#text.e%2CButton "text(button: Button): string")
    -   [text=Button](#text%3D.e%2CButton%2Cstring "text=(button: Button; text: string)")
    -   [enabledButton](#enabled.e%2CButton "enabled(button: Button): bool")
    -   [enabled=Button](#enabled%3D.e%2CButton%2Cbool "enabled=(button: Button; enabled: bool)")
    -   [handleKeyDownEventButton](#handleKeyDownEvent.e%2CButton%2CKeyboardEvent "handleKeyDownEvent(button: Button; event: KeyboardEvent)")

[Types](#7)
===========

    Button = ref object of ControlImpl
      fText: string
      fEnabled: bool

[Procs](#12)
============

    proc newButton(text = ""): Button {...}{.raises: [Exception], tags: [RootEffect].}

    proc init(button: Button) {...}{.raises: [Exception], tags: [RootEffect].}

[Methods](#14)
==============

    method text(button: Button): string {...}{.base, raises: [], tags: [].}

    method text=(button: Button; text: string) {...}{.base, raises: [], tags: [].}

    method enabled(button: Button): bool {...}{.base, raises: [], tags: [].}

    method enabled=(button: Button; enabled: bool) {...}{.base, raises: [], tags: [].}

    method handleKeyDownEvent(button: Button; event: KeyboardEvent) {...}{.raises: [], tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:29:09 UTC
