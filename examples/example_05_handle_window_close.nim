# This example shows how to handle a window close request.

import nigui
import msgbox

app.init()

var window = newWindow()

window.onDispose = proc(event: WindowDisposeEvent) =
  if window.msgBox("Close the application?", "Close?", "Close", "Abort") != 1:
    event.cancel = true

window.show()
app.run()
