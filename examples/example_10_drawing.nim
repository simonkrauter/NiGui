# This example shows how to draw the surface of a control.

import nigui

app.init()
var window = newWindow()
window.width = 500
window.height = 500

var control1 = newControl()
window.add(control1)
# Creates a drawable control

control1.widthMode = WidthMode_Fill
control1.heightMode = HeightMode_Fill
# Let it fill out the whole window

var image1 = newImage()
image1.loadFromFile("example_01_basic_app.png")
# Reads the file and holds the image as bitmap in memory

var image2 = newImage()
image2.resize(2, 2)
# Creates a new bitmap

image2.canvas.setPixel(0, 0, rgb(255, 0, 0))
image2.canvas.setPixel(0, 1, rgb(255, 0, 0))
image2.canvas.setPixel(1, 1, rgb(0, 255, 0))
image2.canvas.setPixel(1, 0, rgb(0, 0, 255))
# Modifies single pixels

control1.onDraw = proc (event: DrawEvent) =
  let canvas = event.control.canvas
  # A shortcut

  canvas.areaColor = rgb(30, 30, 30) # dark grey
  canvas.fill()
  # Fill the whole area

  canvas.setPixel(0, 0, rgb(255, 0, 0))
  # Modifies a single pixel

  canvas.areaColor = rgb(255, 0, 0) # red
  canvas.drawRectArea(10, 10, 30, 30)
  # Draws a filled rectangle

  canvas.lineColor = rgb(255, 0, 0) # red
  canvas.drawLine(60, 10, 110, 40)
  # Draws a line

  let text = "Hello World!"
  canvas.textColor = rgb(0, 255, 0) # lime
  canvas.fontSize = 20
  canvas.fontFamily = "Arial"
  canvas.drawText(text, 10, 70)
  # Outputs a text

  canvas.drawRectOutline(10, 70, canvas.getTextWidth(text), canvas.getTextLineHeight())
  # Draws a rectangle outline

  canvas.drawImage(image1, 10, 120)
  # Draws an image in original size

  canvas.drawImage(image2, 120, 120, 50)
  # Draws an image stretched

control1.onMouseButtonDown = proc (event: MouseEvent) =
  echo(event.button, " (", event.x, ", ", event.y, ")")
  # Shows where the mouse is clicked in control-relative coordinates

window.show()
app.run()
