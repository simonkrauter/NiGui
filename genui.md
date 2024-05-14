# Genui
This module provides the genui macro for the NiGui toolkit. Genui is a way to specify graphical interfaces in a hierarchical way to more clearly show the structure of the interface as well as simplifying the code. Genui is currently implemented for wxWidgets, libui, and nigui. The format focuses on being a soft conversion meaning that there are few to no assumptions and most code can be seen as a 1:1 conversion. This makes it easy to look at existing examples for your framework of choice when creating interfaces in genui. Because of this the genui format differs a bit from framework to framework, but aims to bring many of the same features. What follows is the genui format as used with nigui.

## Creating widgets
The most basic operation is to create widgets and add them together in a hierarchy. NiGui uses a very simple style of `newButton` to create a widget of type Button and `parent.add child` to add a child to a parent. In genui this translates to:

```
Window:
  LayoutContainer:
    Button
    Button
```

The above snippet should create a window with a layout container containing two buttons. Although there is one problem, the procedure newLayoutContainer takes a parameter dictating the direction of the layout.

## Passing initialiser parameters
In order to pass parameters to an initialiser you simply enclose them in regular "()" brackets. Genui uses brackets to denote the various things you can do, and the order of the bracketed expressions doesn't matter. So to pass a `Layout` to the `LayoutContainer` simply do:

```
Window:
  LayoutContainer(Layout_vertical):
    Button
    Button
```

To put text on the buttons you would similarily use `Button("Hello World")`. But now we're faced with a new challenge. NiGui requires us to call a `show` procedure on our window, but the window isn't assigned to a variable we can use.

## Calling procedures
Many configuration options in genui requires this pattern of creating a widget and assigning values to it's fields or calling it's procedures. To avoid having to assign variable names to all your widgets just for configuration genui offers a format to create so-called dot-expressions. This uses the "[]" brackets and all statements in there will have a dot and the temporary variable name prepended to them. So to call the `show` procedure and set `width` and `height` of the window we simply do:

```
Window[width = 800, height = 600, show]:
  LayoutContainer(Layout_vertical):
    Button
    Button
```

Now our window shows up with two empty buttons one below the other. But user interfaces aren't always static so we need to be able to assign variable names to out widgets.

## Running code
Previous version of genui (for wxwidgets and libui) used a % notation in which an identifier could be assigned to the widget for later use. The % symbol was chosen as the assignment didn't directly convert to the Nimassignment as to avoid confusion. But this format proved a bit weird, and for data structures like a list or a table you would need to create these variables simply to use them once, something genui was created to avoid.

So this version of genui introduces a new concept. It's still a bit of a work in progress but it shows promise. By using the "{}" brackets arbitrary code can be executed. In these blocks the special symbol `@result` can be used, and will be replaced by the temporary variable name for the widget (a shorthand `@r` also exists as `@result` can get a bit terse). This means that anything from simple assignment to adding to complex data structures is possible. So for example adding our two buttons to a table of buttons would be:

```
Window[width = 800, height = 600, show]:
  LayoutContainer(Layout_vertical):
    {buttons["button_1"] = @result} Button
    {buttons["button_2"] = @r} Button
``` 

As mentioned this is still a bit of a work in progress and not all code works, this has to do with how Nim parses curly brackets. There are two workarounds for this, the simplest is to add regular parenthesis around your code (which Nim silently ignores when converting to code). Or, should that not work either you can wrap code in a string. So converting the above code statements to these two workaround would look like this:

```
Window[width = 800, height = 600, show]:
  LayoutContainer(Layout_vertical):
    {(buttons["button_1"] = @result)} Button
    {"buttons[\"button_2\"] = @r"} Button
```


## A note on order
As mentioned in the section about initialisation parameters the order of the brackets doesn't matter. So if you want to place the "{}" brackets on the end of your line, or if you want to put the "()" before the Widget name doesn't matter. But as an "official" suggestion I typically use this order:

```
{var myButton = @result} Button("Hello World!")[onClick = clickHandler]
```

The exception to this would be for code snippets which can tend to push the widget name too far along the line for readability. In that case they go in the back.

## Adding elements to a widget
Sometimes you want to add widgets to a parent to indicate some change of state in your program. In order to facilitate this genui also comes with the procedure `addElements` which takes a container and genui formatted code like this:

```
myExistingContainer.addElements:
  Layout(Layout_vertical):
    Button
    Button
```

# Quick reference
Don't care about the details? Here is a quick reference to the genui format:

| Bracket | Function                  | Example                      | Generates                          |
|---------|---------------------------|------------------------------|------------------------------------|
| `()`    | Initialisation parameters | `Button("Hello World")`      | `newButton("Hello World")`         |
| `[]`    | Dot-expressions           | `Window[height = 300, show]` | `window.height = 300; window.show` |
| `{}`    | Pure code insertion       | `{var b = @result} Button`   | `var b = newButton()`              |

`genui` creates new code, addElements creates the same code but with `add` statements for top-level widgets. `{}` is still a work in progress, code that doesn't parse in it can be added as a string instead.

