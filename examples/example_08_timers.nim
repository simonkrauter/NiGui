# This example shows how to use timers.

import nigui

app.init()

var window = newWindow()

var mainContainer = newLayoutContainer(Layout_Vertical)
window.add(mainContainer)
var buttonContainer = newLayoutContainer(Layout_Horizontal)
mainContainer.add(buttonContainer)

var textArea = newTextArea()
mainContainer.add(textArea)

var timer: Timer
var counter = 1

proc timerProc(event: TimerEvent) =
  textArea.addLine($counter)
  counter.inc()

var button1 = newButton("startTimer()")
buttonContainer.add(button1)
button1.onClick = proc(event: ClickEvent) =
  timer = startTimer(500, timerProc)

var button2 = newButton("startRepeatingTimer()")
buttonContainer.add(button2)
button2.onClick = proc(event: ClickEvent) =
  timer = startRepeatingTimer(500, timerProc)

var button3 = newButton("stopTimer()")
buttonContainer.add(button3)
button3.onClick = proc(event: ClickEvent) =
  timer.stop()

window.show()

app.run()
