import nigui, genui
import tables

var buttons = initTable[string, Button]()

proc clickHandler(event: ClickEvent) =
  echo "Clicked"

app.init()

genui:
  Window[width = 800, height = 600, show]:
    LayoutContainer(Layout_vertical):
      {buttons["button_1"] = @result}Button("Hello world")
      {buttons["button_2"] = @result}Button("Second button")
  [width = 800, height = 800, show]{var test = @result}("Test")Window:
    Button

app.run()

