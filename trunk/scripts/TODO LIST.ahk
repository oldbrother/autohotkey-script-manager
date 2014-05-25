;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 在桌面显示TODO LIST
; 首次点击按钮更新TODO条目，再次点击按钮保存并显示为背景透明
; 
; 修改自Uberi的To-Do List / Reminders
; URL: http://www.autohotkey.com/board/topic/57455-to-do-list-reminders
;
; NOTE:
; 1. Edit控件设置为透明，则点击Edit控件区域会穿透控件，导致事件无法触发. 因此设置了按钮使Edit控件临时变得不透明，以便添加新条目
; 2. Edit控件为透明状态时，仍然可以修改TODO的值，但不能新增TODO条目
;
; gaochao.morgen@gmail.com
; 2014/5/24
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent
#SingleInstance Force
#NoTrayIcon
#NoEnv

SavePath = %A_ScriptDir%\..\config\TODO.config

WINDOW_X := 900		; 窗口起始X
WINDOW_Y := 230		; 窗口起始Y
WINDOW_W := 232		; 窗口宽度. 同时也是Edit控件宽度
WINDOW_H := 300 	; 窗口高度
BUTTON_H := 20		; Button控件高度
EDIT_H := 20		; Edit控件高度
CONTROL_SPACE := 3	; 控件垂直间距
BGCOLOR = 00FF00	; 背景颜色RGB

FieldCount := Round((WINDOW_H - BUTTON_H) / (EDIT_H + CONTROL_SPACE))	; TODO-LIST最大条目为FieldCount条

Changed := false	; 记录窗口是否激活
LastField = 0		; 记录最后一个显示出来的Edit控件索引

CoordMode, Mouse
Gui, -Caption +ToolWindow +LastFound
Gui, Margin, 0, 0

Gui, Color, %BGCOLOR%				; 窗口背景颜色
WinSet, Transparent, Off			; 窗口设置为不透明
WinSet, TransColor, %BGCOLOR% 255	; 让窗口中指定颜色的所有像素透明

Gui, Font, cRed S9, Arial
Gui, Add, Button, h%BUTTON_H% +0x8000 gBtClick, TODO LIST

; 添加所有Edit控件
Loop, %FieldCount%
{
	; 相对于窗口的坐标
	Coordinate := " x0"
	Coordinate .= " y" . (A_Index * (EDIT_H+CONTROL_SPACE))
	Coordinate .= " w" . WINDOW_W 
	Coordinate .= " h" . EDIT_H

	Style := Coordinate
	Style .= " Hidden -E0x200 +0x800000 " ; E0x200 = WS_EX_CLIENTEDGE; 0x800000 = WS_BORDER = Border
	Style .= " vField" . A_Index
	Style .= " HwndHwndField" . A_Index
	Gui, Add, Edit, %Style%

	Gui, Color,, %BGCOLOR%				; 控件背景颜色
	Gui +LastFound						; 刚刚创建的Edit控件
	WinSet, TransColor, %BGCOLOR% 255	; 控件设置为透明
}

Gui, Show, x%WINDOW_X% y%WINDOW_Y% w%WINDOW_W% h%WINDOW_H%, TODOLIST

SetFormat, Integer, Hex
OnMessage(0x111, "ClickedEdit")
Gosub, Load
Return

; 加载文件内容到TODO-LIST
Load:
	Critical				; 防止当前线程被其他线程中断
	SetFormat, Integer, D	; 运算结果为10进制

	IfNotExist, %SavePath%
	{
		AddNewField()
		GuiControl,, Field1, Note
		Return
	}

	FileRead, Temp1, %SavePath%

	if Temp1 = 
	{
		AddNewField()
		GuiControl,, Field1, Note
		Temp2 = 
		Return
	}
	else
	{
		; 配置文件的每行内容依次显示出来
		Loop, Parse, Temp1, `n, `r
		{
			if A_LoopField = 
				continue
			AddNewField()
			GuiControl,, Field%A_Index%, %A_LoopField%
		}
	}

	ClearEmptyFields()
Return

; 将TODO-LIST中的内容保存到文件
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
Return

; 修改TODOLIST的内容
; 首次点击时，Edit控件将处于激活状态，允许添加新的TODO
; 再次点击时，Edit控件将处于非激活状态(只是变透明了，实际上还是激活的)
BtClick:
	ClearEmptyFields()
	if (!Changed)
	{
		Gui, Color,, cDefault		; 设置控件背景颜色为默认值，使他们不再透明
		AddNewField()				; 加一行空行，以便添加新内容
	}
	else
	{
		ClearEmptyFields()
		Gui, Color,, %BGCOLOR%		; 设置控件背景颜色，使他们再次透明
		Gosub, Save
	}

	Changed := !Changed
Return

; 保存并退出程序
GuiClose:
	Gosub, Save
	ExitApp
Return

; 当窗口处于激活状态时，点击最后一个Edit控件将再产生一个新的Edit控件
ClickedEdit(wParam, lParam)
{
	global
	wParam := (wParam&0xFFFF0000) >> 16
	if wParam = 0x100
	{
		if (lParam = HwndField%LastField%)
			AddNewField()
	}
}

; 显示一个新的Edit控件
AddNewField()
{
	global
	SetFormat, Integer, D
	if LastField = %FieldCount%
		Return
	LastField ++
	GuiControl, Show, Field%LastField%
}

; 清空内容为空的Edit控件
ClearEmptyFields()
{
	global
	SetFormat, Integer, D
	if LastField = 1
		Return

	VisiableField := LastField

	; 处理到倒数第二行
	Loop, % VisiableField - 1
	{
		if A_Index = 1
			continue

		; 碰到一个空行，则把其后的所有TODO均向上移动一行
		GuiControlGet, Temp1,, Field%A_Index%
		if Temp1 = 
		{
			A_Index1 = %A_Index%
			Loop, % VisiableField - A_Index1
			{
				A_Index1 ++
				GuiControlGet, Temp1,, Field%A_Index1%
				GuiControl,, Field%A_Index1%
				GuiControl,, % "Field" . (A_Index1 - 1), %Temp1%
			}

			; 空行被移动到了最后一行，因此将最后一行隐藏
			GuiControl, Hide, Field%LastField%
			LastField --
		}
	}

	; 最后一行若为空行，则直接隐藏
	GuiControlGet, Temp1,, Field%LastField%
	if Temp1 = 
	{
		GuiControl, Hide, Field%LastField%
		LastField --
	}
}
