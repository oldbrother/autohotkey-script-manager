;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 一键锁屏并让屏幕关闭，节约用电
; 
; gaochao.morgen@gmail.com
; 2014/2/4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoTrayIcon				; 不显示托盘图标
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

; Lock Screen. 模拟Win+L没有成功，执行后Win似乎一直处于按下状态
Run, %A_WinDir%\System32\rundll32.exe user32.dll LockWorkStation 

; Power off the screen
; 0x112: WM_SYSCOMMAND
; 0xF170: SC_MONITORPOWER
; 2: the display is being shut off
SendMessage, 0x112, 0xF170, 2,, Program Manager

ExitApp

