# This example shows how to use the Open File and Save File As dialogs.

import nigui

app.init()

var window = newWindow()
var mainContainer = newLayoutContainer(Layout_Vertical)
window.add(mainContainer)

var buttons = newLayoutContainer(Layout_Horizontal)
mainContainer.add(buttons)

var textArea = newTextArea()
mainContainer.add(textArea)

var button1 = newButton("Open ...")
buttons.add(button1)
button1.onClick = proc(event: ClickEvent) =
  var dialog = newOpenFileDialog()
  dialog.title = "Test Open"
  dialog.multiple = true
  # dialog.directory = ""
  dialog.run()
  textArea.addLine($dialog.files.len & " files selected")
  if dialog.files.len > 0:
    for file in dialog.files:
      textArea.addLine(file)

var button2 = newButton("Save as ...")
buttons.add(button2)
button2.onClick = proc(event: ClickEvent) =
  var dialog = SaveFileDialog()
  dialog.title = "Test Save"
  # dialog.directory = ""
  dialog.defaultName = "default.txt"
  dialog.run()
  if dialog.file == "":
    textArea.addLine("No file selected")
  else:
    textArea.addLine(dialog.file)

var button3 = newButton("Select Directory ...")
buttons.add(button3)
button3.onClick = proc(event: ClickEvent) =
  var dialog = SelectDirectoryDialog()
  dialog.title = "Test Select Directory"
  # dialog.startDirectory = ""
  dialog.run()
  if dialog.selectedDirectory == "":
    textArea.addLine("No directory selected")
  else:
    textArea.addLine(dialog.selectedDirectory)

window.show()
app.run()
