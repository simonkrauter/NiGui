-   [Types](#7)
    -   [Checkbox](#Checkbox "Checkbox = ref object of ControlImpl
          fText: string
          fEnabled: bool
          fOnToggle: ToggleProc")
-   [Procs](#12)
    -   [newCheckboxCheckbox](#newCheckbox%2Cstring "newCheckbox(text = ""): Checkbox")
    -   [initCheckbox](#init%2CCheckbox "init(checkbox: Checkbox)")
-   [Methods](#14)
    -   [textCheckbox](#text.e%2CCheckbox "text(checkbox: Checkbox): string")
    -   [text=Checkbox](#text%3D.e%2CCheckbox%2Cstring "text=(checkbox: Checkbox; text: string)")
    -   [enabledCheckbox](#enabled.e%2CCheckbox "enabled(checkbox: Checkbox): bool")
    -   [enabled=Checkbox](#enabled%3D.e%2CCheckbox%2Cbool "enabled=(checkbox: Checkbox; enabled: bool)")
    -   [checkedCheckbox](#checked.e%2CCheckbox "checked(checkbox: Checkbox): bool")
    -   [checked=Checkbox](#checked%3D.e%2CCheckbox%2Cbool "checked=(checkbox: Checkbox; checked: bool)")
    -   [handleKeyDownEventCheckbox](#handleKeyDownEvent.e%2CCheckbox%2CKeyboardEvent "handleKeyDownEvent(checkbox: Checkbox; event: KeyboardEvent)")
    -   [onToggleCheckbox](#onToggle.e%2CCheckbox "onToggle(checkbox: Checkbox): ToggleProc")
    -   [onToggle=Checkbox](#onToggle%3D.e%2CCheckbox%2CToggleProc "onToggle=(checkbox: Checkbox; callback: ToggleProc)")
    -   [handleToggleEventCheckbox](#handleToggleEvent.e%2CCheckbox%2CToggleEvent "handleToggleEvent(checkbox: Checkbox; event: ToggleEvent)")

[Types](#7)
===========

    Checkbox = ref object of ControlImpl
      fText: string
      fEnabled: bool
      fOnToggle: ToggleProc

[Procs](#12)
============

    proc newCheckbox(text = ""): Checkbox {...}{.raises: [Exception], tags: [RootEffect].}

    proc init(checkbox: Checkbox) {...}{.raises: [Exception], tags: [RootEffect].}

[Methods](#14)
==============

    method text(checkbox: Checkbox): string {...}{.base, raises: [], tags: [].}

    method text=(checkbox: Checkbox; text: string) {...}{.base, raises: [], tags: [].}

    method enabled(checkbox: Checkbox): bool {...}{.base, raises: [], tags: [].}

    method enabled=(checkbox: Checkbox; enabled: bool) {...}{.base, raises: [], tags: [].}

    method checked(checkbox: Checkbox): bool {...}{.base, raises: [], tags: [].}

    method checked=(checkbox: Checkbox; checked: bool) {...}{.base, raises: [], tags: [].}

    method handleKeyDownEvent(checkbox: Checkbox; event: KeyboardEvent) {...}{.
        raises: [Exception], tags: [RootEffect].}

    method onToggle(checkbox: Checkbox): ToggleProc {...}{.base, raises: [], tags: [].}

    method onToggle=(checkbox: Checkbox; callback: ToggleProc) {...}{.base, raises: [], tags: [].}

    method handleToggleEvent(checkbox: Checkbox; event: ToggleEvent) {...}{.base, raises: [],
        tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:29:43 UTC
