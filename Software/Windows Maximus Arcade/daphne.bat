@echo off
setlocal ENABLEDELAYEDEXPANSION
F:\emulators\Daphne\JoyToKey_en\JoyToKey.exe
set CONSOLE=daphne
set GAMENAME=%2
pixelcade.bat %CONSOLE% %GAMENAME%