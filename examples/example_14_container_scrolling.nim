# This example shows an inner container with a scrollbar.
# Result:
# topContainer will take as many space as needed for the 5 labels.
# There is only one scrollbar:
# The vertical scrollbar in scrollContainer, because it has an insufficient fixed height.

import NiGui

app.init()

var window = newWindow()
window.width = 800
window.height = 500

var mainContainer = newLayoutContainer(Layout_Vertical)
window.add(mainContainer)

var topContainer = newLayoutContainer(Layout_Vertical)
mainContainer.add(topContainer)

for i in 1..5:
  topContainer.add(newLabel("Label in topContainer #" & $i))

var scrollContainer = newLayoutContainer(Layout_Vertical)
mainContainer.add(scrollContainer)
scrollContainer.height = 300
scrollContainer.widthMode = WidthMode_Expand

for i in 1..25:
  scrollContainer.add(newLabel("Label in scrollContainer #" & $i))

window.show()
app.run()
