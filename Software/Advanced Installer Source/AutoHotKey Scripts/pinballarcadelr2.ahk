;#ErrorStdOut :?:
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

PixelcadeCOMPortPrompt =
(
* From Device Manager, click Ports and then look for the Pixelcade COM Port Number
* On Windows 10, Pixelcade will display as 'USB Serial Device'
* On Windows 7, Pixelcade will display as 'IOIO-OTG'
* Find the number and please only enter the number here (Ex. 5, 6, 7, etc.)
)

PixelcadeCOMPortError =
(
**** ERROR ****
Sorry you did not enter just the number, please run this program again
and only enter the number only, omitting the COM text
)

PixelcadeMatrixQuestion =
(
* Press Yes if you have the Pixelcade LED Marquee size: P3, P4, P5, or P6. This includes Pixelcade for AtGames Legends Ultimate, Arcade1Up, and custom installations.

* Press No if you have the Pixelcade Color Pinball Dot Matrix Display P2.5 size
)

;we need to quit the pixelcade listener if it's running
RunWait, curl.exe -s http://localhost:8080/quit, , Min

IniRead, PixelcadeCOMPort, DmdDevice.ini, pixelcade, port

;let's validate the text COM or com is there
If InStr(PixelcadeCOMPort, "COM")
    COMText=true
Else
    COMText=false

if (PixelcadeCOMPort = "COM99" or PixelcadeCOMPort = "COM" or COMText="false")
{
   Run, devmgmt.msc
   
   InputBox, UserInputCOMPortNumber, One Time Pixelcade COM Port Setup,%PixelcadeCOMPortPrompt% , , 640, 480,800,0
   if ErrorLevel
       MsgBox, Pixelcade Pinball DMD won't work until the COM Port has been entered, please run this again
   else
    If UserInputCOMPortNumber is not digit
    { 
       MsgBox %PixelcadeCOMPortError%
       Gui, Show
       ExitApp
    }
    
    PixelcadeCOMPortNew = COM%UserInputCOMPortNumber%
    IniWrite, %PixelcadeCOMPortNew%, %A_SCRIPTDIR%\DmdDevice.ini, pixelcade, port 
    MsgBox %PixelcadeCOMPortNew% will be used for Pixelcade Pinball DMD
    
    MsgBox, 4,Pixelcade Model Selection, %PixelcadeMatrixQuestion%
    IfMsgBox Yes
        IniWrite, rgb, %A_SCRIPTDIR%\DmdDevice.ini, pixelcade, matrix 
    else
    	IniWrite, rbg, %A_SCRIPTDIR%\DmdDevice.ini, pixelcade, matrix 
   
}

Run, dmdext.exe mirror --source=pinballarcade --no-virtual --use-ini=DmdDevice.ini , , Min

SplashTextOn, , , Please Launch Pinball Arcade...
Sleep, 3000
SplashTextOff
ExitApp

