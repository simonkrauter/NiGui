# This example shows what happens when an unhandled exception occurs in the main loop.

import nigui

app.init()

var window = newWindow()

var container = newLayoutContainer(Layout_Vertical)
window.add(container)

var button = newButton("Raise Exception")
container.add(button)
button.onClick = proc(event: ClickEvent) =
  raise newException(Exception, "Test Exception")

window.show()
app.run()
