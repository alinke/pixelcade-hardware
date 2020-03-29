;#ErrorStdOut :?:
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

PixelcadeCOMPortPrompt =
(
* Connect Pixelcade to your PC using the included USB A-A cable now 
* From Device Manager, click Ports and then look for the Pixelcade COM Port Number
* On Windows 10, Pixelcade will display as 'USB Serial Device'
* On Windows 7, Pixelcade will display as 'IOIO-OTG' (separate driver install required for Windows 7)
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
* Press Yes if you have the Pixelcade PinDMD P2.5 size

* Press No if you have a different Pixelcade LED Marquee size: P3, P4, P5, or P6
)

;we need to quit the pixelcade listener if it's running

IniRead, PixelcadeCOMPort, DmdDevice.ini, pixelcade, port

if (PixelcadeCOMPort = "COM99" or PixelcadeCOMPort = "COM")
{
   Run, devmgmt.msc
   
   InputBox, UserInputCOMPortNumber, One Time Setup - Pixelcade COM Port,%PixelcadeCOMPortPrompt% , , 640, 480,800,0
   if ErrorLevel
       MsgBox, Pixelcade PinDMD won't work until the COM Port has been entered, please run this again
   else
    If UserInputCOMPortNumber is not digit
    { 
       MsgBox %PixelcadeCOMPortError%
       Gui, Show
       ExitApp
    }
    
    PixelcadeCOMPortNew = COM%UserInputCOMPortNumber%
    IniWrite, %PixelcadeCOMPortNew%, %A_SCRIPTDIR%\DmdDevice.ini, pixelcade, port 
    MsgBox %PixelcadeCOMPortNew% will be used for Pixelcade PinDMD
    
    MsgBox, 4,Pixelcade Model Selection, %PixelcadeMatrixQuestion%
    IfMsgBox Yes
        IniWrite, rbg, %A_SCRIPTDIR%\DmdDevice.ini, pixelcade, matrix 
    else
    	IniWrite, rgb, %A_SCRIPTDIR%\DmdDevice.ini, pixelcade, matrix 
}

SplashTextOn, , , One Time Setup Complete...
Sleep, 3000
SplashTextOff
ExitApp
