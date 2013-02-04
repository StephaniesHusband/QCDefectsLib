#SingleInstance force
#Include Utility.ahk

;=============================================================================================================================
; Customizable Values Section
;=============================================================================================================================
; Stand-alone QC app title = "HP Application Lifecycle Management"
; Browser QC app title = "HP ALM - Quality Center 11.00" (NOTE: could vary by browser)
QC_TITLE   := "HP Application Lifecycle Management"

ASSIGNED_TO_VERSION     := "WSAW1380"                       ; changes per release
PLANNED_CLOSING_VERSION  = %ASSIGNED_TO_VERSION%.HS.L6.01   ; changes per sprint/build
TARGET_TEST_CYCLE       := "Sprint 4"                       ; changes per sprint
DEFECT_PREFIX           := "QC-CD "

; How long to wait in between steps (in milliseconds)
STEP_SLEEP := 800

;------------------------------------------
; Customizable but, probably will not vary
;------------------------------------------

DEFECT_TYPE             := "Software:Code"
ROOT_CAUSE_TEAM         := "WSAW-Dev"
RETURNED_TEAM_ASSIGNED  := "WSAW-SQA-Testing"
FIXED_STATUS            := "Fixed"
RETURNED_STATUS         := "Returned"
RESOLUTION              := "UT:{SPACE}Y{RETURN}UT Passed:{SPACE}Y{RETURN}Cause:{SPACE}{RETURN}Resolution:{SPACE}"

; These are titles of windows that we need to take action on
POP_DEF_DETAILS         : = "Defect Details"
POP_COMMIT              : = "Commit"

; Defect Details dialog name
QC_DETAILS              : = POP_DEF_DETAILS

; Tab names in the Defect Details dialog
TAB_DET                 : = "Details"
TAB_AINFO               : = "Additional Info"
TAB_APP                 : = "Approvals"
TAB_CINFO               : = "Closing Info"
TAB_RES                 : = "Resolution"
TAB_TCOM                : = "Test Comments"

; QCDefectsLib icon.  Change this to whatever icon you want to use or comment it out for default AutoHotKey icon
Menu, Tray, Icon, Plog.ico

;=============================================================================================================================
; END Customizable Values Section
;=============================================================================================================================

;******************************************************************************************************************************
; BEGIN Main program body
;******************************************************************************************************************************

; Add the variable defined above into the group of windows to wait for
GroupAdd, waitOnThese, POP_DEF_DETAILS
GroupAdd, waitOnThese, POP_COMMIT

;-----------------------------
; END Customizable Values
;-----------------------------

Loop
{
   WinWaitActive, ahk_group waitOnThese

   IfWinActive, POP_DEF_DETAILS
   {
      LaunchDefectActionWindow()

      WinWaitClose
      Continue
   }
   IfWinActive, POP_COMMIT
   {
      Run, ArtifactPicker.ahk

      WinWaitClose
      Continue
   }
}
;******************************************************************************************************************************

WaitForQCMain()
{
   WinWait % QC_TITLE
   IfWinNotActive % QC_TITLE, , WinActivate, QC_TITLE, 
   WinWaitActive % QC_TITLE, 
}

WaitForDefectDlg()
{
   WinWait % QC_DETAILS
   IfWinNotActive % QC_DETAILS, , WinActivate, QC_DETAILS, 
   WinWaitActive % QC_DETAILS, 
}

ClipDefectNumber()
{
   WaitForDefectDlg()

   ; double click to select all
   MouseClick, left, 90, 77, 2

   Sleep, STEP_SLEEP

   Return GetClipboard()
}

GoToTab(tabName)
{
   x = 0

   If (tabName = TAB_DET)
      x = 195
   Else If (tabName = TAB_AINFO)
      x = 262
   Else If (tabName = TAB_APP)
      x = 338
   Else If (tabName = TAB_CINFO)
      x = 414
   Else If (tabName = TAB_RES)
      x = 494
   Else If (tabName = TAB_TCOM)
      x = 570

   MouseClick, left, x, 110
   Sleep STEP_SLEEP
}

ClickOk()
{
   WaitForDefectDlg()

   ; Alt-O
   SendInput, !o
}

SetAssignedTo(id)
{
   WaitForDefectDlg()
   GoToTab(TAB_DET)
   SendInput, {TAB 10}
   SelectAll()
   SendInput, %id%
   Sleep, STEP_SLEEP
}

SetTeamAssigned(team)
{
   WaitForDefectDlg()
   GoToTab(TAB_DET)
   SendInput, {TAB 8}
   SelectAll()
   SendInput, %team%
   Sleep, STEP_SLEEP
}

SetDefectStatus(status)
{
   WaitForDefectDlg()
   GoToTab(TAB_DET)
   SendInput, {TAB 3}
   SelectAll()
   SendInput, %status%
   Sleep, STEP_SLEEP
}

SetAssignedToVersion(ver)
{
   WaitForDefectDlg()
   GoToTab(TAB_DET)
   SendInput, {TAB 20}
   SelectAll()
   SendInput, %ver%
   Sleep, STEP_SLEEP
}

SetPlannedClosingVersion(ver)
{
   WaitForDefectDlg()
   GoToTab(TAB_AINFO)
   SendInput, {TAB 13}
   SelectAll()
   SendInput, %ver%
   Sleep, STEP_SLEEP
}

