#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse, Screen

; -------- CONFIG --------

; Collect button position
CollectX := -300
CollectY := 450

; Claim button position
ClaimX := -420
ClaimY := 500

ExitX := -165
ExitY := 150

; Fast click position
FarmX := -420
FarmY := 560

FastClickInterval := 10          ; ms per click

RobloxProcess := "RobloxPlayerBeta.exe"

; ------------------------


F6::  ; START
    ToolTip, TOKEN FARM STARTED (F8 TO STOP)
    Gosub, MainLoop
return

F8::  ; STOP
    ToolTip, TOKEN FARM STOPPED
	ExitApp
return


MainLoop:
    ; ---- ENSURE ROBLOX IS ACTIVE ----
    WinActivate, ahk_exe %RobloxProcess%
    WinWaitActive, ahk_exe %RobloxProcess%,, 2

    ; ---- CLICK COLLECT ----
    Click, %CollectX%, %CollectY%
    Sleep, 800

    ; ---- CLICK CLAIM ----
    Click, %ClaimX%, %ClaimY%
    Sleep, 800
	
	Click, %ExitX%, %ExitY%
    Sleep, 800

    ; ---- PRESS SPACE (JUMP) PROPERLY ----
    SendInput, {Space down}
    Sleep, 60
    SendInput, {Space up}
    Sleep, 120
	
	SendInput, {Space down}
    Sleep, 60
    SendInput, {Space up}
    Sleep, 120

    SendInput, {Space down}
    Sleep, 60
    SendInput, {Space up}
    Sleep, 300

	; ---- CALCULATE NEXT 4-HOUR BOUNDARY (GMT+8 LOCAL) ----
    FormatTime, HourNow,, HH
    NextHour := Ceil((HourNow + 0.001) / 4) * 4
    if (NextHour >= 24)
        NextHour := 0

    EndTime := SubStr(A_Now, 1, 8) . Format("{:02}", NextHour) . "0000"
    if (EndTime <= A_Now)
        EndTime += 1, Days

    ; ---- FAST CLICK FOR 4 HOURS ----
    while (A_Now < EndTime)
    {
        MouseGetPos,,, WinID
        WinGet, ProcName, ProcessName, ahk_id %WinID%

        if (ProcName != RobloxProcess)
        {
            ToolTip, FARM PAUSED (Mouse Outside Roblox)
            Sleep, 100
            continue
        }

        ToolTip, FARMING...
        Click, %FarmX%, %FarmY%
        Sleep, %FastClickInterval%
    }
	
	; ---- 🔔 4-HOUR RESET ALERT ----
	ToolTip, 4-HOUR CYCLE COMPLETE
    SoundBeep, 1500, 300
    Sleep, 200
    SoundBeep, 1800, 300

    ; ---- REPEAT ----
    Gosub, MainLoop
return
