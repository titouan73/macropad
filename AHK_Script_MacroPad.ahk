/*
Numpad AutoHotKey Script
Author : M1tch

à déposer dans le dossier 
C:\Users\<user>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
si on veut le lancer au démarrage
*/

; Media Keys 
NumpadEnter & Numpad8:: Send "{Media_Prev}"
NumpadEnter & Numpad9:: Send "{Media_Play_Pause}"
NumpadEnter & NumpadSub:: Send "{Media_Next}"

; Volume Keys
NumpadEnter & NumpadDiv:: Send "{Volume_Down}"
NumpadEnter & NumpadMult:: Send "{Volume_Mute}"
;Enter + backspace = toggle all windows
NumpadEnter & BackSpace:: Send "{Volume_Up}"

;Enter + backspace = toggle all windows
NumpadEnter & NumpadDot:: Send "#d"

; Arrow keys
Numpad8:: Send "{Up}"
Numpad6:: Send "{Right}"
Numpad5:: Send "{Down}"
Numpad4:: Send "{Left}"

; Home and End keys (next to the arrows)
Numpad7:: Send "{Home}"
Numpad9:: Send "{End}"

; Reassign Enter key
NumpadEnter:: Send "{Enter}"

; Lock Key
NumpadDiv:: {
    DllCall("LockWorkStation")
    }

;Some emojis 😂😏🙈🥰

Numpad0::{
    Send "😂"
}

Numpad1::Send "🙈"
Numpad2::Send "😏"
Numpad3::Send "🥰"
NumpadDot::Send "😢"

; Assigner une combinaison de touches à un emoji
^#a::{ ; Ctrl + Win + A
Send "😂"
}

^#b::{ ; 
Send "🙈"
}

^#c::{ ; 
Send "😏"
}

^#d::{ ; 
Send "🥰"
}

^#e::{ ; 
Send "😢"
}

^#f::{ ; 
Send "✋👀🤚"
}

^#g::{ ; 
Send "🙄"
}

^#h::{ ; 
Send "😭"
}

^#i::{ ; 
Send "😅"
}


;CS2

^#j::{ ; 
Send "¯\_(ツ)_/¯"
}
^#k::{ ; 
Send "( -_•)▄︻テحكـ━一"
}
^#l::{ ; 
Send "( ͡° ͜ʖ ͡°)"
}
^#m::{ ; 
Send "(╯°□°）╯︵ ┻━┻"
}
^#n::{ ; 
Send "ᕦ(ò_óˇ)ᕤ"
}
^#o::{ ; 
Send "(⊙ _ ⊙ )"
}
^#p::{ ; 
Send "UwU🥺👉👈"
}
^#q::{ ; 
Send "🇫🇷⚜️ BAGUETTE"
}
^#r::{ ; 
Send "если ты можешь это прочитать, то ты дерьмо"
}


#s::
{
    Run "..\minuterieVeille\minuterieVeille.bat"
}

#enter::
{
    Run "PowerShell -ExecutionPolicy Bypass -File ..\audioSwitcher\audioSwitcher.ps1"
}

/*
NumpadSub::
{
    DetectHiddenWindows false
    Page := WinGetTitle("Réseaux")
    WinActivate Page
    MsgBox "The text is:`n" WinGetTitle(Page)
    
}
*/





; Easy Window Dragging
; https://www.autohotkey.com
; Normally, a window can only be dragged by clicking on its title bar.
; This script extends that so that any point inside a window can be dragged.
; To activate this mode, hold down CapsLock or the middle mouse button while
; clicking, then drag the window to a new position.

; Note: You can optionally release CapsLock or the middle mouse button after
; pressing down the mouse button rather than holding it down the whole time.

CapsLock & LButton::
EWD_MoveWindow(*)
{
    CoordMode "Mouse"  ; Switch to screen/absolute coordinates.
    MouseGetPos &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin
    WinGetPos &EWD_OriginalPosX, &EWD_OriginalPosY,,, EWD_MouseWin
    if !WinGetMinMax(EWD_MouseWin)  ; Only if the window isn't maximized 
        SetTimer EWD_WatchMouse, 10 ; Track the mouse as the user drags it.

    EWD_WatchMouse()
    {
        if !GetKeyState("LButton", "P")  ; Button has been released, so drag is complete.
        {
            SetTimer , 0
            return
        }
        if GetKeyState("Escape", "P")  ; Escape has been pressed, so drag is cancelled.
        {
            SetTimer , 0
            WinMove EWD_OriginalPosX, EWD_OriginalPosY,,, EWD_MouseWin
            return
        }
        ; Otherwise, reposition the window to match the change in mouse coordinates
        ; caused by the user having dragged the mouse:
        CoordMode "Mouse"
        MouseGetPos &EWD_MouseX, &EWD_MouseY
        WinGetPos &EWD_WinX, &EWD_WinY,,, EWD_MouseWin
        SetWinDelay -1   ; Makes the below move faster/smoother.
        WinMove EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY,,, EWD_MouseWin
        EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
        EWD_MouseStartY := EWD_MouseY
    }
}


/*
Dans Fusion 360
Les trois touches du haut à droite son respectivement f2 f3 et f4 
Avec le clic gauche elle font le pan, le zoom et l'orbit
*/
#Hotif WinActive("ahk_exe Fusion360.exe")
NumpadSub::f4
NumpadAdd::f2
XButton1::Send "^z"
XButton2:: Send "{LShift Down}{MButton Down}"
XButton2 Up:: Send "{LShift Up}{MButton Up}"
#Hotif

/*
Dans UltiMaker-Cura.exe
*/
#Hotif WinActive("ahk_exe UltiMaker-Cura.exe")
XButton1::Send "^z"
XButton2:: Send "{RButton Down}"
XButton2 Up:: Send "{RButton Up}"
#Hotif