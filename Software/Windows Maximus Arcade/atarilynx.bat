@echo off
F:\emulators\Atari Lynx\close joytokey.bat
setlocal ENABLEDELAYEDEXPANSION
set CONSOLE=atarilynx
set GAMENAME=%2
pixelcade.bat %CONSOLE% %GAMENAME%