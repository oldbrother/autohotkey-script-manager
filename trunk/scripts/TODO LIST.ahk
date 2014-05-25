;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 在桌面显示TODO LIST
; 修改自Uberi的To-Do List / Reminders
; URL: http://www.autohotkey.com/board/topic/57455-to-do-list-reminders
;
; gaochao.morgen@gmail.com
; 2014/5/24
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent
#SingleInstance Force
#NoTrayIcon
#NoEnv

WINDOW_X := 900		; 窗口起始X
WINDOW_Y := 230		; 窗口起始Y
WINDOW_W := 232		; 窗口宽度. 同时也是Edit控件宽度
WINDOW_H := 300 	; 窗口高度
TEXT_H := 20		; Text控件高度
EDIT_H := 20		; Edit控件高度
EDIT_SPACE := 5		; Edit控件间距
BGCOLOR = 00FF00	; 背景颜色. RGB

; Edit个数. 只能记录FieldCount条TODO
FieldCount := Round((WINDOW_H - TEXT_H) / (EDIT_H + EDIT_SPACE))
SavePath = %A_ScriptDir%\..\config\TODO.config

; 记录最后一个显示出来的Edit控件
LastField = 0

CoordMode, Mouse
Gui, -Caption +ToolWindow +LastFound
Gui, Margin, 0, 0
Gui, Color, %BGCOLOR%
WinSet, TransColor, %BGCOLOR%
Gui, Font, S9 CDefault, Arial

Gui, Add, Text, h%TEXT_H% cRed, TODO LIST

; 添加所有Edit控件
Loop, %FieldCount%
{
	Coordinate := " x0"
	Coordinate .= " y" . (((A_Index-1) * (EDIT_H+EDIT_SPACE)) + EDIT_H)
	Coordinate .= " w" . WINDOW_W 
	Coordinate .= " h" . EDIT_H

	Style := Coordinate
	Style .= " Hidden -E0x200 +0x800000 " ; E0x200 = WS_EX_CLIENTEDGE; 0x800000 = WS_BORDER = Border
	Style .= " vField" . A_Index
	Style .= " HwndHwndField" . A_Index
	Gui, Add, Edit, %Style%
}

Gui, Show, x%WINDOW_X% y%WINDOW_Y% w%WINDOW_W% h%WINDOW_H% NoActivate, TODOLIST

SetFormat, Integer, Hex
OnMessage(0x111, "ClickedEdit")
Gosub, Load
OnExit, Save
Return

Esc::
GuiClose:
ExitApp

Load:
	Critical
	SetFormat, Integer, D
	IfNotExist, %SavePath%
	{
		Loop, 2
			AddNewField()
		GuiControl,, Field1, Note
		Return
	}
	FileRead, Temp1, %SavePath%
	If Temp1 = 
	{
		Loop, 2
			AddNewField()
		GuiControl,, Field1, Note
		Temp2 = 
		Return
	}
	Else
	{
		Loop, Parse, Temp1, `n, `r
		{
			AddNewField()
			GuiControl,, Field%A_Index%, %A_LoopField%
		}
	}
	AddNewField()
	ClearEmptyFields()
Return

Save:
	Critical
	SetFormat, Integer, D
	Temp2 = 
	Loop, %LastField%
	{
		GuiControlGet, Temp1,, Field%A_Index%
		Temp2 .= Temp1 . "`n"
	}
	StringTrimRight, Temp2, Temp2, 1
	IfExist, %SavePath%
		FileDelete, %SavePath%
	FileAppend, %Temp2%, %SavePath%
	ExitApp
Return

HideFields()
{
	global LastField
	Loop, % LastField + 2
	{
		GuiControl, Move, % "Field" . A_Index - 2, x-250
		GuiControl, Move, % "Field" . A_Index - 1, x-100
		GuiControl, Move, Field%A_Index%, x-50
		Sleep, 30
	}
}

ShowFields()
{
	global LastField
	Loop, % LastField + 2
	{
		GuiControl, Move, % "Field" . A_Index - 2, x12
		GuiControl, Move, % "Field" . A_Index - 1, x-50
		GuiControl, Move, Field%A_Index%, x-100
		Sleep, 30
	}
}

ClickedEdit(Temp1,Temp2)
{
	global
	Temp1 := (Temp1&0xFFFF0000) >> 16
	If Temp1 = 0x100
	{
		If (Temp2 = HwndField%LastField%)
			AddNewField()
	}
	Else If Temp1 = 0x200
		ClearEmptyFields()
}

AddNewField()
{
	global
	SetFormat, Integer, D
	If LastField = %FieldCount%
		Return
	LastField ++
	GuiControl, Show, Field%LastField%
}

ClearEmptyFields()
{
	global
	SetFormat, Integer, D
	If LastField = 1
		Return
	Loop, % LastField - 1
	{
		If A_Index = 1
			Continue
		GuiControlGet, Temp1,, Field%A_Index%
		If Temp1 = 
		{
			A_Index1 = %A_Index%
			Loop, % LastField - A_Index1
			{
				A_Index1 ++
				GuiControlGet, Temp1,, Field%A_Index1%
				GuiControl,, Field%A_Index1%
				GuiControl,, % "Field" . (A_Index1 - 1), %Temp1%
			}
			GuiControl, Hide, Field%LastField%
			LastField --
		}
	}
}
