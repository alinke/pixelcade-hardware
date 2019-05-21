
@echo off
setlocal ENABLEDELAYEDEXPANSION

IF EXIST settings.ini (
  for /f "tokens=1,2 delims==" %%a in (settings.ini) do ( 
  	if %%a==port set port_=%%b
  	if %%a==ledResolution set ledResolution_=%%b
  	if %%a==userMessageTitle set userMessageTitle_=%%b
  	if %%a==userMessageDefault set userMessageDefault_=%%b
  	if %%a==userMessageGenericPlatform set userMessageGenericPlatform_=%%b
  	if %%a==userMessageGameSpecific set userMessageGameSpecific_=%%b
  	if %%a==userMessageNoChange set userMessageNoChange_=%%b
  	if %%a==MAMEDEFAULT set MAMEDEFAULT_=%%b
  )
) ELSE (
  echo settings.ini is missing, please re-install and add this file
  EXIT /B
)

set CONSOLE=mame
REM set "GAMENAME=c:\max 2.10\pixelcade\dummy999.bin"
set "GAMENAME=1941.gif
SET WORKINGPATH=%~dp0
set USERMESSAGE=""

REM ******Set the Default Console Marquees *************************

REM First let's set a default marquee in case the console specific ones don't exist
set CONSOLEDEFAULT=default-marquee.gif
IF %CONSOLE%==default set CONSOLEDEFAULT=default-marquee.gif 

