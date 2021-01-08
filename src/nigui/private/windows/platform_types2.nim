# NiGui - Win32 platform-specific code - part 2

# This file will be included in "nigui.nim".

type
  ContainerImpl* = ref object of Container
    fScrollWndHandle: pointer
    fInnerHandle: pointer

  NativeFrame* = ref object of Frame

  NativeButton* = ref object of Button

  NativeCheckbox* = ref object of Checkbox

  NativeComboBox* = ref object of ComboBox
    fMaxTextWidth: int

  NativeLabel* = ref object of Label

  NativeProgressBar* = ref object of ProgressBar

  NativeTextBox* = ref object of TextBox
