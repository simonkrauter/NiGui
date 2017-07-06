NiGui FAQ
=========

### Is there a GUI builder planned?

No, NiGui is intended to define your user interface by manually written Nim source code.<br>
Using a GUI builder is maybe faster at the start of a project, but to modify an existing UI, it faster to change a few lines of code, instead of dragging around a bunch of widgets.

### How big is the generated executable?

Sizes of "example_01_basic_app":<br>
Linux x64 binary: 608 kB<br>
Windows x64 binary: 705 kB

### Does NiGui support customization?

NiGui allows you to use the native controls like buttons, labels, and text boxes. Typically the look of native controls can't be changed much. For example Windows does not support changing the background color of a button.<br>
As an alternative to native controls, NiGui allows you to create custom controls. Custom controls must draw their surface by it's own, therefore it can look like anything you want. As an example: To create a custom button, you can inherit from the type `Button` and override the method `handleDrawEvent()`. <br>
To make it possible to adjust the look of custom controls to the look of native controls, NiGui allows you to use the platform's default styles, for example `app.defaultBackgroundColor` and `app.defaultTextColor`.

### How does NiGui compare to other GUI toolkits?

*Please add your knowlege here if you know more.*

#### NiGui compared to Gtk

Gtk is a popular cross-platform GUI toolkit written in C.<br>
Gtk uses native widgets partly.<br>
Unlike to NiGui, under Windows the user has to install Gtk or you ship the DLL files with your application.<br>
The Gtk 2 DLL files for Windows takes about 30 MB.<br>
Under the desktop Linux distributions, Gtk 2 and 3 are usually preinstalled.<br>
NiGui uses Gtk 3 as backend under Linux.<br>

#### NiGui compared to Qt

Qt is a popular cross-platform GUI toolkit written in C++.<br>
It uses a preprocessor for the C++ code, therefore it cannot be used with other programming languages like C or Nim.

#### NiGui compared to wxWidgets

wxWidgets is a cross-platform GUI toolkit written in C++.<br>
Unlike NiGui, under Windows the user has to install wxWidgets, or you have to ship the DLL files with your application, or you can statically link wxWidgets into your application.<br>
The wxWidgets DLL files for Windows takes about 20 MB (about the same overhead applies to static linking).<br>
wxWidgets can be used in Nim (https://github.com/Araq/wxnim/).

#### NiGui compared to IUP

IUP is a cross-platform GUI toolkit written in C (http://webserver2.tecgraf.puc-rio.br/iup/).<br>
Like NiGui, IUP uses Gtk and Win32 as backends.<br>
IUP can be used in Nim (https://github.com/nim-lang/iup).
Using a C library in Nim is better than most languages but not perfect. For example the user has to install the library according to the instructions from the wrapper. With a pure Nim project you only need to install the package.

#### NiGui compared to libui

libui is a cross-platform GUI toolkit written in C (https://github.com/andlabs/libui).<br>
Like NiGui, libui uses Gtk and Win32 as backends and uses native controls.<br>
Like NiGui, libui is in the early development phase (at least no documentation is written).<br>
libui can be used in Nim (https://github.com/nim-lang/ui).
Using a C library in Nim is better than most languages but not perfect. For example the user has to install the library according to the instructions from the wrapper. With a pure Nim project you only need to install the package.

#### NiGui compared to nimx

nimx is a cross-platform GUI toolkit written in Nim (https://github.com/yglukhov/nimx).<br>
It uses OpenGL as backend and also works in a web browser.<br>
There are no native controls.<br>
Like NiGui, nimx is in the early development phase (at least no documentation is written).
