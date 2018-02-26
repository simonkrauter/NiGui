# NiGui - Text Editor

# This module provides a text editor
# Text Editor is shown as a TextArea with additional features
# It will have a customizable appearance (background color, text color, ect.)
# It will calculate cursor position on click
# It will edit the contents of a file
# It adds letters on KeyDown Event
# Syntax highlighting

# For example see "example_14_editor.nim"

# WARNING: File is incomplete!

import 
    nigui, tables, strutils

type Editor* = ref object of TextArea 

var this: Editor

proc newEditor*(parent: Window, text = ""): Editor =
    result = new Editor
    result.init()
    result.text = text
    this = result
    parent.onKeyDown = proc(event: WindowKeyEvent) =
        if event.key == Key_Return:
            this.addText("\n")
        elif event.key == Key_Backspace:
            var txt = this.text
            var index = len(this.text)
            delete(txt, index, index)
            this.text = txt
        elif event.key == Key_Tab:
            this.addText("\t")
        else:
            this.addText(event.character)
        this.forceRedraw()

method handleDrawEvent*(control: Editor, event: DrawEvent) =
    let canvas = event.control.canvas
    canvas.areaColor = rgb(40, 42, 54)
    canvas.textColor = rgb(249, 249, 249)
    canvas.drawRectArea(0, 0, control.width, control.height)
    canvas.drawText(control.text)