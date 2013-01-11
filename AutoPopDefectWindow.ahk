#SingleInstance force

;-----------------------------
; Customizable Values
;-----------------------------
; Change this to whatever icon you want to use or comment it out for default AutoHotKey icon
Menu, Tray, Icon, Plog.ico

T_DEF_DETAILS = Defect Details
T_COMMIT      = Commit

; Add the variable defined above into the group of windows to wait for
GroupAdd, waitOnThese, %T_DEF_DETAILS%
GroupAdd, waitOnThese, %T_COMMIT%
;-----------------------------
; END Customizable Values
;-----------------------------

Loop
{
   WinWaitActive, ahk_group waitOnThese

   IfWinActive, %T_DEF_DETAILS%
   {
      Run, DefectWindow.ahk

      WinWaitClose
      Continue
   }
   IfWinActive, %T_COMMIT%
   {
      Run, artifact_picker.ahk

      WinWaitClose
      Continue
   }
}
