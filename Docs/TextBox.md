-   [Types](#7)
    -   [TextBox](#TextBox "TextBox = ref object of ControlImpl
          fEditable: bool
          fOnTextChange: TextChangeProc")
-   [Procs](#12)
    -   [newTextBoxTextBox](#newTextBox%2Cstring "newTextBox(text = ""): TextBox")
    -   [initTextBox](#init%2CTextBox "init(textBox: TextBox)")
-   [Methods](#14)
    -   [textTextBox](#text.e%2CTextBox "text(textBox: TextBox): string")
    -   [text=TextBox](#text%3D.e%2CTextBox%2Cstring "text=(textBox: TextBox; text: string)")
    -   [editableTextBox](#editable.e%2CTextBox "editable(textBox: TextBox): bool")
    -   [editable=TextBox](#editable%3D.e%2CTextBox%2Cbool "editable=(textBox: TextBox; editable: bool)")
    -   [cursorPosTextBox](#cursorPos.e%2CTextBox "cursorPos(textBox: TextBox): int")
    -   [cursorPos=TextBox](#cursorPos%3D.e%2CTextBox%2Cint "cursorPos=(textBox: TextBox; cursorPos: int)")
    -   [selectionStartTextBox](#selectionStart.e%2CTextBox "selectionStart(textBox: TextBox): int")
    -   [selectionStart=TextBox](#selectionStart%3D.e%2CTextBox%2Cint "selectionStart=(textBox: TextBox; selectionStart: int)")
    -   [selectionEndTextBox](#selectionEnd.e%2CTextBox "selectionEnd(textBox: TextBox): int")
    -   [selectionEnd=TextBox](#selectionEnd%3D.e%2CTextBox%2Cint "selectionEnd=(textBox: TextBox; selectionEnd: int)")
    -   [selectedTextTextBox](#selectedText.e%2CTextBox "selectedText(textBox: TextBox): string")
    -   [selectedText=TextBox](#selectedText%3D.e%2CTextBox%2Cstring "selectedText=(textBox: TextBox; text: string)")
    -   [handleTextChangeEventTextBox](#handleTextChangeEvent.e%2CTextBox%2CTextChangeEvent "handleTextChangeEvent(textBox: TextBox; event: TextChangeEvent)")
    -   [onTextChangeTextBox](#onTextChange.e%2CTextBox "onTextChange(textBox: TextBox): TextChangeProc")
    -   [onTextChange=TextBox](#onTextChange%3D.e%2CTextBox%2CTextChangeProc "onTextChange=(textBox: TextBox; callback: TextChangeProc)")

[Types](#7)
===========

    TextBox = ref object of ControlImpl
      fEditable: bool
      fOnTextChange: TextChangeProc

[Procs](#12)
============

    proc newTextBox(text = ""): TextBox {...}{.raises: [Exception], tags: [RootEffect].}

    proc init(textBox: TextBox) {...}{.raises: [Exception], tags: [RootEffect].}

[Methods](#14)
==============

    method text(textBox: TextBox): string {...}{.base, locks: "unknown", raises: [], tags: [].}

    method text=(textBox: TextBox; text: string) {...}{.base, locks: "unknown", raises: [],
        tags: [].}

    method editable(textBox: TextBox): bool {...}{.base, raises: [], tags: [].}

    method editable=(textBox: TextBox; editable: bool) {...}{.base, raises: [], tags: [].}

    method cursorPos(textBox: TextBox): int {...}{.base, raises: [], tags: [].}

    method cursorPos=(textBox: TextBox; cursorPos: int) {...}{.base, raises: [], tags: [].}

    method selectionStart(textBox: TextBox): int {...}{.base, raises: [], tags: [].}

    method selectionStart=(textBox: TextBox; selectionStart: int) {...}{.base, raises: [],
        tags: [].}

    method selectionEnd(textBox: TextBox): int {...}{.base, raises: [], tags: [].}

    method selectionEnd=(textBox: TextBox; selectionEnd: int) {...}{.base, raises: [], tags: [].}

    method selectedText(textBox: TextBox): string {...}{.base, raises: [], tags: [].}

    method selectedText=(textBox: TextBox; text: string) {...}{.base, raises: [], tags: [].}

    method handleTextChangeEvent(textBox: TextBox; event: TextChangeEvent) {...}{.base,
        raises: [Exception], tags: [RootEffect].}

    method onTextChange(textBox: TextBox): TextChangeProc {...}{.base, raises: [], tags: [].}

    method onTextChange=(textBox: TextBox; callback: TextChangeProc) {...}{.base, raises: [],
        tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:33:02 UTC
