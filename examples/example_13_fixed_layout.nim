# This example shows how to have controls in a fixed position.
# This means that NiGui's automatic layout capabilities are not used and the controls have to be placed manually.

import nigui

app.init()

var window = newWindow()

var container = newContainer()
window.add(container)

# Add a Button control:
var button = newButton("Button at 0,0")
container.add(button)
button.x = 0
button.y = 0
button.width = 200
button.height = 50

# Add another button:
button = newButton("Button at 300,0")
container.add(button)
button.x = 300
button.y = 0
button.width = 200
button.height = 50

# Add another button:
button = newButton("Button at 0,100")
container.add(button)
button.x = 0
button.y = 100
button.width = 200
button.height = 50

window.show()

app.run()
