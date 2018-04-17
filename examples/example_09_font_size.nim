# This example shows how to change the font size of controls.

import nigui

app.init()

var window = newWindow()
window.width = 500
window.height = 600
var container = newLayoutContainer(Layout_Vertical)
window.add(container)

for i in 12..20:
  var innerContainer = newLayoutContainer(Layout_Horizontal)
  container.add(innerContainer)
  innerContainer.frame = newFrame("Font size: " & $i)
  var button = newButton("Button")
  button.fontSize = i.float
  innerContainer.add(button)
  var label = newLabel("Label")
  label.fontSize = i.float
  innerContainer.add(label)

window.show()
app.run()
