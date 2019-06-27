
@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS

REM we'll set the title of this window so we have a handle to kill the older sessions, ex. title of window will be pixelcade.bat or something else if users changed the .bat file to another name
TITLE pixelcade

rem our log file
IF EXIST pixelcade.log (
  DEL pixelcade.log
  )

ECHO Pixelcade Version 1.5.5 >> pixelcade.log
CALL getCmdPID.exe >> pixelcade.log
SET "current_pid=%errorlevel%"

rem ************ Let's check if pixelcade.bat is already running and kill it if so but this will only kill cmd windows with pixelcade in the title ***************
IF %current_pid% == 1 SET result=true
IF %current_pid% == "" SET result=true
IF "%result%" == "true" (
    ECHO getCmdPID is not installed, please re-install and add this file. Pixelcade in stream mode will not work.
    ECHO getCmdPID is not installed, please re-install and add this file. Pixelcade in stream mode will not work. >> pixelcade.log
) ELSE (
	FOR /f "tokens=2 delims=," %%a in ('
	    tasklist /fi "imagename eq cmd.exe" /v /fo:csv /nh 
	    ^| findstr /r /c:".*pixelcade[^,]*$"
	') DO (
		ECHO current pid: "%current_pid%"  >> pixelcade.log
		ECHO existing pid: %%a  >> pixelcade.log

		IF %%a neq "%current_pid%" (
			TASKKILL /PID %%a /f >nul 2>nul /t
			ECHO Killed running pixelcade process PID: %%a >> pixelcade.log
		)
	)
    )	
)


IF EXIST settings.ini (
  ECHO found settings.ini >> pixelcade.log
  FOR /f "tokens=1,2 delims==" %%a in (settings.ini) DO ( 
  	IF %%a==port SET port_=%%b
  	IF %%a==ledResolution SET ledResolution_=%%b
  	IF %%a==userMessageTitle SET userMessageTitle_=%%b
  	IF %%a==userMessageDefault SET userMessageDefault_=%%b
  	IF %%a==userMessageGenericPlatform SET userMessageGenericPlatform_=%%b
  	IF %%a==userMessageGameSpecific SET userMessageGameSpecific_=%%b
  	IF %%a==userMessageNoChange SET userMessageNoChange_=%%b
  	IF %%a==MAMEDEFAULT SET MAMEDEFAULT_=%%b
  	
  )
) ELSE (
  ECHO settings.ini is missing, please re-install and add this file
  EXIT /B
)

rem removing trailing spaces
FOR /l %%a in (1,1,31) DO IF "!ledResolution_:~-1!"==" " SET ledResolution_=!ledResolution_:~0,-1!

SET VALUETRACK=0
IF %ledResolution_%==128x32 (
	SET VALUETRACK=128
) 
IF %ledResolution_%==64x32 (
	SET VALUETRACK=64
) 

IF "%~1" == "textmode" (
 	goto TEXTMODE  
 )

rem hard coding these because it's a test write
rem SET CONSOLE=%~1
rem SET GAMENAME=%~2
rem SET STREAMMODE=%~3

SET CONSOLE=mame
SET GAMENAME=1941.zip
SET STREAMMODE=""

SET WORKINGPATH=%~dp0
SET USERMESSAGE=""


ECHO Console: %CONSOLE% >> pixelcade.log
ECHO ROM Name or Path: %GAMENAME% >> pixelcade.log
ECHO Stream Mode: %STREAMMODE% >> pixelcade.log
ECHO Working Path: %WORKINGPATH% >> pixelcade.log

rem ******* Mapping Table needed FOR Hyperspin ***************************
IF %CONSOLE%=="MAME" SET CONSOLE=mame

