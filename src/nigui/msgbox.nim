# NiGui - extended message box

# This module provides an extended message box.
# The message box is shown as modal window.
# The message box can have up to 3 buttons with customizable titles.
# button1 will be focused.
# Call the proc msgBox() to open the message box.
# It will wait until the message box is closed.
# Meaning of the result value:
#  0    - message box was closed over the window close button or escape key
#  1..3 - button 1..3 clicked

# For an example see "example_04_msgboxes.nim".

import nigui

type MessageBoxWindow = ref object of WindowImpl
  clickedButton: Button

proc buttonClick(event: ClickEvent) =
  cast[MessageBoxWindow](event.control.parentWindow).clickedButton = cast[Button](event.control)
  event.control.parentWindow.dispose()

proc msgBox*(parent: Window, message: string, title = "Message", button1 = "OK", button2, button3: string = ""): int {.discardable.}  =
  let buttonMinWidth = 100.scaleToDpi
  var window = new MessageBoxWindow
  window.init()
  window.title = title

  window.onKeyDown = proc(event: KeyboardEvent) =
    if event.key == Key_Escape:
      window.dispose()

  var container = newLayoutContainer(Layout_Vertical)
  container.padding = 10.scaleToDpi
  window.control = container

  var labelContainer = newLayoutContainer(Layout_Horizontal)
  container.add(labelContainer)
  labelContainer.widthMode = WidthMode_Expand
  labelContainer.heightMode = HeightMode_Expand

  var label = newLabel(message)
  labelContainer.add(label)

  var buttonContainer = newLayoutContainer(Layout_Horizontal)
  buttonContainer.widthMode = WidthMode_Expand
  buttonContainer.xAlign = XAlign_Center
  buttonContainer.spacing = 12.scaleToDpi
  container.add(buttonContainer)
  var b1, b2, b3: Button

  b1 = newButton(button1)
  b1.minWidth = buttonMinWidth
  b1.onClick = buttonClick
  buttonContainer.add(b1)
  b1.focus()

  if button2 != "":
    b2 = newButton(button2)
    b2.minWidth = buttonMinWidth
    b2.onClick = buttonClick
    buttonContainer.add(b2)

  if button3 != "":
    b3 = newButton(button3)
    b3.minWidth = buttonMinWidth
    b3.onClick = buttonClick
    buttonContainer.add(b3)

  window.width = min(max(label.width + 40.scaleToDpi, buttonMinWidth * 3 + 65.scaleToDpi), 600.scaleToDpi)
  window.height = min(label.height, 300.scaleToDpi) + buttonContainer.height + 70.scaleToDpi

  # Center message box on window:
  window.x = parent.x + ((parent.width - window.width) div 2)
  window.y = parent.y + ((parent.height - window.height) div 2)

  window.showModal(parent)

  while not window.disposed:
    app.sleep(100)

  if window.clickedButton == b1:
    result = 1
  elif window.clickedButton == b2 and b2 != nil:
    result = 2
  elif window.clickedButton == b3 and b3 != nil:
    result = 3
