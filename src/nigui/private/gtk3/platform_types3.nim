# NiGui - GTK+ 3 platform-specific code - part 3

# This file will be included in "nigui.nim".

type
  NativeTextArea* = ref object of TextArea
    fTextViewHandle: pointer
    fBufferHandle: pointer
