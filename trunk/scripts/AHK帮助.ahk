;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 一键启动AHK帮助文件，并检索剪切板中的内容
; 注意: 跟使用的AutoHotkey.chm有关系，不同版本的chm可能搜索框的classNN不同
; 我所使用的是: http://sourceforge.net/projects/ahkcn/
; 
; Alt + H: 在AHK帮助文件中查找剪切板内容
;
; gaochao.morgen@gmail.com
; 2014/2/4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoTrayIcon				; 不显示托盘图标
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

; Alt + H
!h::
	IfWinExist, ahk_class HH Parent {
	    WinActivate  ; 自动使用上面找到的窗口.
	    WinMaximize  ; 同上
	} else {
		Run, %ProgramFiles%\AutoHotkey\AutoHotkey.chm,, Max
	}

	Sleep, 500
	Send !n				; Alt+N 切换到索引标签
	ControlSetText, Edit1, %ClipBoard%, ahk_class HH Parent	; 设置搜索框内容
	Send {Enter} 		; 回车确认检索
Return

