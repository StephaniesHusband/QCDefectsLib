#SingleInstance force

;-----------------------------
; Customizable Values
;-----------------------------
; Change this to whatever icon you want to use or comment it out for default AutoHotKey icon
Menu, Tray, Icon, Plog.icon

Global QC_TITLE   := "Defect Details"
;-----------------------------
; END Customizable Values
;-----------------------------

Loop
{
   ; Wait for the Defect Details dialog
   WinWaitActive, %QC_TITLE%, 

   ; Pop up the defectwindow
   Run, DefectWindow.ahk

   ; wait for it to close
   WinWaitClose, %QC_TITLE%

   ; do it again...
}
