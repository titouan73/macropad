/*
Numpad AutoHotKey Script
Author : M1tch
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



; Numpad 000 Key
; https://www.autohotkey.com
; This example script makes the special 000 key that appears on certain
; keypads into an equals key.  You can change the action by replacing the
; Send "=" line with line(s) of your choice.

#MaxThreadsPerHotkey 5  ; Allow multiple threads for this hotkey.
$Numpad0::
{
    #MaxThreadsPerHotkey 1
    ; Above: Use the $ to force the hook to be used, which prevents anL
    ; infinite loop since this subroutine itself sends Numpad0, which
    ; would otherwise result in a recursive call to itself.
    DelayBetweenKeys := 1 ; Adjust this value if it doesn't work.
    if A_PriorHotkey = A_ThisHotkey
    {
        if A_TimeSincePriorHotkey < DelayBetweenKeys
        {
            if Numpad0Count = ""
                Numpad0Count := 2 ; i.e. This one plus the prior one.
            else if Numpad0Count = 0
                Numpad0Count := 2
            else
            {
                ; Since we're here, Numpad0Count must be 2 as set by
                ; prior calls, which means this is the third time the
                ; the key has been pressed. Thus, the hotkey sequence
                ; should fire:
                Numpad0Count := 0
                Send "=" ; ******* This is the action for the 000 key
            }
            ; In all the above cases, we return without further action:
            CalledReentrantly := true
            return
        }
    }
    ; Otherwise, this Numpad0 event is either the first in the series
    ; or it happened too long after the first one (e.g. perhaps the
    ; user is holding down the Numpad0 key to auto-repeat it, which
    ; we want to allow).  Therefore, after a short delay -- during
    ; which another Numpad0 hotkey event may re-entrantly call this
    ; subroutine -- we'll send the key on through if no reentrant
    ; calls occurred:
    Numpad0Count := 0
    CalledReentrantly := false
    ; During this sleep, this subroutine may be reentrantly called
    ; (i.e. a simultaneous "thread" which runs in parallel to the
    ; call we're in now):
    Sleep DelayBetweenKeys
    if CalledReentrantly = true ; Another "thread" changed the value.
    {
        ; Since it was called reentrantly, this key event was the first in
        ; the sequence so should be suppressed (hidden from the system):
        CalledReentrantly := false
        return
    }
    ; Otherwise it's not part of the sequence so we send it through normally.
    ; In other words, the *real* Numpad0 key has been pressed, so we want it
    ; to have its normal effect:
    Send "{Numpad0}"
}

;Some emojis 😂😏🙈🥰

Numpad1::Send "😂"
Numpad2::Send "😏"
Numpad3::Send "🙈🥰"



NumpadSub::
{
    DetectHiddenWindows false
    Page := WinGetTitle("Réseaux")
    WinActivate Page
    MsgBox "The text is:`n" WinGetTitle(Page)
    
}


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
