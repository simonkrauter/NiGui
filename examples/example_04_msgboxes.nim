# This example shows different methods to create message boxes.

import nigui
import nigui/msgbox

app.init()

var window = newWindow()
var mainContainer = newLayoutContainer(Layout_Vertical)
window.add(mainContainer)

var buttons = newLayoutContainer(Layout_Horizontal)
mainContainer.add(buttons)

var textArea = newTextArea()
mainContainer.add(textArea)

var button1 = newButton("Example 1")
buttons.add(button1)
button1.onClick = proc(event: ClickEvent) =
  window.alert("Hello.\n\nThis message box is created with \"alert()\".")
  textArea.addLine("Message box closed")

var button2 = newButton("Example 2")
buttons.add(button2)
button2.onClick = proc(event: ClickEvent) =
  let res = window.msgBox("Hello.\n\nThis message box is created with \"msgBox()\".")
  textArea.addLine("Message box closed, result = " & $res)

var button3 = newButton("Example 3")
buttons.add(button3)
button3.onClick = proc(event: ClickEvent) =
  let res = window.msgBox("Hello.\n\nThis message box is created with \"msgBox()\" and has three buttons.", "Title of message box", "Button 1", "Button 2", "Button 3")
  textArea.addLine("Message box closed, result = " & $res)

window.show()
app.run()
