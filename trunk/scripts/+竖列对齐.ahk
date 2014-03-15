;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 将文件按照竖列对齐，并且将TAB替换成空格
; 目前仅支持ANSI编码和UTF-8编码的文件
; 
; gaochao.morgen@gmail.com
; 2014/3/14
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#SingleInstance Force
#NoTrayIcon
#NoEnv

INFILE := 
AWKOUTFILE := A_WorkingDir . "\awktmp.txt"
SEDOUTFILE := A_WorkingDir . "\sedtmp.txt"
CURRENENCODING := "UTF-8"
FileEncoding, %CURRENENCODING%

Gui, Add, Button, x6 y7 w60 h20 gSetAnsi, ANSI
Gui, Add, Button, x86 y7 w60 h20 gSetUtf8, UTF-8
Gui, Add, Button, x506 y7 w60 h20 gAlignColumn, 对齐
Gui, Add, Edit, x6 y37 w560 h330 vMyEdit, Drag plain TXT file into this control
Gui, Add, StatusBar,, %CURRENENCODING%
Gui, Show,, 文本竖列对齐
Return

; 响应单个文件拖动事件
GuiDropFiles:	
    Loop, parse, A_GuiEvent, `n
    {
        INFILE := A_LoopField
		FileRead, FileContents, %A_LoopField%
		GuiControl,, MyEdit, %FileContents%
		Return
    }
Return

; 以ANSI编码打开
SetAnsi:
    CURRENENCODING := "ANSI"
	SB_SetText(CURRENENCODING)
	FileRead, FileContents, *P936 %INFILE%
	GuiControl,, MyEdit, %FileContents%
Return

; 以UTF-8编码打开
SetUtf8:
    CURRENENCODING := "UTF-8"
	SB_SetText(CURRENENCODING)
	FileRead, FileContents, *P65001 %INFILE%
	GuiControl,, MyEdit, %FileContents%
Return

; 对拖入的文件进行竖列对齐
AlignColumn:
    GAWK := "gawk -f "
    PATTERN := A_WorkingDir . "\..\3rd\alignColumn.awk"

    AWKCOMMAND := GAWK
    AWKCOMMAND .= """"
    AWKCOMMAND .= PATTERN
    AWKCOMMAND .= """"
    AWKCOMMAND .= " "
    AWKCOMMAND .= """"
    AWKCOMMAND .= INFILE
    AWKCOMMAND .= """"
    AWKCOMMAND .= " > """
	AWKCOMMAND .= AWKOUTFILE
	AWKCOMMAND .= """"

	; 竖列对齐
	RunWait, cmd /c %AWKCOMMAND%,, Hide

	SED := "sed -f "
	PATTERN := A_WorkingDir . "\..\3rd\trimtail.sed"

	SEDCOMMAND := SED
	SEDCOMMAND .= """"
	SEDCOMMAND .= PATTERN
	SEDCOMMAND .= """"
	SEDCOMMAND .= " "
	SEDCOMMAND .= """"
	SEDCOMMAND .= AWKOUTFILE
	SEDCOMMAND .= """"
	SEDCOMMAND .= " > """
	SEDCOMMAND .= SEDOUTFILE
	SEDCOMMAND .= """"

	; 消除行末空格
	RunWait, cmd /c %SEDCOMMAND%,, Hide

	; 打开处理后的文件
	If (CURRENENCODING = "UTF-8")
	    FileRead, FileContents, *P65001 %SEDOUTFILE%
	Else
	    FileRead, FileContents, *P936 %SEDOUTFILE%
	GuiControl,, MyEdit, %FileContents%
Return

GuiClose:
    FileDelete, %AWKOUTFILE%
    FileDelete, %SEDOUTFILE%
ExitApp