IF %CONSOLE%==3do set CONSOLEDEFAULT=default-3do.gif
IF %CONSOLE%==amiga set CONSOLEDEFAULT=default-amiga.gif
IF %CONSOLE%==amstradcpc set CONSOLEDEFAULT=default-amstradcpc.gif
IF %CONSOLE%==apple2 set CONSOLEDEFAULT=default-apple2.gif
IF %CONSOLE%==atari800 set CONSOLEDEFAULT=default-atari800.gif
IF %CONSOLE%==atari2600 set CONSOLEDEFAULT=default-atari2600.gif
IF %CONSOLE%==atari5200 set CONSOLEDEFAULT=default-atari5200.gif
IF %CONSOLE%==atari7800 set CONSOLEDEFAULT=default-atari7800.gif
IF %CONSOLE%==atarijaguar set CONSOLEDEFAULT=default-atarijaguar.gif
IF %CONSOLE%==atarilynx set CONSOLEDEFAULT=default-atarilynx.gif
IF %CONSOLE%==atarist set CONSOLEDEFAULT=default-atarist.gif
IF %CONSOLE%==c64 set CONSOLEDEFAULT=default-c64.gif
IF %CONSOLE%==capcom set CONSOLEDEFAULT=default-capcom.gif
IF %CONSOLE%==coleco set CONSOLEDEFAULT=default-coleco.gif
IF %CONSOLE%==daphne set CONSOLEDEFAULT=default-daphne.gif
IF %CONSOLE%==dreamcast set CONSOLEDEFAULT=default-dreamcast.gif
IF %CONSOLE%==fba set CONSOLEDEFAULT=default-fba.gif
IF %CONSOLE%==futurepinball set CONSOLEDEFAULT=default-futurepinball.gif
IF %CONSOLE%==gb set CONSOLEDEFAULT=default-gb.gif
IF %CONSOLE%==gba set CONSOLEDEFAULT=default-gba.gif
IF %CONSOLE%==gbc set CONSOLEDEFAULT=default-gbc.gif
IF %CONSOLE%==gamegear set CONSOLEDEFAULT=default-gamegear.gif
IF %CONSOLE%==genesis set CONSOLEDEFAULT=default-genesis.gif
IF %CONSOLE%==intellivision set CONSOLEDEFAULT=default-intellivision.gif
IF %CONSOLE%==mame set CONSOLEDEFAULT=default-mame.gif
IF %CONSOLE%==mastersystem set CONSOLEDEFAULT=default-mastersystem.gif
IF %CONSOLE%==macintosh set CONSOLEDEFAULT=default-macintosh.gif
IF %CONSOLE%==megadrive set CONSOLEDEFAULT=default-megadrive.gif
IF %CONSOLE%==msx set CONSOLEDEFAULT=default-msx.gif
IF %CONSOLE%==nds set CONSOLEDEFAULT=default-nds.gif
IF %CONSOLE%==neogeo set CONSOLEDEFAULT=default-neogeo.gif
IF %CONSOLE%==ngpc set CONSOLEDEFAULT=default-ngpc.gif
IF %CONSOLE%==ngp set CONSOLEDEFAULT=default-ngp.gif
IF %CONSOLE%==n64 set CONSOLEDEFAULT=default-n64.gif
IF %CONSOLE%==nes set CONSOLEDEFAULT=default-nes.gif
IF %CONSOLE%==odyssey set CONSOLEDEFAULT=default-odyssey.gif
IF %CONSOLE%==pc set CONSOLEDEFAULT=default-pc.gif
IF %CONSOLE%==psx set CONSOLEDEFAULT=default-psx.gif
IF %CONSOLE%==ps2 set CONSOLEDEFAULT=default-ps2.gif
IF %CONSOLE%==psp set CONSOLEDEFAULT=default-psp.gif
IF %CONSOLE%==saturn set CONSOLEDEFAULT=default-saturn.gif
IF %CONSOLE%==sega32x set CONSOLEDEFAULT=default-sega32x.gif
IF %CONSOLE%==segacd set CONSOLEDEFAULT=default-segacd.gif
IF %CONSOLE%==sg-1000 set CONSOLEDEFAULT=default-sg-1000.gif
IF %CONSOLE%==snes set CONSOLEDEFAULT=default-snes.gif
IF %CONSOLE%==pcengine set CONSOLEDEFAULT=default-pcengine.gif
IF %CONSOLE%==wonderswan set CONSOLEDEFAULT=default-wonderswan.gif
IF %CONSOLE%==wonderswancolor set CONSOLEDEFAULT=default-wonderswancolor.gif
IF %CONSOLE%==vectrex set CONSOLEDEFAULT=default-vectrex.gif
IF %CONSOLE%==virtualboy set CONSOLEDEFAULT=default-virtualboy.gif
IF %CONSOLE%==visualpinball set CONSOLEDEFAULT=default-visualpinball.gif
IF %CONSOLE%==zinc set CONSOLEDEFAULT=default-zinc.gif
IF %CONSOLE%==zmachine set CONSOLEDEFAULT=default-zmachine.gif
IF %CONSOLE%==zxspectrum set CONSOLEDEFAULT=default-zxspectrum.gif
REM Now let's check if the console default exists and if not, we'll set it to the default mame default
IF EXIST default-mame.gif (
	IF NOT EXIST %CONSOLEDEFAULT% set CONSOLEDEFAULT=default-mame.gif
)
REM *******************************************************************************************

echo first gamename is %GAMENAME%
REM Extracting just the name only
For %%A in ("%GAMENAME%") do (
        rem  echo file name only: %%~nA
        set "GAMENAMEONLY=%%~nA"
)

REM Set the path of the target GIF based on the working path of this batch file + console (relative path) + game name only + .gif
set "GIFPATH=%WORKINGPATH%%CONSOLE%\%GAMENAMEONLY%.gif"

ECHO gif path %GIFPATH%

REM Not sure if this is needed but had some issues, here we are escaping paranthesis with a ^
set GIFPATHESCAPED=%GIFPATH%
set GIFPATHESCAPED=!GIFPATHESCAPED:^(=^^^(!
set GIFPATHESCAPED=!GIFPATHESCAPED:^)=^^^)!


REM Now let's check if the target GIF exists and if not, we'll use a generic console specific marquee
IF EXIST "!%GIFPATHESCAPED%!" (
    set USERMESSAGE=%userMessageGameSpecific_%
    set "GAMEMARQUEE=%GIFPATH%
) ELSE (
   set USERMESSAGE=%userMessageGenericPlatform_% %CONSOLE%
   set GAMEMARQUEE=%CONSOLEDEFAULT% 
)
   
echo *** PIXEL LED MARQUEE ***
echo %USERMESSAGE%

echo pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write 
pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write 
pause