@echo off
F:\emulators\Atari Lynx\close joytokey.bat
setlocal ENABLEDELAYEDEXPANSION
set CONSOLE=lynx
set GAMENAME=%2
pixelcade.bat %CONSOLE% %GAMENAME%