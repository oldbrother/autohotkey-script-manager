;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 将文件按照竖列对齐，并且将TAB替换成空格
; 
; gaochao.morgen@gmail.com
; 2014/3/14
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#SingleInstance Force
#NoTrayIcon
#NoEnv

INFILE := 
OUTFILE := A_WorkingDir . "\tmp.txt"
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
    
    COMMAND := GAWK
    COMMAND .= """"
    COMMAND .= PATTERN
    COMMAND .= """"
    COMMAND .= " "
    COMMAND .= """"
    COMMAND .= INFILE
    COMMAND .= """ > """
	COMMAND .= OUTFILE
	COMMAND .= """"

	;MsgBox, % COMMAND
	RunWait, cmd /c %COMMAND%,, Hide
	If (CURRENENCODING = "UTF-8")
	    FileRead, FileContents, *P65001 %OUTFILE%
	Else
	    FileRead, FileContents, *P936 %OUTFILE%
	GuiControl,, MyEdit, %FileContents%
Return

GuiClose:
    FileDelete, %OUTFILE%
ExitApp

