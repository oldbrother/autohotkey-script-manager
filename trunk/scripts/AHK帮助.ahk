;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 一键启动AHK帮助文件，并检索剪切板中的内容
; 
; Alt + H: 在AHK帮助文件中查找剪切板内容
;
; gaochao.morgen@gmail.com
; 2014/2/4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Include ../lib/SystemCursor.ahk

#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoTrayIcon				; 不显示托盘图标
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

OnExit, ShowCursor		; 确保到脚本退出时鼠标光标是显示的.

; Alt + H
!h::
	IfWinExist, ahk_class HH Parent
	{
	    WinActivate  ; 自动使用上面找到的窗口.
	    WinMaximize  ; 同上
	}
	else
	{
		Run, "F:\编程与优化\AutoHotKey\AutoHotkey 1.1.chm",, Max
	}

	Sleep, 500
	Send !n				; Alt+N 切换到索引标签
	SystemCursor("Off")	; 隐藏鼠标，否则眼睛受不了
	MouseMove, 52, 150	; 输入框
	Send {LButton 2}	; 双击全选，准备替换
	Send ^v				; Ctrl+V 粘贴检索内容
	Send {Enter} 		; 回车确认检索
	MouseMove, 700, 400	; 到达文本正文
	SystemCursor("On")	; 恢复鼠标
Return

ShowCursor:
	SystemCursor("On")
ExitApp

