import nigui

var
  win: Window
  box: LayoutContainer
  button: Button
  pbar: ProgressBar

app.init()

win = newWindow("Test")

box = newLayoutContainer(Layout_Vertical)
box.padding = 10
win.add(box)

button = newButton("Start thread")
box.add(button)

proc update() =
  {.gcsafe.}:
    pbar.value = pbar.value + 0.01
    app.sleep(100)
    app.queueMain(update)

proc start() =
  {.gcsafe.}:
    app.queueMain(update)

var t: Thread[void]

button.onClick = proc(event: ClickEvent) =
  box.remove(button)

  pbar = newProgressBar()
  box.add(pbar)

  createThread(t, start)

win.show()
app.run()
