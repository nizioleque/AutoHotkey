#AutoIt3Wrapper_Icon=pin.ico

TraySetToolTip("Always on top")

Const $registryPath = "HKCU\SOFTWARE\bobi\always on top"

Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)

Const $trayItemHotkey = TrayCreateItem("Set hotkey")
Const $trayItemTransparency = TrayCreateItem("Set transparency")

TrayItemSetOnEvent($trayItemHotkey, "sethotkey")
TrayItemSetOnEvent($trayItemTransparency, "settransparency")

; Check if the registry key exists, set default values
RegRead($registryPath, "")
If @error = 1 Then
	initializeRegistry()
EndIf

; Set the hotkey according to the registry
HotKeySet(RegRead($registryPath, "hotkey"), "hotkey")

Func hotkey()
	Local $hwnd = WinGetHandle("[ACTIVE]")
	Local $windowLong = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -20)[0]

	If BitAND($windowLong, 0x00000008) <> 0x00000008 Then
		activate($hwnd)
	Else
		deactivate($hwnd)
	EndIf
EndFunc

; Make the window always on top and semi-transparent
Func activate($hwnd)
	Local $windowLong = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -20)[0]

	DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hwnd, "hwnd", -1, "int", 0, "int", 0, "int", 0, "int", 0, "uint", BitOR(0x0001, 0x0002))

	If BitAND($windowLong, 0x00080000) <> 0x00080000 Then
		DllCall("user32.dll", "bool", "SetWindowLong", "hwnd", $hwnd, "int", -20, "long", BitOR($windowLong, 0x00080000))
	EndIf

	WinWaitNotActive($hwnd)
	DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hwnd, "dword", Null, "byte", RegRead($registryPath, "transparency"), "dword", 0x00000002)
EndFunc

; Disable always on top and opacity
Func deactivate($hwnd)
	Local $windowLong = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -20)[0]

	DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hwnd, "hwnd", -2, "int", 0, "int", 0, "int", 0, "int", 0, "uint", BitOR(0x0001, 0x0002))
	DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hwnd, "dword", Null, "byte", 255, "dword", 0x00000002)
EndFunc

Func sethotkey()
	RegWrite($registryPath, "hotkey", "REG_SZ", InputBox("Set hotkey", "Input your preferred hotkey in AutoIT Send format:" & @CRLF & "+ means Shift" & @CRLF &"! means Alt"& @CRLF & "^ means Ctrl" & @CRLF &"# means Windows Key"& @CRLF & "Use lowercase letters"& @CRLF & "To use non-letter keys, refer to AutoIT Send key list", RegRead($registryPath, "hotkey"), " M", -1, 250))
	TrayItemSetState($trayItemHotkey, 4)
EndFunc

Func settransparency()
	RegWrite($registryPath, "transparency", "REG_DWORD", Number(InputBox("Set transparency", "Input your preferred transparency (0 - transparent, 255 - opaque)", RegRead($registryPath, "transparency"), " M")))
	TrayItemSetState($trayItemTransparency, 4)
EndFunc

Func initializeRegistry()
	RegWrite($registryPath)
	RegWrite($registryPath, "hotkey", "REG_SZ", "^q")
	RegWrite($registryPath, "transparency", "REG_DWORD", 200)
EndFunc


; Keep the script running and disable transparency when active
While True
	WinWaitNotActive(WinGetHandle("[ACTIVE]"))
	Local $hwnd = WinGetHandle("[ACTIVE]")
	Local $windowLong = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -20)[0]
	If Not BitAND($windowLong, 0x00000008) <> 0x00000008 Then
		DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hwnd, "dword", Null, "byte", 255, "dword", 0x00000002)
		WinWaitNotActive($hwnd)
		Local $windowLong = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "int", -20)[0]
		If Not BitAND($windowLong, 0x00000008) <> 0x00000008 Then
			DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hwnd, "dword", Null, "byte", RegRead($registryPath, "transparency"), "dword", 0x00000002)
		EndIf
	EndIf
WEnd