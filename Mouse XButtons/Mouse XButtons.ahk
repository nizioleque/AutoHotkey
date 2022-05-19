#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

XButton1::Gosub, TabBack
XButton2::Gosub, TabForw

RButton Up::Gosub, RButUpHandler
RButton::Gosub, RButDownHandler

~RButton & XButton1::Gosub, WindowBack
~RButton & XButton2::Gosub, WindowForw

TabBack:
	WinGetTitle, Title, A
	If (Title = "Messenger")
	{
		Send !{Down}
	}
	Else
	{
		Send ^+{Tab}
	}
return

TabForw:
	WinGetTitle, Title, A
	If (Title = "Messenger")
	{
		Send !{Up}
	}
	Else
	{
		Send ^{Tab}
	}
return

WindowBack:
	SetTimer, RButDownTrigger, Off
	Send {Alt down}+{Tab}
return

WindowForw:
	SetTimer, RButDownTrigger, Off
	Send {Alt down}{Tab}
return

RButUpHandler:
	SetTimer, RButDownTrigger, Off
 	If GetKeyState("Alt")
 	{
 		Send {Alt up}
	}
	Else
	{
		Click, right
	}
return

RButDownHandler:
	SetTimer, RButDownTrigger, -1000
return

RButDownTrigger:
	Click, down, right
return