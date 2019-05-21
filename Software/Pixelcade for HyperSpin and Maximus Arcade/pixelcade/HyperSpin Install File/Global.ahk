; Code in this file will always be run regardless of the system or game being launched
; Do not change the line with the class declaration! The class name must always be GlobalUserFunction and extend UserFunction
; This is just a sample file, you only need to implement the methods you will use the others can be deleted


class GlobalUserFunction extends UserFunction {



	; Use this function to define any code you want to run on initialization
	InitUserFeatures() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; Use this function to define any code you want to run in every module on start
	StartUserFeatures() {
		Global dbName,systemName, romName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		;MsgBox, %systemName%
		;MsgBox, %romName%
		Run, c:\RocketLauncher\Pixelcade\pixelcade.bat "%systemName%" "%romName%" , c:\RocketLauncher\pixelcade\, Hide
		
		;If (systemName = "Nintendo Entertainment System") {
			;MsgBox, "nes match"
			;MsgBox, %romName%
		;}
		
		;because HyperSpin uses different names for the system names that we used in RetroPie, we'll need to map in pixelcade.bat
		
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; Use this function to define any code you may need to stop or clean up in every module on exit
	StopUserFeatures() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		Run, c:\RocketLauncher\Pixelcade\default.bat "%systemName%" "%romName%", c:\RocketLauncher\Pixelcade\, Hide
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; Use this function to define any code you want to run before Pause starts
	StartPauseUserFeatures() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; Use this function to define any code you may need to stop or clean up after Pause ends
	StopPauseUserFeatures() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; These functions can be used to run custom code at certain points in each module

	; This function gets ran right before the primaryExe
	PreLaunch() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; This function gets ran right after the primaryExe
	PostLaunch() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; This function gets ran right after FadeInExit(), after the emulator is loaded
	PostLoad() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; This function gets ran after the module thread ends and before RL exits
	PostExit() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

	; This method gets ran right before Bezel is draw on the screen
	PreBezelDraw() {
		Global dbName,systemName
		RLLog.Info(A_ThisFunc . " - Starting")
		; INSERT CODE HERE
		RLLog.Info(A_ThisFunc . " - Ending")
	}

}


