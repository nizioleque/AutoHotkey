#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

; Send +{F13}

x := 0
y := 0
currX := 0
currY := 0

Menu, Tray, Standard
Menu, Tray, Add
Menu, Tray, Add, Press hotkey (configuration), config
Menu, Tray, Tip, MX Master Gesture AltTab
return



+F13::
    Send, !^{Tab}

    x:=(A_ScreenWidth // 2)
    y:=(A_ScreenHeight // 2)

    ; move mouse to the middle of the screen
    CoordMode, Mouse, Screen
    MouseMove, x, y, 0
return

+F13 Up::
    MouseGetPos, currX, currY
    if (currX = x and currY = y) {
        ; no mouse movement -> next window
        Send {Enter}
    }
    else {
        ; mouse movement -> click selected window
        Click
        WinGetActiveStats, Title, Width, Height, X, Y
        CoordMode, Mouse, Relative
        MouseMove, Width / 2, Height / 2, 0
    }
return

config:
    ; send hotkey for configuration
    MsgBox, Open Logitech Options -> Gesture Button -> Keystroke Assignment -> (Click here). Click OK and switch to Logitech Options in 3 seconds.
    Sleep, 3000
	Send, +{F13}
return
