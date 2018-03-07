import nigui
import nigui/editor

app.init()

var window = newWindow("Editor test")
window.width = 800
window.height = 600

var mainContainer = newLayoutContainer(Layout_Vertical)
window.add(mainContainer)

var textEditor = newEditor(window)
mainContainer.add(textEditor)

window.show()

app.run()