IF %CONSOLE%=="Amstrad CPC" SET CONSOLE=amstradcpc
IF %CONSOLE%=="Amstrad GX4000" SET CONSOLE=amstradcpc
IF %CONSOLE%=="Apple II" SET CONSOLE=apple2
IF %CONSOLE%=="Apple IIGS" SET CONSOLE=apple2
IF %CONSOLE%=="Atari 2600" SET CONSOLE=atari2600
IF %CONSOLE%=="Atari 5200" SET CONSOLE=atari5200
IF %CONSOLE%=="Atari 7800" SET CONSOLE=atari7800
IF %CONSOLE%=="Atari Jaguar" SET CONSOLE=atarijaguar
IF %CONSOLE%=="Atari Jaguar CD" SET CONSOLE=atarijaguar
IF %CONSOLE%=="Atari Lynx" SET CONSOLE=atarilynx
IF %CONSOLE%=="Bandai Super Vision 8000" SET CONSOLE=wonderswan
IF %CONSOLE%=="Bandai WonderSwan" SET CONSOLE=wonderswan
IF %CONSOLE%=="Bandai WonderSwan Color" SET CONSOLE=wonderswancolor
IF %CONSOLE%=="Capcom Classics" SET CONSOLE=capcom
IF %CONSOLE%=="Capcom Play System" SET CONSOLE=capcom
IF %CONSOLE%=="Capcom Play System II" SET CONSOLE=capcom
IF %CONSOLE%=="Capcom Play System III" SET CONSOLE=capcom
IF %CONSOLE%=="ColecoVision" SET CONSOLE=coleco
IF %CONSOLE%=="Commodore 128" SET CONSOLE=c64
IF %CONSOLE%=="Commodore 16 & Plus4" SET CONSOLE=c64
IF %CONSOLE%=="Commodore 64" SET CONSOLE=c64
IF %CONSOLE%=="Commodore Amiga" SET CONSOLE=amiga
IF %CONSOLE%=="Commodore Amiga CD32" SET CONSOLE=amiga
IF %CONSOLE%=="Commodore VIC-20" SET CONSOLE=c64
IF %CONSOLE%=="Daphne" SET CONSOLE=daphne
IF %CONSOLE%=="Final Burn Alpha" SET CONSOLE=fba
IF %CONSOLE%=="Future Pinball" SET CONSOLE=futurepinball
IF %CONSOLE%=="GCE Vectrex" SET CONSOLE=vectrex
IF %CONSOLE%=="Magnavox Odyssey" SET CONSOLE=odyssey
IF %CONSOLE%=="Magnavox Odyssey 2" SET CONSOLE=odyssey
IF %CONSOLE%=="Mattel Intellivision" SET CONSOLE=intellivision
IF %CONSOLE%=="Microsoft MSX" SET CONSOLE=msx
IF %CONSOLE%=="Microsoft MSX2" SET CONSOLE=msx
IF %CONSOLE%=="Microsoft MSX2+" SET CONSOLE=msx
IF %CONSOLE%=="Microsoft Windows 3.x" SET CONSOLE=pc
IF %CONSOLE%=="MiSFiT MAME" SET CONSOLE=mame
IF %CONSOLE%=="NEC PC Engine" SET CONSOLE=pcengine
IF %CONSOLE%=="NEC PC Engine-CD" SET CONSOLE=pcengine
IF %CONSOLE%=="NEC PC-8801" SET CONSOLE=pcengine
IF %CONSOLE%=="NEC PC-9801" SET CONSOLE=pcengine
IF %CONSOLE%=="NEC PC-FX" SET CONSOLE=pcengine
IF %CONSOLE%=="NEC SuperGrafx" SET CONSOLE=pcengine
IF %CONSOLE%=="NEC TurboGrafx-16" SET CONSOLE=pcengine
IF %CONSOLE%=="NEC TurboGrafx-CD" SET CONSOLE=pcengine
IF %CONSOLE%=="Nintendo 64" SET CONSOLE=n64
IF %CONSOLE%=="Nintendo 64DD" SET CONSOLE=n64
IF %CONSOLE%=="Nintendo Entertainment System" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Famicom" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Famicom Disk System" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Game Boy" SET CONSOLE=gb
IF %CONSOLE%=="Nintendo Game Boy Advance" SET CONSOLE=gba
IF %CONSOLE%=="Nintendo Game Boy Color" SET CONSOLE=gbc
IF %CONSOLE%=="Nintendo GameCube" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Pokemon Mini" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Satellaview" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Super Famicom" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Super Game Boy" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Virtual Boy" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Wii" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo Wii U" SET CONSOLE=nes
IF %CONSOLE%=="Nintendo WiiWare" SET CONSOLE=nes
IF %CONSOLE%=="Panasonic 3DO" SET CONSOLE=3do
IF %CONSOLE%=="PC Games" SET CONSOLE=pc
IF %CONSOLE%=="Pinball FX2" SET CONSOLE=futurepinball
IF %CONSOLE%=="Sega 32X" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega CD" SET CONSOLE=segacd
IF %CONSOLE%=="Sega Classics" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega Dreamcast" SET CONSOLE=dreamcast
IF %CONSOLE%=="Sega Game Gear" SET CONSOLE=gamegear
IF %CONSOLE%=="Sega Genesis" SET CONSOLE=genesis
IF %CONSOLE%=="Sega Hikaru" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega Master System" SET CONSOLE=mastersystem
IF %CONSOLE%=="Sega Model 2" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega Model 3" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega Naomi" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega Pico" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega Saturn" SET CONSOLE=saturn
IF %CONSOLE%=="Sega SC-3000" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega SG-1000" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega ST-V" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega Triforce" SET CONSOLE=sega32x
IF %CONSOLE%=="Sega VMU" SET CONSOLE=sega32x
IF %CONSOLE%=="Sinclair ZX Spectrum" SET CONSOLE=zxspectrum
IF %CONSOLE%=="Sinclair ZX81" SET CONSOLE=zxspectrum
IF %CONSOLE%=="SNK Classics" SET CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo AES" SET CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo CD" SET CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo MVS" SET CONSOLE=neogeo
IF %CONSOLE%=="SNK Neo Geo Pocket" SET CONSOLE=ngp
IF %CONSOLE%=="SNK Neo Geo Pocket Color" SET CONSOLE=ngpc
IF %CONSOLE%=="Sony PlayStation" SET CONSOLE=psx
IF %CONSOLE%=="Sony PlayStation 2" SET CONSOLE=ps2
IF %CONSOLE%=="Sony PocketStation" SET CONSOLE=psp
IF %CONSOLE%=="Sony PSP" SET CONSOLE=psp
IF %CONSOLE%=="Sony PSP Minis" SET CONSOLE=psp
IF %CONSOLE%=="Super Nintendo Entertainment System" SET CONSOLE=snes
IF %CONSOLE%=="Visual Pinball" SET CONSOLE=visualpinball
IF %CONSOLE%=="Zinc" SET CONSOLE=zinc
rem ****************************************************************

