MEmu := "Visual Pinball"
MEmuV := "v8.1.1 & v9.12"
MURL := ["http://sourceforge.net/projects/vpinball/"]
MAuthor := ["djvj"]
MVersion := "2.0.1"
MCRC := "86821212"
iCRC := "5089D1EC"
MID := "635038268932497719"
MSystem := ["Visual Pinball"]
;----------------------------------------------------------------------------
; Notes:
; Requires VPinMame v2.4
; If you want to use a picture while the table is loading, place it on the dir with this module and define the width & height and its filename in the variables below.
; You can also set the color of the background
; If you use Esc as your exit_emulator_key, set EscClose to true. The emu closes faster if you don't use Esc, and this value doesn't seem to matter if you use Win7
;
; VPinMame uses the registry to store configs @ HKEY_CURRENT_USER\Software\Freeware\Visual PinMame
; Each time a new table is ran, it pulls the default configs into a new folder in the registry
; Visual Pinball stores settings in the registry @ HKEY_USERS\S-1-5-21-440413192-1003725550-97281542-1001\Software\Visual Pinball
;----------------------------------------------------------------------------
StartModule()
FadeInStart()
 
settingsFile := modulePath . "\" . moduleName . ".ini"
EscClose := IniReadCheck(settingsFile, "Settings", "EscClose","false",,1) ; This fixes VP from crashing (in WinXP) on exit when using Esc as your exit key.
showDMD := IniReadCheck(settingsFile, "Settings", "ShowDMD","true",,1)
updateDefaultDMD := IniReadCheck(settingsFile, "Settings", "UpdateDefaultDMD","true",,1) ; Set this to true if you want the script to set the default position of the DMD on next run.
dmdX := IniReadCheck(settingsFile, "Settings", "DMDX","45",,1) ; Your new default X position of the DMD
dmdY := IniReadCheck(settingsFile, "Settings", "DMDY","35",,1) ; Your new default Y position of the DMD
dmdWidth := IniReadCheck(settingsFile, "Settings", "DMDWidth","300",,1) ; Your new default DMD Width
dmdHeight := IniReadCheck(settingsFile, "Settings", "DMDHeight","75",,1) ; Your new default DMD Height
validateDMDLaunch := IniReadCheck(settingsFile, "Settings|" . romName, "ValidateDMDLaunch", "false",,1)
 
7z(romPath, romName, romExtension, 7zExtractPath)
 
; Update default DMD position & size so when new tables are ran, they use the new defaults
If ( updateDefaultDMD  = "true" ) {
	dmdXcur := ReadReg("dmd_pos_x")
	dmdYcur := ReadReg("dmd_pos_y")
	dmdWcur := ReadReg("dmd_width")
	dmdHcur := ReadReg("dmd_height")
	If ( dmdXcur != dmdX or dmdYcur != dmdY or dmdWcur != dmdWidth or dmdHcur != dmdHeight ) {
		WriteReg("dmd_pos_x",dmdX)
		WriteReg("dmd_pos_y",dmdY)
		WriteReg("dmd_width",dmdWidth)
		WriteReg("dmd_height",dmdHeight)
	}
}

;**** Pixelcade DMD Addition *******
Run, "d:\arcade\Pixelcade\curl.exe" "http://localhost:8080/quit" , d:\arcade\Pixelcade\, Hide
;**** Pixelcade DMD Addition *******
Run(executable . " /exit /play -""" . romPath . "\" . romName . romExtension . """",emuPath, "Min") ; hide does not work

 
WinWait("Preparing Table AHK_class #32770")
WinWaitClose("Preparing Table AHK_class #32770",,4)
Sleep, 500
 
; script to look for Please answer window, selects Yes I am and hits enter to continue loading table
Loop {
	Sleep 50
	IfWinExist, Please ; Nag screen the first time a table is ran
	{	WinActivate, Please
		IfWinActive, Please
		{	SetControlDelay -1
			ControlClick, Button2, Please answer AHK_class #32770 ; Click Yes I am
			ControlSend, Button1, {Enter}, Please answer AHK_class #32770 ; Click the OK button
		}
	} Else ifWinExist, Game Info ; unknown window
	{	WinActivate, Game Info
		IfWinActive, Game Info
		{	Send {Enter}
			Send {Enter}
		}
	} Else ifWinExist, Notice ; sound not 100% acurate
	{	WinActivate, Notice
		IfWinActive, Notice
		{	Send {Enter}
			Send {Enter}
		}
	} Else ifWinExist, VBScript ; all msg boxes from vp script (like vb/vpm version not high enough...)
	{	WinActivate, VBScript
		IfWinActive, VBScript
		Send {Enter}
	} ;Else IfWinExist, Error ; serious errors - like z buffer too small and so on
   ; {
		; we have some error and we want to see it so we don't send Enter
		; Send {Enter}
		; Gui, Destroy
		; WinActivate, Error
		; WinWaitActive, Error
		; WinWaitClose, Error
		; WinClose, ahk_class VPinball
		; Process, WaitClose, %executable%
		; ExitModule()
	; }
	IfWinExist, Visual Pinball Player,, DMD ;Check if visual pinball is Ready
		IfWinActive, Visual Pinball Player,, DMD ;Check if visual pinball is Ready
			Break
}
 
Sleep, 500
WinWait("ahk_Class VPPlayer")
Sleep, 500
Loop {
	IfWinActive, ahk_class VPPlayer
		Break
	WinActivate, ahk_class VPPlayer
	Sleep, 50
}
WinWaitActive("ahk_class VPPlayer")
Sleep, 1000
 
; Give focus to the dmd so it appears on top of the playfield
If showDMD = true
{	DetectHiddenWindows, off ; don't detect dmd if it is hidden
	WinActivate, ahk_class MAME
	If validateDMDLaunch = true
		WinWaitActive("ahk_class MAME",,2)
	ControlClick,, ahk_class MAME ; clicking the dmd to set the WS_EX_TOPMOST parameter (AlwaysOnTop)
	DetectHiddenWindows on
	WinActivate, ahk_class VPPlayer
	WinWaitActive("ahk_class VPPlayer")
}
 
FadeInExit()
Process("WaitClose",executable)
7zCleanUp()
FadeOutExit()
ExitModule()
 
 
ReadReg(var1) {
	RegRead, regValue, HKEY_CURRENT_USER, Software\Freeware\Visual PinMame\default, %var1%
	Return %regValue%
}
 
WriteReg(var1, var2) {
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Freeware\Visual PinMame\default, %var1%, %var2%
}
 
CloseProcess:
	FadeOutStart()
	If escClose = true
	{	DetectHiddenWindows, On ;Or next line will not work
		Sleep, 50
		;ControlSend, Button1, q, ahk_class #32770
		ControlSend, Button2, r, ahk_class #32770 ; in case q crashes VP, use this
	}
	; If ( exe = vp8tag ) {
		; WinClose, ahk_class VPinball
	; } Else {
		Sleep, 150
		WinHide, ahk_class VPinball ;This line fixes where the VP Window flashes real quick when closing the window for a cleaner exit
		WinMinimize, ahk_class VPinball
		WinClose("ahk_class VPinball")
		;**** Pixelcade DMD Addition *******
		Run, d:\arcade\Pixelcade\pixelweb.exe, d:\arcade\Pixelcade\, Hide
		;**** Pixelcade DMD Addition *******
	; }
Return
