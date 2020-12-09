# This example shows how to change a control from another thread

import nigui

var
  window: Window
  container: LayoutContainer
  button: Button
  pbar: ProgressBar
  thread: Thread[void]

app.init()

window = newWindow("NiGui Example")

container = newLayoutContainer(Layout_Vertical)
container.padding = 10
window.add(container)

button = newButton("Start thread")
container.add(button)

proc update() =
  {.gcsafe.}:
    pbar.value = pbar.value + 0.01
    app.sleep(100)
    app.queueMain(update)

proc start() =
  {.gcsafe.}:
    app.queueMain(update)

button.onClick = proc(event: ClickEvent) =
  container.remove(button)

  pbar = newProgressBar()
  container.add(pbar)

  createThread(thread, start)

window.show()
app.run()
