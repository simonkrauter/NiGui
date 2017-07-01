# This example shows what happens when a nigui widget error occurs.

import nigui

app.init()

var window = newWindow()

window.add(newButton("Button 1")) # ok
window.add(newButton("Button 2")) # not ok, gives error messages, but program continues

window.show()
app.run()
