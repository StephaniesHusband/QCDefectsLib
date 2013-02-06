#SingleInstance force

;=============================================================================================================================
; Customizable Values Section
;=============================================================================================================================
; Set the appropriate app title
QC_TITLE                 = HP Application Lifecycle Management ; for stand-alone QC app
;QC_TITLE                = HP ALM - Quality Center 11.00       ; for browser QC app

ASSIGNED_TO_VERSION     := "WSAW1380"                       ; changes per release
PLANNED_CLOSING_VERSION  = %ASSIGNED_TO_VERSION%.HS.L6.02   ; changes per sprint/build
TARGET_TEST_CYCLE       := "Sprint 4"                       ; changes per sprint
DEFECT_PREFIX           := "QC-CD "


; How long to wait in between steps (in milliseconds)
STEP_SLEEP := 800

EMP_NUMS_FILENAME       := "empNums.txt"
ARTIFACTS_FILENAME      := "artifacts.txt"
HEIGHT=200
DEFAULT_ARTIFACT        := ""

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
POP_DEF_DETAILS         := "Defect Details"
POP_COMMIT              := "Commit"

; Defect Details dialog name
QC_DETAILS              := "Defect Details"

; Title of the Eclipse Commit dialog
;COMMIT_TITLE            := "Commit"

; Tab names in the Defect Details dialog
TAB_DET                 := "Details"
TAB_AINFO               := "Additional Info"
TAB_APP                 := "Approvals"
TAB_CINFO               := "Closing Info"
TAB_RES                 := "Resolution"
TAB_TCOM                := "Test Comments"

; QCDefectsLib icon.  Change this to whatever icon you want to use or comment it out for default AutoHotKey icon
Menu, Tray, Icon, Plog.ico

;=============================================================================================================================
; END Customizable Values Section
;=============================================================================================================================

;******************************************************************************************************************************
; BEGIN Main program body
;******************************************************************************************************************************

SetTitleMatchMode, 3

; Add the variable defined above into the group of windows to wait for
GroupAdd, waitOnThese, %POP_DEF_DETAILS%
GroupAdd, waitOnThese, %POP_COMMIT%

;-----------------------------
; END Customizable Values
;-----------------------------

Loop
{
   WinWaitActive, ahk_group waitOnThese

   IfWinActive, %POP_DEF_DETAILS%
   {
      LaunchDefectActionWindow()

      WinWaitClose, %POP_DEF_DETAILS%
      Continue
   }
   IfWinActive, %POP_COMMIT%
   {
      LaunchArtifactPicker()

      WinWaitClose, %POP_COMMIT%
      Continue
   }
}
;******************************************************************************************************************************

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
WaitFor(waitForMe)
{
   WinWait %waitForMe%
   IfWinNotActive %waitForMe%, , WinActivate, %waitForMe%, 
   WinWaitActive %waitForMe%, 
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
ClipDefectNumber()
{
   Global

   WaitFor(POP_DEF_DETAILS)

   ; double click to select all
   MouseClick, left, 90, 77, 2

   Sleep, STEP_SLEEP

   Return GetClipboard()
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
GoToTab(tabName)
{
   Global

   Local x = 0

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

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
ClickOk()
{
   WaitFor(POP_DEF_DETAILS)

   ; Alt-O
   SendInput, !o
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetAssignedTo(id)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_DET)
   SendInput, {TAB 10}
   SelectAll()
   SendInput, %id%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetTeamAssigned(team)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_DET)
   SendInput, {TAB 8}
   SelectAll()
   SendInput, %team%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetDefectStatus(status)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_DET)
   SendInput, {TAB 3}
   SelectAll()
   SendInput, %status%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetAssignedToVersion(ver)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_DET)
   SendInput, {TAB 20}
   SelectAll()
   SendInput, %ver%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetPlannedClosingVersion(ver)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_AINFO)
   SendInput, {TAB 13}
   SelectAll()
   SendInput, %ver%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetTargetTestCycle(cycle)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_AINFO)
   SendInput, {TAB 6}
   SelectAll()
   SendInput, %cycle%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetDefectType(type)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_CINFO)
   SendInput, {TAB 2}
   SelectAll()
   SendInput, %type%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetRootCauseTeam(team)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_CINFO)
   SendInput, {TAB 4}
   SelectAll()
   SendInput, %team%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