rem ******Set the Default Console Marquees *************************

rem First let's SET a default marquee in case the console specific ones don't exist
SET CONSOLEDEFAULT=default-marquee.gif
IF %CONSOLE%==default SET CONSOLEDEFAULT=default-marquee.gif 

IF %CONSOLE%==3do SET CONSOLEDEFAULT=default-3do.gif
IF %CONSOLE%==amiga SET CONSOLEDEFAULT=default-amiga.gif
IF %CONSOLE%==amstradcpc SET CONSOLEDEFAULT=default-amstradcpc.gif
IF %CONSOLE%==apple2 SET CONSOLEDEFAULT=default-apple2.gif
IF %CONSOLE%==arcade SET CONSOLEDEFAULT=default-arcade.gif
IF %CONSOLE%==atari800 SET CONSOLEDEFAULT=default-atari800.gif
IF %CONSOLE%==atari2600 SET CONSOLEDEFAULT=default-atari2600.gif
IF %CONSOLE%==atari5200 SET CONSOLEDEFAULT=default-atari5200.gif
IF %CONSOLE%==atari7800 SET CONSOLEDEFAULT=default-atari7800.gif
IF %CONSOLE%==atarijaguar SET CONSOLEDEFAULT=default-atarijaguar.gif
IF %CONSOLE%==atarilynx SET CONSOLEDEFAULT=default-atarilynx.gif
IF %CONSOLE%==atarist SET CONSOLEDEFAULT=default-atarist.gif
IF %CONSOLE%==c64 SET CONSOLEDEFAULT=default-c64.gif
IF %CONSOLE%==capcom SET CONSOLEDEFAULT=default-capcom.gif
IF %CONSOLE%==coleco SET CONSOLEDEFAULT=default-coleco.gif
IF %CONSOLE%==daphne SET CONSOLEDEFAULT=default-daphne.gif
IF %CONSOLE%==dreamcast SET CONSOLEDEFAULT=default-dreamcast.gif
IF %CONSOLE%==fba SET CONSOLEDEFAULT=default-fba.gif
IF %CONSOLE%==futurepinball SET CONSOLEDEFAULT=default-futurepinball.gif
IF %CONSOLE%==gb SET CONSOLEDEFAULT=default-gb.gif
IF %CONSOLE%==gba SET CONSOLEDEFAULT=default-gba.gif
IF %CONSOLE%==gbc SET CONSOLEDEFAULT=default-gbc.gif
IF %CONSOLE%==gamegear SET CONSOLEDEFAULT=default-gamegear.gif
IF %CONSOLE%==genesis SET CONSOLEDEFAULT=default-genesis.gif
IF %CONSOLE%==intellivision SET CONSOLEDEFAULT=default-intellivision.gif
IF %CONSOLE%==mame SET CONSOLEDEFAULT=default-mame.gif
IF %CONSOLE%==mastersystem SET CONSOLEDEFAULT=default-mastersystem.gif
IF %CONSOLE%==macintosh SET CONSOLEDEFAULT=default-macintosh.gif
IF %CONSOLE%==megadrive SET CONSOLEDEFAULT=default-megadrive.gif
IF %CONSOLE%==msx SET CONSOLEDEFAULT=default-msx.gif
IF %CONSOLE%==nds SET CONSOLEDEFAULT=default-nds.gif
IF %CONSOLE%==neogeo SET CONSOLEDEFAULT=default-neogeo.gif
IF %CONSOLE%==ngpc SET CONSOLEDEFAULT=default-ngpc.gif
IF %CONSOLE%==ngp SET CONSOLEDEFAULT=default-ngp.gif
IF %CONSOLE%==n64 SET CONSOLEDEFAULT=default-n64.gif
IF %CONSOLE%==nes SET CONSOLEDEFAULT=default-nes.gif
IF %CONSOLE%==odyssey SET CONSOLEDEFAULT=default-odyssey.gif
IF %CONSOLE%==pc SET CONSOLEDEFAULT=default-pc.gif
IF %CONSOLE%==pcengine SET CONSOLEDEFAULT=default-pcengine.gif
IF %CONSOLE%==psx SET CONSOLEDEFAULT=default-psx.gif
IF %CONSOLE%==ps2 SET CONSOLEDEFAULT=default-ps2.gif
IF %CONSOLE%==psp SET CONSOLEDEFAULT=default-psp.gif
IF %CONSOLE%==saturn SET CONSOLEDEFAULT=default-saturn.gif
IF %CONSOLE%==sega32x SET CONSOLEDEFAULT=default-sega32x.gif
IF %CONSOLE%==segacd SET CONSOLEDEFAULT=default-segacd.gif
IF %CONSOLE%==sg-1000 SET CONSOLEDEFAULT=default-sg-1000.gif
IF %CONSOLE%==snes SET CONSOLEDEFAULT=default-snes.gif
IF %CONSOLE%==ti99 SET CONSOLEDEFAULT=default-ti99.gif
IF %CONSOLE%==wonderswan SET CONSOLEDEFAULT=default-wonderswan.gif
IF %CONSOLE%==wonderswancolor SET CONSOLEDEFAULT=default-wonderswancolor.gif
IF %CONSOLE%==vectrex SET CONSOLEDEFAULT=default-vectrex.gif
IF %CONSOLE%==virtualboy SET CONSOLEDEFAULT=default-virtualboy.gif
IF %CONSOLE%==visualpinball SET CONSOLEDEFAULT=default-visualpinball.gif
IF %CONSOLE%==zinc SET CONSOLEDEFAULT=default-zinc.gif
IF %CONSOLE%==zmachine SET CONSOLEDEFAULT=default-zmachine.gif
IF %CONSOLE%==zxspectrum SET CONSOLEDEFAULT=default-zxspectrum.gif
rem Now let's check IF the console default exists and IF not, we'll SET it to the default mame default
IF EXIST default-mame.gif (
	IF NOT EXIST %CONSOLEDEFAULT% SET CONSOLEDEFAULT=default-mame.gif
)
rem *******************************************************************************************

