Image
=====
*   [Types](#7)
    *   [Image](#Image "Image = ref object of RootObj
          fCanvas: Canvas")
*   [Procs](#12)
    *   [newImageImage](#newImage "newImage(): Image")
*   [Methods](#14)
    *   [widthImage](#width.e%2CImage "width(image: Image): int")
    *   [heightImage](#height.e%2CImage "height(image: Image): int")
    *   [canvasImage](#canvas.e%2CImage "canvas(image: Image): Canvas")

[Types](#7)
===========

[Image](Image.html#Image) \= ref object of RootObj
  fCanvas: Canvas

[Procs](#12)
============

proc [newImage](#newImage)(): [Image](Image.html#Image) {...}{.raises: \[\], tags: \[\].}

[Methods](#14)
==============

method [width](#width.e%2CImage)(image: [Image](Image.html#Image)): int {...}{.base, raises: \[Exception\], tags: \[RootEffect\].}

method [height](#height.e%2CImage)(image: [Image](Image.html#Image)): int {...}{.base, raises: \[Exception\], tags: \[RootEffect\].}

method [canvas](#canvas.e%2CImage)(image: [Image](Image.html#Image)): Canvas {...}{.base, raises: \[\], tags: \[\].}

  
Made with Nim. Generated: 2020-03-15 04:30:51 UTC
