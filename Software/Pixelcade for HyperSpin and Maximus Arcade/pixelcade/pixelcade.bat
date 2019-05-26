
@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS

IF "%~1" == "" (
	echo Exiting as no command line parameters were entered
	echo Proper usage is pixelcade platform gamename or pixelcade textmode hi, use quotes if text has spaces
	echo Example: pixelcade mame 1941
	echo Example: pixelcade textmode "hello world" red 
	echo Example: pixelcade textmode "hello world" cyan 8 60 //// 8 is the speed, 60 is font size
	echo Example: pixelcade textmode "hello world" cyan 8 60 -25 5 //// -25 is the vertical position offset and 5 is number of times to loop before exiting
  	EXIT /B
)

call getCmdPID.exe
set "current_pid=%errorlevel%"

REM ************ Let's check if pixelcade.bat is already running and kill it if so ***************
IF %current_pid% == 1 set result=true
IF %current_pid% == "" set result=true
IF "%result%" == "true" (
    echo getCmdPID is not installed, please re-install and add this file. Pixelcade in stream mode will not work.
) ELSE (
	for /f "tokens=2 delims=," %%a in ('
	    tasklist /fi "imagename eq cmd.exe" /v /fo:csv /nh 
	    ^| findstr /r /c:".*pixelcade[^,]*$"
	') do (
		rem echo current pid: "%current_pid%"
		rem echo checked pid: %%a

		if %%a neq "%current_pid%" (
			TASKKILL /PID %%a /f >nul 2>nul /t
			echo Killed running pixelcade process PID: %%a
			rem taskkill /pid %%a /f /t
		)
	)
    )	
)


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


IF "%~1" == "textmode" (
 	goto TEXTMODE  
 )

set CONSOLE=%~1
set GAMENAME=%~2
set WRITEMODE=%~3
SET WORKINGPATH=%~dp0
set USERMESSAGE=""

REM ******* Mapping Table needed for Hyperspin ***************************
rem echo deleteme %CONSOLE%
IF %CONSOLE%=="MAME" set CONSOLE=mame

