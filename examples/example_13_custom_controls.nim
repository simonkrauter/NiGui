import nigui

#[ 
    This will allow you to create a custom control.
    Import this file into your main application file
    in order to use your custom control type in your app.
 ]#

# Declare new custom control type
type CustomLabel* = ref object of Label

# Handle object initialization
proc newCustomLabel*(text = ""): CustomLabel =
    # Creates new custom object
    result = new CustomLabel

    # Initializes object
    result.init()

    # Set default text
    result.text = text

# Handle Custom Control Drawing to Screen
method handleDrawEvent*(control: CustomLabel, event: DrawEvent) =
    # Create a new Canvas to draw the custom control
    let canvas = event.control.canvas

    # Set custom control color scheme
    canvas.areaColor = rgb(255, 255, 255)
    canvas.textColor = rgb(0, 0, 0)
    canvas.lineColor = rgb(0, 0, 0)

    # Draw the control shape
    canvas.drawRectArea(0, 0, control.width, control.height)
    canvas.drawTextCentered(control.text)
    canvas.drawRectOutline(0, 0, control.width, control.height)
