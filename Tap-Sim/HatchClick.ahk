#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse, Screen

; -------- CONFIG --------
FarmX := -125        ; SET X
FarmY := 125         ; SET Y
ClickInterval := 10  ; ms
RobloxProcess := "RobloxPlayerBeta.exe"
; ------------------------

F6::  ; START
    ToolTip, CLICK FARM STARTED (Roblox Only)
    SetTimer, FarmLoop, %ClickInterval%
return

F8::  ; STOP
    ToolTip, CLICK FARM STOPPED
    SetTimer, FarmLoop, Off
return

FarmLoop:
    ; Check active window
    WinGet, ActiveProc, ProcessName, A
    if (ActiveProc != RobloxProcess)
    {
        ToolTip, PAUSED (Roblox Not Focused)
        return
    }

    ToolTip, FARMING...
    Click, %FarmX%, %FarmY%
return
