# This example shows how to do image processing without GUI

import nigui

app.init()

var image1 = newImage()
image1.loadFromFile("example_01_basic_app.png")
# Reads the file and holds the image as bitmap in memory

var image2 = newImage()
image2.resize(200, 200)

let canvas = image2.canvas
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

image2.saveToPngFile("out.png")
# Save the image as PNG file

