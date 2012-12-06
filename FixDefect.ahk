;-----------------------------
; Customizable Values
;-----------------------------
PLANNED_CLOSING_VERSION=%1%
TARGET_TEST_CYCLE=%2%
ASSIGNED_TO_VERSION:="WSAW1360"
STATUS:="Fixed"
DEFECT_TYPE:="Software:Code"
ROOT_CAUSE_TEAM:="WSAW-Dev"
RESOLUTION:="UT:{SPACE}Y{RETURN}UT Passed:{SPACE}Y{RETURN}Cause:{SPACE}{RETURN}Resolution:{SPACE}"
;-----------------------------
; END Customizable section
;-----------------------------

; Should be in same folder as this script
#Include QCDefectsLib.ahk

BlockInput, SendAndMouse

; Wait for the Defect Details dialog
WaitForDefectDlg()

; Double-click to 
d := ClipDefectNumber()

; formulate a string we can put in cvs comments
clipboard=QC-CD %d% - 

; Details tab
SetDefectStatus(STATUS)
SetAssignedToVersion(ASSIGNED_TO_VERSION)

; Additional Info tab
SetTargetTestCycle(TARGET_TEST_CYCLE)
SetPlannedClosingVersion(PLANNED_CLOSING_VERSION)

; Closing Info tab
SetDefectType(DEFECT_TYPE)
SetRootCauseTeam(ROOT_CAUSE_TEAM)

; Resolution tab
SetResolution(RESOLUTION)
