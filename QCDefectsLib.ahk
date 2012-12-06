;-----------------------------
; Customizable Values
;-----------------------------
Global QC_TITLE   := "Defect Details"
Global STEP_SLEEP := 800

Global TAB_DET   := "Details"
Global TAB_AINFO := "Additional Info"
Global TAB_APP   := "Approvals"
Global TAB_CINFO := "Closing Info"
Global TAB_RES   := "Resolution"
Global TAB_TCOM  := "Test Comments"

Global QC_TITLE := "HP Application Lifecycle Management"

;-----------------------------
; END Customizable section
;-----------------------------

#Include Utility.ahk

WaitForQCMain()
{
   title := "HP Application Lifecycle Management"
   WinWait, %title%
   IfWinNotActive, %title%, , WinActivate, %title%, 
   WinWaitActive, %title%, 
}

FindDefect(defect)
{
   WaitForQCMain()
   MouseClick, left, 106, 190
   Send, !g
   Sleep, 500

   SendInput, %defect%{ENTER}
}

WaitForDefectDlg()
{
   WinWait, %QC_TITLE%
   IfWinNotActive, %QC_TITLE%, , WinActivate, %QC_TITLE%, 
   WinWaitActive, %QC_TITLE%, 
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
