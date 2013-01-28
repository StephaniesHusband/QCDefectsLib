;-----------------------------
; Customizable Values
;-----------------------------
; Stand-alone QC app title = "HP Application Lifecycle Management"
; Browser QC app title = "HP ALM - Quality Center 11.00" (NOTE: could vary by browser)
Global QC_TITLE   := "HP Application Lifecycle Management"

; How long to wait in between steps (in milliseconds)
Global STEP_SLEEP := 800

; Defect Details dialog name (should not vary)
Global QC_DETAILS := "Defect Details"

; Tab names in the Defect Details dialog (should not vary)
Global TAB_DET    := "Details"
Global TAB_AINFO  := "Additional Info"
Global TAB_APP    := "Approvals"
Global TAB_CINFO  := "Closing Info"
Global TAB_RES    := "Resolution"
Global TAB_TCOM   := "Test Comments"
;-----------------------------
; END Customizable section
;-----------------------------

#Include Utility.ahk

WaitForQCMain()
{
   WinWait, %QC_TITLE%
   IfWinNotActive, %QC_TITLE%, , WinActivate, %QC_TITLE%, 
   WinWaitActive, %QC_TITLE%, 
}

WaitForDefectDlg()
{
   WinWait, %QC_DETAILS%
   IfWinNotActive, %QC_DETAILS%, , WinActivate, %QC_DETAILS%, 
   WinWaitActive, %QC_DETAILS%, 
}

ClipDefectNumber()
{
   WaitForDefectDlg()

   ; double click to select all
   MouseClick, left, 90, 77, 2

   Sleep, STEP_SLEEP

   Return GetClipboard()
}

; Click on the Details tab
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