For %%A in ("%GAMENAME%") DO (
        rem  ECHO file name only: %%~nA
        SET "GAMENAMEONLY=%%~nA"
)

ECHO Game Name Only: %GAMENAMEONLY% >> pixelcade.log

rem Set the path of the target GIF based on the working path of this batch file + console (relative path) + game name only + .gif
SET "GIFPATH=%WORKINGPATH%%CONSOLE%\%GAMENAMEONLY%.gif"

ECHO GIF path "%GIFPATH%"
ECHO GIF path "%GIFPATH%" >> pixelcade.log

rem Not sure IF this is needed but had some issues, here we are escaping paranthesis with a ^
SET GIFPATHESCAPED=%GIFPATH%
SET GIFPATHESCAPED=!GIFPATHESCAPED:^(=^^^(!
SET GIFPATHESCAPED=!GIFPATHESCAPED:^)=^^^)!


rem Now let's check IF the target GIF exists and IF not, we'll use a generic console specific marquee
IF EXIST "!%GIFPATHESCAPED%!" (
    SET USERMESSAGE=%userMessageGameSpecific_%
    SET "GAMEMARQUEE=%GIFPATH%
    SET CATEGORYTRACK=game
) ELSE (
   SET USERMESSAGE=%userMessageGenericPlatform_% %CONSOLE%
   SET GAMEMARQUEE=%CONSOLEDEFAULT% 
   SET CATEGORYTRACK=platform
)

