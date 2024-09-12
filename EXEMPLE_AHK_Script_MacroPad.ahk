/*
Numpad AutoHotKey Script
Author : M1tch

à déposer dans le dossier 
C:\Users\<user>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
si on veut le lancer au démarrage
*/


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

;Raccourci pour mes scripts perso
#s::
{
    Run "..\minuterieVeille\minuterieVeille.bat"
}

#enter::
{
    Run "PowerShell -ExecutionPolicy Bypass -File ..\audioSwitcher\audioSwitcher.ps1"
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