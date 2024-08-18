/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Squirrel Whisperer - laVashik :>                                             |
+----------------------------------------------------------------------------------+
|       A toolbox of versatile utilities for script execution, debugging, file     |
|       operations, and entity manipulation, empowering VScripts developers.       | 
+----------------------------------------------------------------------------------+ */ 

IncludeScript("PCapture-LIB/SRC/Utils/debug")
IncludeScript("PCapture-LIB/SRC/Utils/file")
IncludeScript("PCapture-LIB/SRC/Utils/improvements")
IncludeScript("PCapture-LIB/SRC/Utils/portals")
IncludeScript("PCapture-LIB/SRC/Utils/macros")
if(("IsVSquirrel3" in getroottable()) == false) IncludeScript("PCapture-LIB/SRC/Utils/macros_sq2")
IncludeScript("PCapture-LIB/SRC/Utils/scripts")
IncludeScript("PCapture-LIB/SRC/Utils/const")