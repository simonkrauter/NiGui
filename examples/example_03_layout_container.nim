# This example shows some possibilities to align controls with a LayoutContainer.

import nigui

app.init()

var window = newWindow()
window.width = 800
window.height = 600
var mainContainer = newLayoutContainer(Layout_Vertical)
window.add(mainContainer)

# Row 1: Auto-sized:
var innerContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(innerContainer)
innerContainer.frame = newFrame("Row 1: Auto-sized")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer.add(control)

# Row 2: Auto-sized, more padding:
innerContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(innerContainer)
innerContainer.padding = 10
innerContainer.frame = newFrame("Row 2: Auto-sized, more padding")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer.add(control)

# Row 3: Auto-sized, more spacing:
innerContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(innerContainer)
innerContainer.spacing = 15
innerContainer.frame = newFrame("Row 3: Auto-sized, more spacing")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer.add(control)

# Row 4: Controls expanded:
innerContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(innerContainer)
innerContainer.frame = newFrame("Row 4: Controls expanded")
for i in 1..3:
  var control = newButton("Button " & $i)
  control.widthMode = WidthMode_Expand
  innerContainer.add(control)

# Row 5: Controls centered:
innerContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(innerContainer)
innerContainer.widthMode = WidthMode_Expand
innerContainer.height = 80 # problem
innerContainer.xAlign = XAlign_Center
innerContainer.yAlign = YAlign_Center
innerContainer.frame = newFrame("Row 5: Controls centered")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer.add(control)

# Row 6: Container expanded, spread:
innerContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(innerContainer)
# innerContainer.height = 80
innerContainer.widthMode = WidthMode_Expand
innerContainer.xAlign = XAlign_Spread
innerContainer.frame = newFrame("Row 6: Container expanded, spread")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer.add(control)

# Row 7: Static size:
innerContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(innerContainer)
innerContainer.widthMode = WidthMode_Expand
innerContainer.xAlign = XAlign_Center
innerContainer.yAlign = YAlign_Center
innerContainer.frame = newFrame("Row 7: Static size")
for i in 1..3:
  var control = newButton("Button " & $i)
  control.width = 90 * i
  control.height = 15 * i
  innerContainer.add(control)


window.show()
app.run()
