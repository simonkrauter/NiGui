# This example shows how to handle keyboard events.

import nigui

app.init()

var window = newWindow()

var label = newLabel()
window.add(label)

window.onKeyDown = proc(event: KeyboardEvent) =
  label.text = label.text & "KeyDown event: key: " & $event.key & ", unicode: " & $event.unicode & ", character: " & event.character & ", down keys: " & $downKeys() & "\n"

  # Ctrl + Q -> Quit application
  if Key_Q.isDown() and Key_ControlL.isDown():
    app.quit()

window.show()

app.run()
