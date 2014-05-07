;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Google双语翻译
; 
; gaochao.morgen@gmail.com
; 2014/5/5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#SingleInstance Force
#NoTrayIcon
#NoEnv

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        GUI                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 设置在没有为控件指定明确的位置时使用的边距/间隔
Gui, Margin, 0, 0

Gui, Add, Edit, x0 w200 vSource
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        热键                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	GoogleText := ByteToStr(WinHttpRequest(Url), "utf-8")
	NeedleRegEx = O)"(.*?)"
	FoundPos := RegExMatch(GoogleText, NeedleRegEx, OutMatch)
	ResultText := (! ErrorLevel) ? OutMatch.Value(1) : ""
	GuiControl,, Result, %ResultText%
	ClipBoard := ResultText
	SB_SetText("已复制", 1)
	SB_SetText(ResultText, 2)
Return
#IfWinActive

#IfWinActive ahk_class AutoHotkeyGUI
q::
Esc::
	Gosub, GuiClose
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
