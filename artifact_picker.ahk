#SingleInstance force

;-----------------------------
; Customizable Values
;-----------------------------
ARTIFACTS_FILENAME=artifacts.txt ; needs to be in same directory as this script
COMMIT_TITLE=Commit
HEIGHT=200
LISTBOX_WIDTH=400
DEFAULT=
;-----------------------------
; END Customizable section
;-----------------------------

; Wait for the Defect Details dialog
WinWait, %COMMIT_TITLE%
IfWinNotActive, %COMMIT_TITLE%, , WinActivate, %COMMIT_TITLE%
WinWaitActive, %COMMIT_TITLE%, 

Gui, +AlwaysOnTop
Gui, Add, Text,, Select artifact if different than default
Gui, Add, ListBox, vMyListBox gMylistBox r7 w%LISTBOX_WIDTH%
Gui, Add, Button, , Change
Gui, Add, Button, , Exit

Loop, read, %ARTIFACTS_FILENAME%
{
   StringLeft, outL, A_LoopReadLine, 1
   If (outL != ";")
   {
      GuiControl,, MyListBox, %A_LoopReadLine%        
   }
}

StringLeft, cb, clipboard, 5
If (cb = "QC-CD")
{
   GuiControl,, MyListBox, -- Defect -----------------
   GuiControl,, MyListbox, DEFECT%A_Tab%%clipboard%
}


GuiControl, ChooseString, MyListBox, %DEFAULT%

WinGetPos,XPOS,YPOS,WIDTH,,%COMMIT_TITLE% 

YPOS := YPOS - Round(HEIGHT/2)
WIDTH := LISTBOX_WIDTH + 20

Gui, Show, x%XPOS% y%YPOS% w%WIDTH% h%HEIGHT%, Artifact

WinWaitClose, %COMMIT_TITLE% 
ExitApp

return

;---------------------------------------------------------------------------------------------------
; Dialog handler
;---------------------------------------------------------------------------------------------------
MyListBox:
If A_GuiEvent <> DoubleClick
   return

;---------------------------------------------------------------------------------------------------
ButtonChange:
GuiControlGet, MyListBox ; retrieve the listbox's current selection
StringSplit, ArtData, MyListBox, %A_Tab%

Gui, Submit
WinWait, %COMMIT_TITLE%
IfWinNotActive, %COMMIT_TITLE%, , WinActivate, %COMMIT_TITLE%
WinWaitActive, %COMMIT_TITLE%, 
Send, ^a%ArtData2%{SPACE}
ExitApp
return

ButtonExit:
ExitApp
return

;---------------------------------------------------------------------------------------------------
GuiClose:
GuiEscape:

BlockInput, Default

ExitApp
