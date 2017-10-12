# This example shows several controls of NiGui.

import nigui

app.init()

var window = newWindow()

var container = newLayoutContainer(Layout_Vertical)
window.add(container)

# Add a Button control:
var button = newButton("Button")
container.add(button)

# Add a Label control:
var label = newLabel("Label")
container.add(label)

# Add a Checkbox control:
var checkbox = newCheckbox("Checkbox")
container.add(checkbox)

# Add a TextBox control:
var textBox = newTextBox("TextBox")
container.add(textBox)

# Add a TextArea control:
var textArea = newTextArea("TextArea\nLine 2\n")
container.add(textArea)

# Add more text to the TextArea:
for i in 3..30:
  textArea.addLine("Line " & $i)

window.show()

app.run()
