# This example shows how to handle keyboard events.

import nigui

app.init()

var window = newWindow()

var container = newLayoutContainer(Layout_Vertical)
window.add(container)

var textBox = newTextBox()
container.add(textBox)

var label = newLabel()


window.onKeyDown = proc(event: KeyboardEvent) =
  label.text = label.text & "Window KeyDown event: key: " & $event.key & ", unicode: " & $event.unicode & ", character: " & event.character & ", down keys: " & $downKeys() & "\n"

  # Ctrl + Q -> Quit application
  if Key_Q.isDown() and Key_ControlL.isDown():
    app.quit()

textBox.onKeyDown = proc(event: KeyboardEvent) =
  label.text = label.text & "TextBox KeyDown event: key: " & $event.key & ", unicode: " & $event.unicode & ", character: " & event.character & ", down keys: " & $downKeys() & "\n"

  # Accept only digits
  if event.character.len > 0 and event.character[0].ord >= 32 and (event.character.len != 1 or event.character[0] notin '0'..'9'):
    event.handled = true


container.add(label)

window.show()
textBox.focus()

app.run()
