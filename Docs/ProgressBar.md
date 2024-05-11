-   [Types](#7)
    -   [ProgressBar](#ProgressBar "ProgressBar = ref object of ControlImpl")
-   [Procs](#12)
    -   [newProgressBarProgressBar](#newProgressBar "newProgressBar(): ProgressBar")
    -   [initProgressBar](#init%2CProgressBar "init(progressBar: ProgressBar)")
-   [Methods](#14)
    -   [value=ProgressBar](#value%3D.e%2CProgressBar%2Cfloat "value=(progressBar: ProgressBar; value: float)")

value should be between 0.0 and 1.0

[Types](#7)
===========

    ProgressBar = ref object of ControlImpl

[Procs](#12)
============

    proc newProgressBar(): ProgressBar {...}{.raises: [Exception], tags: [RootEffect].}

    proc init(progressBar: ProgressBar) {...}{.raises: [Exception], tags: [RootEffect].}

[Methods](#14)
==============

    method value=(progressBar: ProgressBar; value: float) {...}{.base, raises: [], tags: [].}

\
 Made with Nim. Generated: 2020-03-15 04:32:15 UTC
