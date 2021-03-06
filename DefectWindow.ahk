#SingleInstance force

;-----------------------------
; Customizable Values
;-----------------------------
ASSIGNED_TO_VERSION:="WSAW1380"
PLANNED_CLOSING_VERSION=%ASSIGNED_TO_VERSION%.S2.L3.01 ; see sandy for this arbitrary made-up number!!
TARGET_TEST_CYCLE:="Sprint 2" ; Marketing's S14 is our WSAW1360.S3
RETURNED_STATUS:="Returned"
RETURNED_TEAM_ASSIGNED:="WSAW-SQA-Testing"
;-----------------------------
; END Customizable section
;-----------------------------

#Include QCDefectsLib.ahk

; Wait for the Defect Details dialog
WinWait, Defect Details, 
IfWinNotActive, Defect Details, , WinActivate, Defect Details, 
WinWaitActive, Defect Details, 

; create the GUI
Gui, +AlwaysOnTop
Gui, Add, Text,, Select an employee to`nreassign this defect to.
Gui, Add, ListBox, vlbEmpNums glbEmpNums r6 w200
Gui, Add, Text,, Planned Closing Version:
;Gui, Add, ListBox, vArtListBox gArtListBox r3 w150
Gui, Add, Edit, r1 vPlannedClosingVersion, %PLANNED_CLOSING_VERSION%
Gui, Add, Button, , Mark As Fixed
Gui, Add, Button, Default, Reassign
Gui, Add, Button, , Return It
Gui, Add, Button, , Close All

; populate employee numbers
Loop, read, EmpNums.txt
{
   GuiControl,, lbEmpNums, %A_LoopReadLine%        
}

WinGetPos, XPOS, YPOS, WIDTH, HEIGHT, Defect Details

XPOS := XPOS + WIDTH
HEIGHT := HEIGHT - 32

Gui, Show, x%XPOS% y%YPOS% w220 h%HEIGHT%, Defect Action

return

;---------------------------------------------------------------------------------------------------
; Dialog handlers
;---------------------------------------------------------------------------------------------------
lbEmpNums:
If A_GuiEvent <> DoubleClick
   return

;---------------------------------------------------------------------------------------------------
; Fall through - treat doubleclick as reassign
;---------------------------------------------------------------------------------------------------
ButtonReassign:
GuiControlGet, lbEmpNums ; retrieve the listbox's current selection

StringSplit, EmpData, lbEmpNums, %A_Tab%

SetTeamAssigned(EmpData3)
SetAssignedTo(EmpData2)

ClickOk()

ExitApp
return

;---------------------------------------------------------------------------------------------------
ButtonMarkAsFixed:
Gui, Submit
Run, AutoHotkey.exe FixDefect.ahk %PlannedClosingVersion% "%TARGET_TEST_CYCLE%" %ASSIGNED_TO_VERSION%
ExitApp
return

;---------------------------------------------------------------------------------------------------
; Handle return it button
;---------------------------------------------------------------------------------------------------
ButtonReturnIt:

SetDefectStatus(%RETURNED_STATUS%)
SetTeamAssigned(RETURNED_TEAM_ASSIGNED)

ClickOk()

ExitApp
return

;----------------
;----------------
ButtonCloseAll:

ClickOk()
ExitApp
return

;---------------------------------------------------------------------------------------------------
GuiClose:
GuiEscape:

BlockInput, Default

ExitApp
