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
    nigui, tables

type Editor* = ref object of TextArea 

proc newEditor*(): Editor =
    var editor = new Editor
    editor.init()
    editor.text = ""

# TODO: Finish Key Handlers
proc handleSignalKey*(key: Key): Key =
    return key

proc handleDirectionKey*(key: Key): Key =
    return key

# Get an array of all keys
# KeyEvent get key code
# Translate key code into a char
# Add char to editor text
# Refresh editor
method handleKeyDownEvent*(control: Editor, event: ControlKeyEvent): void = 
    var charKeys = {
        Key_Q: "q", Key_W: "w", Key_E: "e", Key_R: "r",
        Key_T: "t", Key_Y: "y", Key_U: "u", Key_I: "i",
        Key_O: "o", Key_P: "p", Key_A: "a", Key_S: "s",
        Key_D: "d", Key_F: "f", Key_G: "g", Key_H: "h",
        Key_J: "j", Key_K: "k", Key_L: "l", Key_Z: "z",
        Key_X: "x", Key_C: "c", Key_V: "v", Key_B: "b",
        Key_N: "n", Key_M: "m", Key_Comma: ",", Key_Space: " ",
        Key_Return: "\n", Key_Tab: "\t", Key_Point: ".",
        Key_Asterisk: "*", Key_Plus: "+", Key_Minus: "/",
        Key_Number0: "0", Key_Number1: "1", Key_Number2: "2",
        Key_Number3: "3", Key_Number4: "4", Key_Number5: "5",
        Key_Number6: "6", Key_Number7: "7", Key_Number8: "8",
        Key_Number9: "9"
    }.toTable
    #var signalKeys = [Key_Backspace, Key_Delete]
    #var directionKeys = [Key_Up, Key_Down, Key_Left, Key_Right]

    var key = event.key
    var character: string
    if(charKeys.hasKey(key)):
        # Get key
        character = charKeys[key]
        control.addText(character)
        control.forceRedraw()

    #[elif(signalKeys.contains(key)):
        # Get key
        for i in low(signalKeys)..high(signalKeys):
            if(signalKeys[i] == key):
                # Call signal handler
                handleSignalKey(signalKeys[i]) # Doesnt work   
    elif(directionKeys.contains(key)):
        # Get key
        var direction: Key
        for i in low(directionKeys)..high(directionKeys):
            if(directionKeys[i] == key):
                # Call direction handler 
                handleDirectionKey(directionKeys[i]) # Doesnt work
    ]#

method handleDrawEvent*(control: Editor, event: DrawEvent) =
    let canvas = event.control.canvas
    canvas.areaColor = rgb(40, 42, 54)
    canvas.textColor = rgb(249, 249, 249)
    canvas.drawRectArea(0, 0, control.width, control.height)
    canvas.drawText(control.text)