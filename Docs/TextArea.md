-   [Types](#7)
    -   [TextArea](#TextArea "TextArea = ref object of NativeTextBox
          fWrap: bool")
-   [Procs](#12)
    -   [newTextAreaTextArea](#newTextArea%2Cstring "newTextArea(text = ""): TextArea")
    -   [initTextArea](#init%2CTextArea "init(textArea: TextArea)")
-   [Methods](#14)
    -   [addTextTextArea](#addText.e%2CTextArea%2Cstring "addText(textArea: TextArea; text: string)")
    -   [addLineTextArea](#addLine.e%2CTextArea%2Cstring "addLine(textArea: TextArea; text = "")")
    -   [scrollToBottomTextArea](#scrollToBottom.e%2CTextArea "scrollToBottom(textArea: TextArea)")
    -   [wrapTextArea](#wrap.e%2CTextArea "wrap(textArea: TextArea): bool")
    -   [wrap=TextArea](#wrap%3D.e%2CTextArea%2Cbool "wrap=(textArea: TextArea; wrap: bool)")

[Types](#7)
===========

    TextArea = ref object of NativeTextBox
      fWrap: bool

[Procs](#12)
============

    proc newTextArea(text = ""): TextArea {...}{.raises: [Exception], tags: [RootEffect].}

    proc init(textArea: TextArea) {...}{.raises: [Exception], tags: [RootEffect].}

[Methods](#14)
==============

    method addText(textArea: TextArea; text: string) {...}{.base, raises: [], tags: [].}

    method addLine(textArea: TextArea; text = "") {...}{.base, raises: [], tags: [].}

    method scrollToBottom(textArea: TextArea) {...}{.base, raises: [], tags: [].}

    method wrap(textArea: TextArea): bool {...}{.base, raises: [], tags: [].}

    method wrap=(textArea: TextArea; wrap: bool) {...}{.base, raises: [], tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:32:16 UTC
