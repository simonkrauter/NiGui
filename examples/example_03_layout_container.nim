# This example shows some possibilities to align controls with a LayoutContainer.

import nigui

app.init()

# Row 1: Auto-sized:
var innerContainer1 = newLayoutContainer(Layout_Horizontal)
innerContainer1.frame = newFrame("Row 1: Auto-sized")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer1.add(control)

# Row 2: Auto-sized, more padding:
var innerContainer2 = newLayoutContainer(Layout_Horizontal)
innerContainer2.padding = 10
innerContainer2.frame = newFrame("Row 2: Auto-sized, more padding")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer2.add(control)

# Row 3: Auto-sized, more spacing:
var innerContainer3 = newLayoutContainer(Layout_Horizontal)
innerContainer3.spacing = 15
innerContainer3.frame = newFrame("Row 3: Auto-sized, more spacing")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer3.add(control)

# Row 4: Controls expanded:
var innerContainer4 = newLayoutContainer(Layout_Horizontal)
innerContainer4.frame = newFrame("Row 4: Controls expanded")
for i in 1..3:
  var control = newButton("Button " & $i)
  control.widthMode = WidthMode_Expand
  innerContainer4.add(control)

# Row 5: Controls centered:
var innerContainer5 = newLayoutContainer(Layout_Horizontal)
innerContainer5.widthMode = WidthMode_Expand
innerContainer5.height = 80 # problem
innerContainer5.xAlign = XAlign_Center
innerContainer5.yAlign = YAlign_Center
innerContainer5.frame = newFrame("Row 5: Controls centered")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer5.add(control)

# Row 6: Container expanded, spread:
var innerContainer6 = newLayoutContainer(Layout_Horizontal)
# innerContainer.height = 80
innerContainer6.widthMode = WidthMode_Expand
innerContainer6.xAlign = XAlign_Spread
innerContainer6.frame = newFrame("Row 6: Container expanded, spread")
for i in 1..3:
  var control = newButton("Button " & $i)
  innerContainer6.add(control)

# Row 7: Static size:
var innerContainer7 = newLayoutContainer(Layout_Horizontal)
innerContainer7.widthMode = WidthMode_Expand
innerContainer7.xAlign = XAlign_Center
innerContainer7.yAlign = YAlign_Center
innerContainer7.frame = newFrame("Row 7: Static size")
for i in 1..3:
  var control = newButton("Button " & $i)
  control.width = 90 * i
  control.height = 15 * i
  innerContainer7.add(control)

var mainContainer = newLayoutContainer(Layout_Vertical)
mainContainer.add(innerContainer1)
mainContainer.add(innerContainer2)
mainContainer.add(innerContainer3)
mainContainer.add(innerContainer4)
mainContainer.add(innerContainer5)
mainContainer.add(innerContainer6)
mainContainer.add(innerContainer7)

var window = newWindow()
window.width = 800
window.height = 600
window.add(mainContainer)
window.show()

app.run()
