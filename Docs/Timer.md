-   [Types](#7)
    -   [Timer](#Timer "Timer = distinct int")
    -   [TimerEvent](#TimerEvent "TimerEvent = ref object
          timer*: Timer
          data*: pointer")
    -   [TimerProc](#TimerProc "TimerProc = proc (event: TimerEvent)")
-   [Consts](#10)
    -   [inactiveTimer](#inactiveTimer "inactiveTimer = 0")

[Types](#7)
===========

    Timer = distinct int

    TimerEvent = ref object
      timer*: Timer
      data*: pointer

    TimerProc = proc (event: TimerEvent)

[Consts](#10)
=============

    inactiveTimer = 0

\
 Made with Nim. Generated: 2020-03-15 04:33:02 UTC
