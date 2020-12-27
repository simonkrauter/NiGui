# This example shows several controls of NiGui.

import nigui

app.init()

var window = newWindow()

var container = newLayoutContainer(Layout_Vertical)
window.add(container)

# Add a Button control:
var button = newButton("Button")
container.add(button)

# Add a Checkbox control:
var checkbox = newCheckbox("Checkbox")
container.add(checkbox)

# Add a ComboBox control:
var comboBox = newComboBox(@["Option 1", "Option 2"])
container.add(comboBox)

# Add a Label control:
var label = newLabel("Label")
container.add(label)

# Add a Progress Bar control:
var progressBar = newProgressBar()
progressBar.value = 0.5
container.add(progressBar)

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