SetTargetTestCycle(cycle)
{
   WaitForDefectDlg()
   GoToTab(TAB_AINFO)
   SendInput, {TAB 6}
   SelectAll()
   SendInput, %cycle%
   Sleep, STEP_SLEEP
}

SetDefectType(type)
{
   WaitForDefectDlg()
   GoToTab(TAB_CINFO)
   SendInput, {TAB 2}
   SelectAll()
   SendInput, %type%
   Sleep, STEP_SLEEP
}

SetRootCauseTeam(team)
{
   WaitForDefectDlg()
   GoToTab(TAB_CINFO)
   SendInput, {TAB 4}
   SelectAll()
   SendInput, %team%
   Sleep, STEP_SLEEP
}

SetResolution(res)
{
   WaitForDefectDlg()
   GoToTab(TAB_RES)

   Sleep, STEP_SLEEP

   ; click in text area
   MouseClick, left,  500,  180

   SelectAll()
   SendInput, %res%
   Sleep, STEP_SLEEP
}

FindDefect(defectNum)
{
   WaitForQCMain()

   MouseClick, left, 106, 190
   Send, !g
   Sleep, STEP_SLEEP

   SendInput, %defectNum%{ENTER}
}

;----------------------------------------------------------------------------------------------------
; Function: FixDefect
;
; Parameters:
;  pcv   =  Planned closing Version (e.g., WSAW1380.S3.L3.01)
;  ttc   =  Target test cycle (e.g., Sprint 1)
;  atv   =  Assigned to version (e.g., WSAW1380)
;----------------------------------------------------------------------------------------------------
FixDefect(pcv, ttc, atv)
{
   ; Wait for the Defect Details dialog
   WaitForDefectDlg()

   ; Double-click to 
   d := ClipDefectNumber()

   ; formulate a string we can put in cvs comments
   clipboard=%DEFECT_PREFIX%%d% 

   ; Details tab
   SetDefectStatus(FIXED_STATUS)
   SetAssignedToVersion(%atv%)

   ; Additional Info tab
   SetTargetTestCycle(ttc)
   SetPlannedClosingVersion(%pcv%)

   ; Closing Info tab
   SetDefectType(DEFECT_TYPE)
   SetRootCauseTeam(ROOT_CAUSE_TEAM)

   ; Resolution tab
   SetResolution(RESOLUTION)
}

;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LaunchDefectActionWindow()
{
   ; Wait for the Defect Details dialog
   WinWait % QC_DETAILS
   IfWinNotActive % QC_DETAILS,, WinActivate, QC_DETAILS, 
   WinWaitActive % QC_DETAILS, 

   ; Create the GUI
   Gui, +AlwaysOnTop
   Gui, Add, Text,, Select an employee to`nreassign this defect to.
   Gui, Add, ListBox, vlbEmpNums glbEmpNums r6 w200
   Gui, Add, Text,, Planned Closing Version:
   Gui, Add, Edit, r1 vPlannedClosingVersion, PLANNED_CLOSING_VERSION
   Gui, Add, Button, , Mark As Fixed
   Gui, Add, Button, Default, Reassign
   Gui, Add, Button, , Return It
   Gui, Add, Button, , Close All

   ; populate employee numbers
   Loop, read, EmpNums.txt
   {
      GuiControl,, lbEmpNums, %A_LoopReadLine%        
   }

   ; Get the size of the defect details dialog
   WinGetPos, XPOS, YPOS, WIDTH, HEIGHT, QC_DETAILS

   ; Compute where and how big we want the defect window to be
   XPOS   := XPOS + WIDTH
   HEIGHT := HEIGHT - 32

   ; Show the defect action window
   Gui, Show, x%XPOS% y%YPOS% w220 h%HEIGHT%, Defect Action

   ; Gui gone, return from this function
   Return

   ;==================
   ; Gui Handlers
   ;==================

   ;-------------------------------------
   ; EmpNums listbox double click handler
   ;-------------------------------------
   lbEmpNums:
      If A_GuiEvent <> DoubleClick
         Return

   ;---------------------------------------------
   ; Fall through - treat doubleclick as reassign
   ;---------------------------------------------
   ButtonReassign:
      GuiControlGet, lbEmpNums ; retrieve the listbox's current selection

      StringSplit, EmpData, lbEmpNums, %A_Tab%

      SetTeamAssigned(EmpData3)
      SetAssignedTo(EmpData2)

      ClickOk()
   Return

   ;----------------------
   ; Mark As Fixed handler
   ;----------------------
   ButtonMarkAsFixed:
      Gui, Submit
      FixDefect(PLANNED_CLOSING_VERSION, TARGET_TEST_CYCLE, ASSIGNED_TO_VERSION)
      Gui, Destroy
   Return

   ;---------------
   ; Return handler
   ;---------------
   ButtonReturnIt:
      SetDefectStatus(%RETURNED_STATUS%)
      SetTeamAssigned(RETURNED_TEAM_ASSIGNED)
      ClickOk()
      Gui, Destroy
   Return

   ;------------------
   ; Close all handler
   ;------------------
   ButtonCloseAll:
      ClickOk()
   Return

   ;----------------------------------------------------------
   ; Handle the closing of the defect window or hitting escape
   ;----------------------------------------------------------
   GuiClose:
   GuiEscape:
      Gui, Destroy
      BlockInput, default
   Return
}
