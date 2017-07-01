# This example shows how to handle keyboard events.

import nigui

app.init()

var window = newWindow()

var label = newLabel()
window.add(label)

window.onKeyDown = proc(event: WindowKeyEvent) =
  label.text = label.text & "KeyDown event: key: " & $event.key & ", unicode: " & $event.unicode & ", character: " & event.character & "\n"

window.show()

app.run()
