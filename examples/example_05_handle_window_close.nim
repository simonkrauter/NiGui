# This example shows how to handle a window close click.

import nigui
import nigui/msgbox

app.init()

var window = newWindow()

window.onCloseClick = proc(event: CloseClickEvent) =
  case window.msgBox("Do you want to quit?", "Quit?", "Quit", "Minimize", "Cancel")
  of 1: window.dispose()
  of 2: window.minimize()
  else: discard

window.show()
app.run()
