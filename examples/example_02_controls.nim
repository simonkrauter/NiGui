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

# Add a TextBox control:
var textBox = newTextBox("TextBox")
container.add(textBox)

# Add a TextArea control:
var textArea = newTextArea("TextArea\pLine 2\p")
container.add(textArea)

# Add more text to the TextArea:
for i in 3..15:
  textArea.addLine("Line " & $i)

# Add click event to the button:
button.onClick = proc(event: ClickEvent) =
  textArea.addLine("Button clicked")

window.show()

app.run()
