import nigui#, genui
import tables

var buttons = initTable[string, Button]()

proc clickHandler(event: ClickEvent) =
  echo "Clicked"

app.init()

## TODO: Write a more functional and interesting example, maybe copy the wxNim genui threads example?
genui:
  Window[width = 800, height = 600, show]:
    LayoutContainer(Layout_vertical):
      {buttons["button_1"] = @r}Button("Hello world")
      {buttons["button_2"] = @result}Button("Second button")
  [width = 800, height = 800, show]{(var exported* = @result)}("Test")Window:
    Button

app.run()

