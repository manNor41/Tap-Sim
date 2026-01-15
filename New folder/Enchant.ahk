#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; -------- CONFIG --------
SpinX := -405  ;<--Change this 
SpinY := 445   ;<--Change this

FastX := -90   ;<--Change this 
FastY := 90   ;<--Change this

ClickDelay := 9000
FastClickDuration := 8500
FastClickInterval := 10
ImageTolerance := 50

RobloxProcess := "RobloxPlayerBeta.exe"

EnchantImages := []
EnchantImages.Push({name: "SECRET",  file: "secret.png"})
EnchantImages.Push({name: "GOLDEN",  file: "golden.png"})
EnchantImages.Push({name: "RAINBOW", file: "rainbow.png"})
; ------------------------


F6::
    ToolTip, AUTO SPIN ON (F8 = STOP)
    SetTimer, SpinLoop, %ClickDelay%
return

F8::
    ToolTip, AUTO SPIN OFF
    SetTimer, SpinLoop, Off
return


SpinLoop:
	; ===== PAUSE IF ROBLOX NOT FOCUSED =====
    WinGet, ActiveProc, ProcessName, A
    if (ActiveProc != RobloxProcess)
    {
        ToolTip, PAUSED (Roblox Not Focused)
        return
    }
	
    ; ===== CHECK FIRST =====
    for index, enchant in EnchantImages
    {
        ImagePath := A_ScriptDir "\" enchant.file
        ImageSearch, fx, fy, 0, 0, A_ScreenWidth, A_ScreenHeight, *%ImageTolerance% %ImagePath%
        if (ErrorLevel = 0)
        {
            ToolTip, % enchant.name " ENCHANT FOUND"
            SoundBeep, 1200, 300
            SetTimer, SpinLoop, Off
            return
        }
    }

    ; ===== CLICK SPIN =====
    Click, %SpinX%, %SpinY%

    ; ===== FAST CLICK WINDOW =====
    StartTime := A_TickCount
    while (A_TickCount - StartTime < FastClickDuration)
    {
		; pause mid-window if Roblox loses focus
        WinGet, ActiveProc, ProcessName, A
        if (ActiveProc != RobloxProcess)
        {
            ToolTip, PAUSED (Roblox Not Focused)
            Sleep, 100
            continue
        }
		
        Click, %FastX%, %FastY%
        Sleep, %FastClickInterval%
    }
return
