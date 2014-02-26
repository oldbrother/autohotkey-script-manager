;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 快速打开预存的几个网页
;
; gaochao.morgen@gmail.com
; 2014/1/20
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#SingleInstance Force	; 跳过对话框并自动替换旧实例
#NoEnv					; 不检查空变量是否为环境变量（建议所有新脚本使用）

navigator := "C:\Program Files\Mozilla Firefox\firefox.exe"

Index := Object()
Index.Insert("sh000001")	; 上证综指
Index.Insert("sz399006")	; 创业板指

for index, element in Index
{
	URL := "http://finance.sina.com.cn/realstock/company/"
	URL .= element
	URL .= "/nc.shtml"

	CMD := navigator
	CMD .= " "
	CMD .= URL
	Run, %CMD%
}

;Fund := Object()
;Fund.Insert("260116")	; 景顺核心
;Fund.Insert("630005")	; 华商动态
;
;for index, element in Fund
;{
;	URL := "http://finance.sina.com.cn/fund/quotes/"
;	URL .= element
;	URL .= "/bc.shtml"
;
;	CMD := navigator
;	CMD .= " "
;	CMD .= URL
;	Run, %CMD%
;}