IF %CONSOLE%=="Amstrad CPC" set CONSOLE=amstradcpc
IF %CONSOLE%=="Amstrad GX4000" set CONSOLE=amstradcpc
IF %CONSOLE%=="Apple II" set CONSOLE=apple2
IF %CONSOLE%=="Apple IIGS" set CONSOLE=apple2
IF %CONSOLE%=="Atari 2600" set CONSOLE=atari2600
IF %CONSOLE%=="Atari 5200" set CONSOLE=atari5200
IF %CONSOLE%=="Atari 7800" set CONSOLE=atari7800
IF %CONSOLE%=="Atari Jaguar" set CONSOLE=atarijaguar
IF %CONSOLE%=="Atari Jaguar CD" set CONSOLE=atarijaguar
IF %CONSOLE%=="Atari Lynx" set CONSOLE=atarilynx
IF %CONSOLE%=="Bandai Super Vision 8000" set CONSOLE=wonderswan
IF %CONSOLE%=="Bandai WonderSwan" set CONSOLE=wonderswan
IF %CONSOLE%=="Bandai WonderSwan Color" set CONSOLE=wonderswancolor
IF %CONSOLE%=="Capcom Classics" set CONSOLE=capcom
IF %CONSOLE%=="Capcom Play System" set CONSOLE=capcom
IF %CONSOLE%=="Capcom Play System II" set CONSOLE=capcom
IF %CONSOLE%=="Capcom Play System III" set CONSOLE=capcom
IF %CONSOLE%=="ColecoVision" set CONSOLE=coleco
IF %CONSOLE%=="Commodore 128" set CONSOLE=c64
IF %CONSOLE%=="Commodore 16 & Plus4" set CONSOLE=c64
IF %CONSOLE%=="Commodore 64" set CONSOLE=c64
IF %CONSOLE%=="Commodore Amiga" set CONSOLE=amiga
IF %CONSOLE%=="Commodore Amiga CD32" set CONSOLE=amiga
IF %CONSOLE%=="Commodore VIC-20" set CONSOLE=c64
IF %CONSOLE%=="Daphne" set CONSOLE=daphne
IF %CONSOLE%=="Final Burn Alpha" set CONSOLE=fba
IF %CONSOLE%=="Future Pinball" set CONSOLE=futurepinball
IF %CONSOLE%=="GCE Vectrex" set CONSOLE=vectrex
IF %CONSOLE%=="Magnavox Odyssey" set CONSOLE=odyssey
IF %CONSOLE%=="Magnavox Odyssey 2" set CONSOLE=odyssey
IF %CONSOLE%=="Mattel Intellivision" set CONSOLE=intellivision
IF %CONSOLE%=="Microsoft MSX" set CONSOLE=msx
IF %CONSOLE%=="Microsoft MSX2" set CONSOLE=msx
IF %CONSOLE%=="Microsoft MSX2+" set CONSOLE=msx
IF %CONSOLE%=="Microsoft Windows 3.x" set CONSOLE=pc
IF %CONSOLE%=="MiSFiT MAME" set CONSOLE=mame
IF %CONSOLE%=="NEC PC Engine" set CONSOLE=pcengine
IF %CONSOLE%=="NEC PC Engine-CD" set CONSOLE=pcengine
IF %CONSOLE%=="NEC PC-8801" set CONSOLE=pcengine
IF %CONSOLE%=="NEC PC-9801" set CONSOLE=pcengine
IF %CONSOLE%=="NEC PC-FX" set CONSOLE=pcengine
IF %CONSOLE%=="NEC SuperGrafx" set CONSOLE=pcengine
IF %CONSOLE%=="NEC TurboGrafx-16" set CONSOLE=pcengine
IF %CONSOLE%=="NEC TurboGrafx-CD" set CONSOLE=pcengine
IF %CONSOLE%=="Nintendo 64" set CONSOLE=n64
IF %CONSOLE%=="Nintendo 64DD" set CONSOLE=n64
IF %CONSOLE%=="Nintendo Entertainment System" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Famicom" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Famicom Disk System" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Game Boy" set CONSOLE=gb
IF %CONSOLE%=="Nintendo Game Boy Advance" set CONSOLE=gba
IF %CONSOLE%=="Nintendo Game Boy Color" set CONSOLE=gbc
IF %CONSOLE%=="Nintendo GameCube" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Pokemon Mini" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Satellaview" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Super Famicom" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Super Game Boy" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Virtual Boy" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Wii" set CONSOLE=nes
IF %CONSOLE%=="Nintendo Wii U" set CONSOLE=nes
IF %CONSOLE%=="Nintendo WiiWare" set CONSOLE=nes
IF %CONSOLE%=="Panasonic 3DO" set CONSOLE=3do
IF %CONSOLE%=="PC Games" set CONSOLE=pc
IF %CONSOLE%=="Pinball FX2" set CONSOLE=futurepinball
IF %CONSOLE%=="Sega 32X" set CONSOLE=sega32x
IF %CONSOLE%=="Sega CD" set CONSOLE=segacd
IF %CONSOLE%=="Sega Classics" set CONSOLE=sega32x
IF %CONSOLE%=="Sega Dreamcast" set CONSOLE=dreamcast
IF %CONSOLE%=="Sega Game Gear" set CONSOLE=gamegear
IF %CONSOLE%=="Sega Genesis" set CONSOLE=genesis
IF %CONSOLE%=="Sega Hikaru" set CONSOLE=sega32x
IF %CONSOLE%=="Sega Master System" set CONSOLE=mastersystem
IF %CONSOLE%=="Sega Model 2" set CONSOLE=sega32x
IF %CONSOLE%=="Sega Model 3" set CONSOLE=sega32x
IF %CONSOLE%=="Sega Naomi" set CONSOLE=sega32x
IF %CONSOLE%=="Sega Pico" set CONSOLE=sega32x
IF %CONSOLE%=="Sega Saturn" set CONSOLE=saturn
IF %CONSOLE%=="Sega SC-3000" set CONSOLE=sega32x
IF %CONSOLE%=="Sega SG-1000" set CONSOLE=sega32x
IF %CONSOLE%=="Sega ST-V" set CONSOLE=sega32x
IF %CONSOLE%=="Sega Triforce" set CONSOLE=sega32x
IF %CONSOLE%=="Sega VMU" set CONSOLE=sega32x
IF %CONSOLE%=="Sinclair ZX Spectrum" set CONSOLE=zxspectrum
IF %CONSOLE%=="Sinclair ZX81" set CONSOLE=zxspectrum
IF %CONSOLE%=="SNK Classics" set CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo AES" set CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo CD" set CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo MVS" set CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo Pocket" set CONSOLE=ngp
IF %CONSOLE%=="SNK Neo Geo Pocket Color" set CONSOLE=ngpc
IF %CONSOLE%=="Sony PlayStation" set CONSOLE=psx
IF %CONSOLE%=="Sony PlayStation 2" set CONSOLE=ps2
IF %CONSOLE%=="Sony PocketStation" set CONSOLE=psp
IF %CONSOLE%=="Sony PSP" set CONSOLE=psp
IF %CONSOLE%=="Sony PSP Minis" set CONSOLE=psp
IF %CONSOLE%=="Super Nintendo Entertainment System" set CONSOLE=snes
IF %CONSOLE%=="Visual Pinball" set CONSOLE=visualpinball
IF %CONSOLE%=="Zinc" set CONSOLE=zinc
REM ****************************************************************

