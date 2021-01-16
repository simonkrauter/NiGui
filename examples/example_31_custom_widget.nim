# This example shows how to make a custom widget (subclassing).

import nigui


# Definition of a custom widget
type MyWidget* = ref object of ControlImpl
  counter: int

# Custom widgets need to draw themselves
method handleDrawEvent(control: MyWidget, event: DrawEvent) =
  let canvas = event.control.canvas
  canvas.areaColor = rgb(55, 55, 55)
  canvas.textColor = rgb(255, 255, 255)
  canvas.lineColor = rgb(255, 255, 255)
  canvas.drawRectArea(0, 0, control.width, control.height)
  canvas.drawTextCentered($control.counter)
  canvas.drawRectOutline(0, 0, control.width, control.height)

# Custom click handler
method handleClickEvent(control: MyWidget, event: ClickEvent) =
  procCall control.ControlImpl.handleClickEvent(event)
  control.counter.inc
  control.forceRedraw

# Constructor (optional)
proc newMyWidget*(): MyWidget =
  result = new MyWidget
  result.init()
  result.width = 100.scaleToDpi
  result.height = 50.scaleToDpi


# Main program

app.init()

var window = newWindow()

var container = newLayoutContainer(Layout_Vertical)
window.add(container)

var myWidget = newMyWidget()
container.add(myWidget)

var textArea = newTextArea()
container.add(textArea)

myWidget.onClick = proc(event: ClickEvent) =
  textArea.addLine("myWidget clicked")

window.show()

app.run()
