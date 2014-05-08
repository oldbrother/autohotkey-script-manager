;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Google中译英，英译汉
; 能自动识别中英文
; 
; Enter: 翻译
; Ctrl + Enter: 文本换行
; F1: 朗读
;
; gaochao.morgen@gmail.com
; 2014/5/5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Include ../lib/Anchor.ahk

#SingleInstance Force
#NoTrayIcon
#NoEnv

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        GUI                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 允许调整窗口大小
Gui, +Resize

; 设置在没有为控件指定明确的位置时使用的边距/间隔
Gui, Margin, 0, 0

Gui, Add, Edit, x0 w200 +Multi vSource
GuiControl,, Source, %ClipBoard%
Gui, Add, StatusBar
SB_SetParts(50)
Gui, Show,, Google翻译
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                      主画面响应                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GuiClose:
	ExitApp
Return

GuiSize:
	DllCall("QueryPerformanceCounter", "Int64P", t0)
	; 控件Source自动跟随窗口大小
	Anchor("Source", "wh")
	DllCall("QueryPerformanceCounter", "Int64P", t1)
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        热键                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 回车进行查询
#IfWinActive ahk_class AutoHotkeyGUI
Enter::
	Gui, Submit, Nohide
	SB_SetText("", 1)
	SB_SetText("", 2)

	; 判断中译英还是英译中
	pos := RegExMatch(Source, "[a-zA-Z]+")
	if (ErrorLevel = 0 && pos > 0)
		Url = http://translate.google.com.hk/translate_a/t?client=t&text=%Source%&sl=en&tl=zh-CN
	else
		Url = http://translate.google.com.hk/translate_a/t?client=t&text=%Source%&sl=zh-CN&tl=en

	SB_SetText("正在翻译", 1)
	Ret := WinHttpRequest(Url)
	GoogleText := ByteToStr(Ret, "utf-8")
	; BUG 这个模式只能返回第一段的结果
	NeedleRegEx = O)"(.*?)"
	FoundPos := RegExMatch(GoogleText, NeedleRegEx, OutMatch)
	ResultText := (! ErrorLevel) ? OutMatch.Value(1) : ""
	GuiControl,, Result, %ResultText%
	ClipBoard := ResultText
	SB_SetText("已复制", 1)
	SB_SetText(ResultText, 2)
Return
#IfWinActive

; Ctrl + Enter 代替平时的回车，用于换行
#IfWinActive ahk_class AutoHotkeyGUI
^Enter::
	Send {`r}
Return
#IfWinActive

#IfWinActive ahk_class AutoHotkeyGUI
Esc::
	Gosub, GuiClose
Return
#IfWinActive

#IfWinActive ahk_class AutoHotkeyGUI
F1::
	TTSPlay(ClipBoard)
Return
#IfWinActive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                       函数                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 请求网页，返回结果
WinHttpRequest(HttpUrl)
{
	XMLHTTP := ComObjCreate("Microsoft.XMLHTTP")
	XMLHTTP.open("GET", HttpUrl, false)
	XMLHTTP.setRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0")
	XMLHTTP.send()

	Return XMLHTTP.ResponseBody
}

; 将原始数据流以指定的编码的形式读出
ByteToStr(body, charset)
{
	Stream := ComObjCreate("Adodb.Stream")
	Stream.Type := 1
	Stream.Mode := 3
	Stream.Open()
	Stream.Write(body)
	Stream.Position := 0
	Stream.Type := 2
	Stream.Charset := charset
	str := Stream.ReadText()
	Stream.Close()

	Return str
}

; Google语音引擎
TTSPlay(String = "")
{
	; 仅朗读英文
	pos := RegExMatch(String, "[a-zA-Z]+")
	if !(ErrorLevel = 0 && pos > 0)
		Return 0

	if StrLen(String) > 100
	{
	   Msgbox, 16,, String too long, a maximum of 100 characters!
	   Return 0
	}

	global tts_Thread
	tts_Thread := ComObjCreate("WMPlayer.OCX")
	tts_Thread.settings.volume := 100
	tts_Thread.url := "http://translate.google.com/translate_tts?q=" . String . "&tl=EN"
	Return 1
}
