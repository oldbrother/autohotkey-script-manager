;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ARP缓存清理
; Bela Vista宾馆的无线网络设置可能有问题，100s左右自动掉线
; 通过该脚本每分钟清理一次ARP缓存，能够解决这个问题
;
; gaochao.morgen@gmail.com
; 2014/2/15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent				; 让脚本持久运行（即直到用户关闭或遇到 ExitApp）
#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoTrayIcon				; 不显示托盘图标
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

SetTimer, ArpDelete, 60000

ArpDelete:
	Run, cmd /c arp -d,, Hide
Return