REM ******Set the Default Console Marquees *************************

REM First let's set a default marquee in case the console specific ones don't exist
set CONSOLEDEFAULT=default-marquee.gif
IF %CONSOLE%==default set CONSOLEDEFAULT=default-marquee.gif 

IF %CONSOLE%==3do set CONSOLEDEFAULT=default-3do.gif
IF %CONSOLE%==amiga set CONSOLEDEFAULT=default-amiga.gif
IF %CONSOLE%==amstradcpc set CONSOLEDEFAULT=default-amstradcpc.gif
IF %CONSOLE%==apple2 set CONSOLEDEFAULT=default-apple2.gif
IF %CONSOLE%==arcade set CONSOLEDEFAULT=default-arcade.gif
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
IF %CONSOLE%==pcengine set CONSOLEDEFAULT=default-pcengine.gif
IF %CONSOLE%==psx set CONSOLEDEFAULT=default-psx.gif
IF %CONSOLE%==ps2 set CONSOLEDEFAULT=default-ps2.gif
IF %CONSOLE%==psp set CONSOLEDEFAULT=default-psp.gif
IF %CONSOLE%==saturn set CONSOLEDEFAULT=default-saturn.gif
IF %CONSOLE%==sega32x set CONSOLEDEFAULT=default-sega32x.gif
IF %CONSOLE%==segacd set CONSOLEDEFAULT=default-segacd.gif
IF %CONSOLE%==sg-1000 set CONSOLEDEFAULT=default-sg-1000.gif
IF %CONSOLE%==snes set CONSOLEDEFAULT=default-snes.gif
IF %CONSOLE%==ti99 set CONSOLEDEFAULT=default-ti99.gif
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

REM before we write, let's check if the GIF is already written via MD5 check and if so, then we'll skip the write to same time

for %%# in (certutil.exe) do (
	if not exist "%%~f$PATH:#" (
		echo no certutil installed so we'll skip the MD5 check, no big deal
		echo pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write 
		pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write 
		EXIT /B
	)
)

REM *** We can do the MD5 check so let's do that now and only write the marquee if it's different
set /a count=1 
for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile "%GAMEMARQUEE%" MD5') do (
  if !count! equ 1 set "md5_new=%%a"
  set/a count+=1
)
set "md5_new=%md5_new: =%
REM echo new MD5: %md5_new%

IF EXIST last-marquee.txt (
	set/p md5_last=<last-marquee.txt
) ELSE (
	set md5_last=9999999
)

REM echo last MD5: %md5_last%
echo %md5_new% > last-marquee.txt

IF %md5_new% NEQ %md5_last% (
	
	IF "%WRITEMODE%"=="write" (
			echo pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write
			pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write
	) ELSE (
			echo pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_%
			pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_%
	)
	
) ELSE (
	echo *** MARQUEE HAS NOT CHANGED SO NO NEED TO WRITE AGAIN ***
)
Goto DONE

:TEXTMODE

REM  note that set text is not working within IF statement
SET TEXT=%~2   			
SET COLOR=%~3
SET SPEED=%~4
SET FONTSIZE=%~5
SET OFFSET=%~6
SET LOOP=%~7

IF "%~2" == "" set TEXT=no text entered, correct usage pixelcade textmode your-text-in-quotes color speed fontsize offset loop
IF "%COLOR%" == "" set COLOR=red
IF "%SPEED%" == "" set SPEED=6
IF "%FONTSIZE%" == "" set FONTSIZE=50
IF "%OFFSET%" == "" set OFFSET=-25

IF "%LOOP%" == "" (
	echo pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% 
	pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED%
) ELSE (
	echo pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% --loop=%LOOP%
	pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% --loop=%LOOP%
)

:DONE

REM would prefer not to use goto statement but you cannot have nested IFs in Batch unfortunately

REM possible to do, the java code coud run without a port the first time and then write the detected port to a .txt file. if port not specified here, could read this file as a backup