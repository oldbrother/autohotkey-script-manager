;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 更改CMD的一些行为
; 
; gaochao.morgen@gmail.com
; 2014/2/4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent				; 让脚本持久运行（即直到用户关闭或遇到 ExitApp）
#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoTrayIcon				; 不显示托盘图标
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

; Ctrl + L, 仿Linux Term下Ctrl+L的清屏行为
#IfWinActive ahk_class ConsoleWindowClass
^l::
	SendInput {Raw}clear
	Send {Enter}
Return 

; Ctrl + V, 粘贴
#IfWinActive ahk_class ConsoleWindowClass
^v::
	Send %Clipboard%
Return 

