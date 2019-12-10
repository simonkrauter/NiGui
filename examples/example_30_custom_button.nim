# This example shows how to make a custom button (subclassing).

import nigui


# Definition of a custom button
type CustomButton = ref object of Button

# Custom widgets need to draw themselves
method handleDrawEvent*(control: CustomButton, event: DrawEvent) =
  var button = cast[Button](event.control)
  let canvas = event.control.canvas
  canvas.areaColor = rgb(55, 55, 55)
  canvas.textColor = rgb(255, 255, 255)
  canvas.lineColor = rgb(255, 255, 255)
  canvas.drawRectArea(0, 0, button.width, button.height)
  canvas.drawTextCentered(button.text)
  canvas.drawRectOutline(0, 0, button.width, button.height)

# Override nigui.newButton (optional)
proc newButton(text = ""): Button =
  result = new CustomButton
  result.init()
  result.text = text


# Main program

app.init()

var window = newWindow()

var container = newLayoutContainer(Layout_Vertical)
window.add(container)

# Since newButton is overriden, this code is exactly the same as in a program using the native button
var button = newButton("Button")
container.add(button)

var textArea = newTextArea()
container.add(textArea)

button.onClick = proc(event: ClickEvent) =
  textArea.addLine("Button clicked")

window.show()

app.run()
