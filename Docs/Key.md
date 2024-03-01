Key
===
*   [Types](#7)
    *   [Key](#Key "Key = enum
          Key_None = 0, Key_Backspace = 8, Key_Tab = 9, Key_Return = 13, Key_Pause = 19,
          Key_CapsLock = 20, Key_Escape = 27, Key_Space = 32, Key_ExclamationMark = 33,
          Key_DoubleQuotes = 34, Key_NumberSign = 35, Key_Dollar = 36, Key_Percent = 37,
          Key_Ampersand = 38, Key_OpenParen = 40, Key_CloseParen = 41, Key_Plus = 43,
          Key_Comma = 44, Key_Minus = 45, Key_Point = 46, Key_Divide = 47, Key_Number0 = 48,
          Key_Number1 = 49, Key_Number2 = 50, Key_Number3 = 51, Key_Number4 = 52, Key_Number5 = 53,
          Key_Number6 = 54, Key_Number7 = 55, Key_Number8 = 56, Key_Number9 = 57, Key_Less = 60,
          Key_Equal = 61, Key_Greater = 62, Key_QuestionMark = 63, Key_AtSign = 64, Key_A = 65,
          Key_B = 66, Key_C = 67, Key_D = 68, Key_E = 69, Key_F = 70, Key_G = 71, Key_H = 72, Key_I = 73,
          Key_J = 74, Key_K = 75, Key_L = 76, Key_M = 77, Key_N = 78, Key_O = 79, Key_P = 80, Key_Q = 81,
          Key_R = 82, Key_S = 83, Key_T = 84, Key_U = 85, Key_V = 86, Key_W = 87, Key_X = 88, Key_Y = 89,
          Key_Z = 90, Key_SuperL = 91, Key_SuperR = 92, Key_ContextMenu = 93, Key_Circumflex = 94,
          Key_Numpad0 = 96, Key_Numpad1 = 97, Key_Numpad2 = 98, Key_Numpad3 = 99, Key_Numpad4 = 100,
          Key_Numpad5 = 101, Key_Numpad6 = 102, Key_Numpad7 = 103, Key_Numpad8 = 104,
          Key_Numpad9 = 105, Key_NumpadMultiply = 106, Key_NumpadAdd = 107,
          Key_NumpadSeparator = 108, Key_NumpadSubtract = 109, Key_NumpadDecimal = 110,
          Key_NumpadDivide = 111, Key_F1 = 112, Key_F2 = 113, Key_F3 = 114, Key_F4 = 115, Key_F5 = 116,
          Key_F6 = 117, Key_F7 = 118, Key_F8 = 119, Key_F9 = 120, Key_F10 = 121, Key_F11 = 122,
          Key_F12 = 123, Key_F13 = 124, Key_F14 = 125, Key_F15 = 126, Key_F16 = 127, Key_F17 = 128,
          Key_F18 = 129, Key_F19 = 130, Key_F20 = 131, Key_F21 = 132, Key_F22 = 133, Key_F23 = 134,
          Key_F24 = 135, Key_NumLock = 144, Key_ScrollLock = 145, Key_AE = 196, Key_OE = 214,
          Key_UE = 220, Key_SharpS = 223, Key_Insert = 1000, Key_Delete, Key_Left, Key_Right,
          Key_Up, Key_Down, Key_Home, Key_End, Key_PageUp, Key_PageDown, Key_ControlL,
          Key_ControlR, Key_AltL, Key_AltR, Key_ShiftL, Key_ShiftR, Key_Print,
          Key_NumpadEnter, Key_AltGr")
    *   [KeyboardEvent](#KeyboardEvent "KeyboardEvent = ref object
          window*: Window
          control*: Control
          key*: Key
          unicode*: int
          character*: string
          handled*: bool")
    *   [KeyboardProc](#KeyboardProc "KeyboardProc = proc (event: KeyboardEvent)")

[Types](#7)
===========

[Key](Key.html#Key) \= enum
  Key\_None \= 0, Key\_Backspace \= 8, Key\_Tab \= 9, Key\_Return \= 13, Key\_Pause \= 19,
  Key\_CapsLock \= 20, Key\_Escape \= 27, Key\_Space \= 32, Key\_ExclamationMark \= 33,
  Key\_DoubleQuotes \= 34, Key\_NumberSign \= 35, Key\_Dollar \= 36, Key\_Percent \= 37,
  Key\_Ampersand \= 38, Key\_OpenParen \= 40, Key\_CloseParen \= 41, Key\_Plus \= 43,
  Key\_Comma \= 44, Key\_Minus \= 45, Key\_Point \= 46, Key\_Divide \= 47, Key\_Number0 \= 48,
  Key\_Number1 \= 49, Key\_Number2 \= 50, Key\_Number3 \= 51, Key\_Number4 \= 52, Key\_Number5 \= 53,
  Key\_Number6 \= 54, Key\_Number7 \= 55, Key\_Number8 \= 56, Key\_Number9 \= 57, Key\_Less \= 60,
  Key\_Equal \= 61, Key\_Greater \= 62, Key\_QuestionMark \= 63, Key\_AtSign \= 64, Key\_A \= 65,
  Key\_B \= 66, Key\_C \= 67, Key\_D \= 68, Key\_E \= 69, Key\_F \= 70, Key\_G \= 71, Key\_H \= 72, Key\_I \= 73,
  Key\_J \= 74, Key\_K \= 75, Key\_L \= 76, Key\_M \= 77, Key\_N \= 78, Key\_O \= 79, Key\_P \= 80, Key\_Q \= 81,
  Key\_R \= 82, Key\_S \= 83, Key\_T \= 84, Key\_U \= 85, Key\_V \= 86, Key\_W \= 87, Key\_X \= 88, Key\_Y \= 89,
  Key\_Z \= 90, Key\_SuperL \= 91, Key\_SuperR \= 92, Key\_ContextMenu \= 93, Key\_Circumflex \= 94,
  Key\_Numpad0 \= 96, Key\_Numpad1 \= 97, Key\_Numpad2 \= 98, Key\_Numpad3 \= 99, Key\_Numpad4 \= 100,
  Key\_Numpad5 \= 101, Key\_Numpad6 \= 102, Key\_Numpad7 \= 103, Key\_Numpad8 \= 104,
  Key\_Numpad9 \= 105, Key\_NumpadMultiply \= 106, Key\_NumpadAdd \= 107,
  Key\_NumpadSeparator \= 108, Key\_NumpadSubtract \= 109, Key\_NumpadDecimal \= 110,
  Key\_NumpadDivide \= 111, Key\_F1 \= 112, Key\_F2 \= 113, Key\_F3 \= 114, Key\_F4 \= 115, Key\_F5 \= 116,
  Key\_F6 \= 117, Key\_F7 \= 118, Key\_F8 \= 119, Key\_F9 \= 120, Key\_F10 \= 121, Key\_F11 \= 122,
  Key\_F12 \= 123, Key\_F13 \= 124, Key\_F14 \= 125, Key\_F15 \= 126, Key\_F16 \= 127, Key\_F17 \= 128,
  Key\_F18 \= 129, Key\_F19 \= 130, Key\_F20 \= 131, Key\_F21 \= 132, Key\_F22 \= 133, Key\_F23 \= 134,
  Key\_F24 \= 135, Key\_NumLock \= 144, Key\_ScrollLock \= 145, Key\_AE \= 196, Key\_OE \= 214,
  Key\_UE \= 220, Key\_SharpS \= 223, Key\_Insert \= 1000, Key\_Delete, Key\_Left, Key\_Right,
  Key\_Up, Key\_Down, Key\_Home, Key\_End, Key\_PageUp, Key\_PageDown, Key\_ControlL,
  Key\_ControlR, Key\_AltL, Key\_AltR, Key\_ShiftL, Key\_ShiftR, Key\_Print,
  Key\_NumpadEnter, Key\_AltGr

[KeyboardEvent](Key.html#KeyboardEvent) \= ref object
  window\*: Window
  control\*: Control
  key\*: [Key](Key.html#Key)
  unicode\*: int
  character\*: string
  handled\*: bool

[KeyboardProc](Key.html#KeyboardProc) \= proc (event: [KeyboardEvent](Key.html#KeyboardEvent))

  
Made with Nim. Generated: 2020-03-15 04:31:08 UTC