SetResolution(res)
{
   Global

   WaitFor(POP_DEF_DETAILS)
   GoToTab(TAB_RES)

   Sleep, STEP_SLEEP

   ; click in text area
   MouseClick, left,  500,  180

   SelectAll()
   SendInput, %res%
   Sleep, STEP_SLEEP
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
FindDefect(defectNum)
{
   Global

   WaitFor(%QC_TITLE%)

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
   Global

   ; Double-click to 
   Local d := ClipDefectNumber()

   ; formulate a string we can put in cvs comments
   Clipboard=%DEFECT_PREFIX%%d% 

   ; Details tab
   SetDefectStatus(FIXED_STATUS)
   SetAssignedToVersion(%atv%)

   ; Additional Info tab
   SetTargetTestCycle(ttc)
   SetPlannedClosingVersion(pcv)

   ; Closing Info tab
   SetDefectType(DEFECT_TYPE)
   SetRootCauseTeam(ROOT_CAUSE_TEAM)

   ; Resolution tab
   SetResolution(RESOLUTION)
}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
LaunchDefectActionWindow()
{
   Global

   ; Create the GUI
   Gui, +AlwaysOnTop
   Gui, Add, Text,, Select an employee to`nreassign this defect to.
   Gui, Add, ListBox, vlbEmpNums glbEmpNums r6 w200
   Gui, Add, Text,, Planned Closing Version:
   Gui, Add, Edit, r1 vPlannedClosingVersion, %PLANNED_CLOSING_VERSION%
   Gui, Add, Button, , Mark As Fixed
   Gui, Add, Button, Default, Reassign
   Gui, Add, Button, , Return It
   Gui, Add, Button, , Close All

   ; populate employee numbers
   Loop, read, EMP_NUMS_FILENAME
   {
      GuiControl,, lbEmpNums, %A_LoopReadLine%        
   }

   ; Get the size of the defect details dialog
   WinGetPos, XPOS, YPOS, WIDTH, HEIGHT, POP_DEF_DETAILS

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
      Gui, Destroy
      WaitFor(POP_DEF_DETAILS)

      FixDefect(PLANNED_CLOSING_VERSION, TARGET_TEST_CYCLE, ASSIGNED_TO_VERSION)
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

}

;-----------------------------------------------------------------------------------------------------------------------------
; Function
;-----------------------------------------------------------------------------------------------------------------------------
LaunchArtifactPicker()
{
   Global

   Gui, +AlwaysOnTop
   Gui, Add, Text,, Select artifact
   Gui, Add, ListBox, vlbArtifacts glbArtifacts r7 w400
   Gui, Add, Button, , Change
   Gui, Add, Button, , Exit

   Loop, read, %ARTIFACTS_FILENAME%
   {
      StringLeft, outL, A_LoopReadLine, 1
      If (outL != ";")
      {
         GuiControl,, lbArtifacts, %A_LoopReadLine%        
      }
   }

   ; Add an entry for any recently fixed defect
   If InStr(Clipboard, DEFECT_PREFIX)
   {
      GuiControl,, lbArtifacts, DEFECT%A_Tab%%clipboard%
   }

   GuiControl, ChooseString, lbArtifacts, %DEFAULT_ARTIFACT%

   Local X, Y, W, H

   ; Get the size of the defect details dialog
   WinGetPos, X,Y,W,H, %POP_COMMIT%

   ; Show the artifact picker window
   Gui, Show, x%X% y%Y% w%W% h%H%, Artifacts

   ; Gui gone, return from this function
   Return

   ;==================
   ; Gui Handlers
   ;==================

   ;---------------------------------------
   ; Artifacts listbox double click handler
   ;---------------------------------------
   lbArtifacts:
   If A_GuiEvent <> DoubleClick
      Return

   ;-------------------------------------------
   ; Fall through - treat doubleclick as Change
   ;-------------------------------------------
   ButtonChange:
      GuiControlGet, lbArtifacts ; retrieve the listbox's current selection
      StringSplit, ArtData, lbArtifacts, %A_Tab%
      Gui, Destroy

      WaitFor(POP_COMMIT)

      SelectAll()
      SendInput, %ArtData2%{SPACE}
   Return

   ;----------------------------------------------------------
   ; Handle the closing of the defect window or hitting escape
   ;----------------------------------------------------------
   ButtonExit:
      Gui, Destroy
      BlockInput, default
   Return
}

;----------------------------------------------------------
; Handle the closing of any launched window or hitting escape
;----------------------------------------------------------
GuiClose:
GuiEscape:
   Gui, Destroy
   BlockInput, default
Return

;=============================================================================================================================
; Utility Functions
;=============================================================================================================================

GetClipboard()
{
   Clipboard=
   SendInput, ^c
   ClipWait

   ; Trim off head/tail spaces
   id := RegExReplace(Clipboard, "^\s+|\s+$")
   Return id
}

SelectAll()
{
   SendInput, ^a
   Return
}

;=============================================================================================================================
; Hotkeys
;=============================================================================================================================

;---------------------------------------------------------------------------------------------------
; Find the selected number as a defect. Note: QC app must be open already.
;---------------------------------------------------------------------------------------------------
#d::
id := GetClipboard()
FindDefect(id)
Return