ECHO Game Marquee: %GAMEMARQUEE% >> pixelcade.log
   
ECHO *** PIXEL LED MARQUEE %VERSION%***
ECHO %USERMESSAGE%

rem before we write, let's check IF the GIF is already written via MD5 check and IF so, then we'll skip the write to same time

FOR %%# in (certutil.exe) DO (
	IF not exist "%%~f$PATH:#" (
		ECHO no certutil installed so we'll skip the MD5 check, no big deal >> pixelcade.log
		ECHO pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write 
		pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write 
		EXIT /B
	)
)

rem *** We can DO the MD5 check so let's DO that now and only write the marquee IF it's different
SET /a count=1 
FOR /f "skip=1 delims=:" %%a in ('CertUtil -hashfile "%GAMEMARQUEE%" MD5') DO (
  IF !count! equ 1 SET "md5_new=%%a"
  SET/a count+=1
)
SET "md5_new=%md5_new: =%
ECHO new MD5: %md5_new% >> pixelcade.log

IF EXIST last-marquee.txt (
	SET/p md5_last=<last-marquee.txt
) ELSE (
	SET md5_last=9999999
)

rem Since this is a test, we'll disable the MD5 check
SET md5_last=9999999

ECHO last MD5: %md5_last% >> pixelcade.log
ECHO %md5_new% > last-marquee.txt

IF "%STREAMMODE%"=="stream" GOTO WRITEORSTREAM

rem Since we are streaming, we don't consider the MD5 check
:CHECKMD5

IF %md5_new% NEQ %md5_last% (
	GOTO WRITEORSTREAM
		
) ELSE (
	ECHO *** MARQUEE HAS NOT CHANGED SO NO NEED TO WRITE AGAIN ***
	ECHO *** MARQUEE HAS NOT CHANGED SO NO NEED TO WRITE AGAIN ***  >> pixelcade.log
	GOTO DONE
)

:WRITEORSTREAM

