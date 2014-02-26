; Ctrl + 1 2 3 分别复制
; Alt + 1 2 3 分别粘贴

#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoTrayIcon				; 不显示托盘图标
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;             复制              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^1::
send ^c
a = %Clipboard%
Return

^2::
send ^c
b = %Clipboard%
Return

^3::
send ^c
c = %Clipboard%
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;             粘贴              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!1::
Clipboard = %a%
send ^v
Return

!2::
Clipboard = %b%
send ^v
Return

!3::
Clipboard = %c%
send ^v
Return

