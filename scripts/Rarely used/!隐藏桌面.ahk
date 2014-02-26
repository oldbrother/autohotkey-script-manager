;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 桌面图标隐藏
;
; gaochao.morgen@gmail.com
; 2014/1/19
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent				; 让脚本持久运行（即直到用户关闭或遇到 ExitApp）
#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoTrayIcon				; 不显示托盘图标
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

OnExit, ResumeDesktop	; 确保到脚本退出时显示桌面

HideDesktop()
Return

ResumeDesktop:
	ShowDesktop()
ExitApp

ShowDesktop()
{
	WinGetClass, Class, A
	Control, Show,, SysListView321, ahk_class Progman
	Control, Show,, SysListView321, ahk_class WorkerW
}

HideDesktop()
{
	WinGetClass, Class, A
	Control, Hide,, SysListView321, ahk_class Progman
	Control, Hide,, SysListView321, ahk_class WorkerW
}

