#AutoIt3Wrapper_Icon=note.ico

TraySetToolTip("Music hotkeys")

Local $hotKeys[] = ["{HOME}",	"{END}",	"{PGUP}",	"{PGDN}"]

HotKeySet("!{HOME}", "enableHotkeys")

Const $dblTime = 125	;The amount of time to wait until singleClick() is triggered (in milliseconds)
Const $dblSleep = 20	;The frequency of checking whether the 2nd click occured (in milliseconds)

Local $pressed[] ; Map for storing pressed state

; Set hotkeys and initialize the map
enableHotkeys()



Func homeClick($double = 0)
	If $double = True Then
		SendX("{HOME}")
	Else
		Send("{MEDIA_PLAY_PAUSE}")
	EndIf
EndFunc

Func endClick($double = 0)
	If $double = True Then
		SendX("{END}")
	Else
		Send("{MEDIA_PREV}")
	EndIf
EndFunc

Func pgupClick($double = 0)
	If $double = True Then
		SendX("{PGUP}")
	Else
		Send("{MEDIA_NEXT}")
	EndIf
EndFunc

Func pgdnClick($double = 0)
	If $double = True Then
		SendX("{PGDN}")
	Else
		disableHotkeys()
	EndIf
EndFunc


; Handler functions

Func HotKeyHandler()

	$hotkey = @HotKeyPressed

	If $pressed[$hotkey] = 0 Then
		$pressed[$hotkey] = 1
		For $i = 1 To $dblTime/$dblSleep
			Sleep($dblSleep)
			If $pressed[$hotkey] = 2 Then
				Call(StringReplace(StringReplace($hotkey, "{", ""), "}", "") & "Click", 1)
				$pressed[$hotkey] = 0
				Return
			EndIf
		Next
		Call(StringReplace(StringReplace($hotkey, "{", ""), "}", "") & "Click")
		$pressed[$hotkey] = 0
	ElseIf $pressed[$hotkey] = 1 Then
		$pressed[$hotkey] = 2
	EndIf
EndFunc

Func SendX($hotkey)
	HotKeySet($hotkey)
	Send($hotkey)
	HotKeySet($hotkey, "HotKeyHandler")
EndFunc

Func enableHotkeys()
	For $hotKey in $hotKeys
		$pressed[$hotkey] = 0
		HotKeySet($hotkey, "HotKeyHandler")
	Next
EndFunc

Func disableHotkeys()
	For $hotKey in $hotKeys
		$pressed[$hotkey] = 0
		HotKeySet($hotkey)
	Next
EndFunc

; Keep the script running
While True
	Sleep(100)
WEnd
