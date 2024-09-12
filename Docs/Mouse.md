-   [Types](#7)
    -   [MouseButton](#MouseButton "MouseButton = enum
          MouseButton_Left, MouseButton_Middle, MouseButton_Right")
    -   [MouseEvent](#MouseEvent "MouseEvent = ref object
          control*: Control
          button*: MouseButton
          x*: int
          y*: int")
    -   [MouseButtonProc](#MouseButtonProc "MouseButtonProc = proc (event: MouseEvent)")

[Types](#7)
===========

    MouseButton = enum
      MouseButton_Left, MouseButton_Middle, MouseButton_Right

    MouseEvent = ref object
      control*: Control
      button*: MouseButton
      x*: int
      y*: int

    MouseButtonProc = proc (event: MouseEvent)

\
 Made with Nim. Generated: 2020-03-15 04:32:15 UTC