IF "%STREAMMODE%"=="stream" (
	ECHO *** Streaming Mode *** >> pixelcade.log
	ECHO pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_%
	ECHO pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% >> pixelcade.log
	echo curl.exe curl -s -d "v=1&t=event&tid=UA-140901733-1&cid=555&ec=%CATEGORYTRACK%-stream-test&ea=%CONSOLE%&el=%GAMENAMEONLY%&ev=%VALUETRACK%" -X POST www.google-analytics.com/collect >> pixelcade.log
	IF EXIST curl.exe curl -s -d "v=1&t=event&tid=UA-140901733-1&cid=555&ec=%CATEGORYTRACK%-stream&ea=%CONSOLE%&el=%GAMENAMEONLY%&ev=%VALUETRACK%" -X POST www.google-analytics.com/collect >> pixelcade.log
	pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_%
) ELSE (
	ECHO pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write
	ECHO pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write >> pixelcade.log
	pixelc.exe --port=%port_% --gif="%GAMEMARQUEE%" --%ledResolution_% --write
	echo curl -s -d "v=1&t=event&tid=UA-140901733-1&cid=555&ec=%CATEGORYTRACK%-write-test&ea=%CONSOLE%&el=%GAMENAMEONLY%&ev=%VALUETRACK%" -X POST www.google-analytics.com/collect >> pixelcade.log
	IF EXIST curl.exe curl -s -d "v=1&t=event&tid=UA-140901733-1&cid=555&ec=%CATEGORYTRACK%-write&ea=%CONSOLE%&el=%GAMENAMEONLY%&ev=%VALUETRACK%" -X POST www.google-analytics.com/collect >> pixelcade.log
	ECHO *** Finished Write *** >> pixelcade.log
)
	
GOTO DONE

:TEXTMODE
ECHO *** TEXT MODE ***  >> pixelcade.log
SET TEXT=%~2   			
SET COLOR=%~3
SET SPEED=%~4
SET FONTSIZE=%~5
SET OFFSET=%~6
SET LOOP=%~7

IF "%~2" == "" SET TEXT=no text entered, correct usage pixelcade textmode your-text-in-quotes color speed fontsize offset loop
IF "%COLOR%" == "" SET COLOR=red
IF "%SPEED%" == "" SET SPEED=6
IF "%FONTSIZE%" == "" SET FONTSIZE=50
IF "%OFFSET%" == "" SET OFFSET=-25

ECHO Scrolling Text: %TEXT% >> pixelcade.log
ECHO Color: %COLOR% >> pixelcade.log
ECHO Speed: %SPEED% >> pixelcade.log
ECHO Font Size: %FONTSIZE% >> pixelcade.log
ECHO Text Location Offset: %OFFSET% >> pixelcade.log
ECHO Loop: %LOOP% >> pixelcade.log

rem removing trailing spaces
FOR /l %%a in (1,1,31) DO IF "!TEXT:~-1!"==" " SET TEXT=!TEXT:~0,-1!

ECHO curl -s -d "v=1&t=event&tid=UA-140901733-1&cid=555&ec=textmode-test&ea=%COLOR%&el=%LOOP%&ev=%VALUETRACK%" -X POST www.google-analytics.com/collect >> pixelcade.log
IF EXIST curl.exe curl -s -d "v=1&t=event&tid=UA-140901733-1&cid=555&ec=textmode&ea=%COLOR%&el=%LOOP%&ev=%VALUETRACK%" -X POST www.google-analytics.com/collect >> pixelcade.log
IF "%LOOP%" == "" (
	ECHO pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% 
	ECHO pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% >> pixelcade.log
	pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED%
) ELSE (
	ECHO pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% --loop=%LOOP%
	ECHO pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% --loop=%LOOP% >> pixelcade.log
	pixelc.exe --port=%port_% --text="%TEXT%" --%ledResolution_% --fontsize=50 --offset=-25 --color=%COLOR% --speed=%SPEED% --loop=%LOOP%
)

:DONE

PAUSE

rem would prefer not to use goto statement but nested IFs were causing issues

rem possible to DO, the java code coud run without a port the first time and then write the detected port to a .txt file. IF port not specified here, could read this file as a backup