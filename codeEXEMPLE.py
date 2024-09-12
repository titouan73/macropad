
import board
import digitalio
import time
import rotaryio
import displayio
import busio
import usb_hid
import terminalio
from digitalio import DigitalInOut, Direction, Pull
import adafruit_displayio_sh1106
from adafruit_display_text import label
from adafruit_display_shapes.rect import Rect
from adafruit_hid.consumer_control import ConsumerControl
from adafruit_hid.consumer_control_code import ConsumerControlCode
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode
from adafruit_hid.keyboard_layout_us import KeyboardLayoutUS


## VARIABLES ## 

# Initialisation des variables de page
current_page = 0


MEDIA = 1
KEY = 2
STRING = 3

kbd = Keyboard(usb_hid.devices)
cc = ConsumerControl(usb_hid.devices)
layout = KeyboardLayoutUS(kbd)

# Initialisation de l'encodeur rotatif
#Bouton EC11
buttonEC11 = digitalio.DigitalInOut(board.GP11)
buttonEC11.direction = digitalio.Direction.INPUT
buttonEC11.pull = digitalio.Pull.UP  # Utilise la résistance pull-down intégrée
encoder = rotaryio.IncrementalEncoder(board.GP19, board.GP18)
last_position = 0

# macro keys GPIO Pins
pins = [
    board.GP2,
    board.GP3,
    board.GP4,
    board.GP5,
    board.GP6,
    board.GP7,
    board.GP8,
    board.GP9,
    board.GP10,
]


switches = [0, 1, 2, 3, 4, 5, 6, 7, 8]

for i in range(9):
    switches[i] = DigitalInOut(pins[i])
    switches[i].direction = Direction.INPUT
    switches[i].pull = Pull.UP

switch_state = [0, 0, 0, 0, 0, 0, 0, 0, 0]

# Création de l'objet HID pour les contrôles consommateurs
cc = ConsumerControl(usb_hid.devices)

# Intégration de la LED pas utilisé mais si vous voulez jouer avec elle est initialisée
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT

# Libère les affichages actuels (si nécessaire)
displayio.release_displays()

# Initialisation de l'I2C et de l'écran SH1106
i2c = busio.I2C(scl=board.GP1, sda=board.GP0)
display_bus = displayio.I2CDisplay(i2c, device_address=0x3C)
display = adafruit_displayio_sh1106.SH1106(display_bus, width=132, height=64)

# Crée le splash pour contenir les éléments d'affichage
splash = displayio.Group()

# Dimensions de l'écran
screen_width = display.width
screen_height = display.height


## FONCTIONS ##

# Fonction pour ajouter du texte à l'écran
def ajouter_texte(texte, x, y, taille=1, text_color=0xFFFFFF  ):
    return label.Label(terminalio.FONT, text=texte, color=text_color, scale=taille, x=x, y=y)

# Fonction pour effacer tout l'écran
def clear_screen():
    while len(splash) > 0:
        splash.pop()

# Fonction pour centrer le texte horizontalement
def centrer_texte(texte, largeur_ecran):
    largeur_texte = len(texte) * 6  # 6 pixels par caractère avec terminalio.FONT
    x = (largeur_ecran - largeur_texte) // 2
    return x

#savoir si l'encodeur rotatif va a gauche ou a droite
def left_or_right(position, last_position):
    if position > last_position:
        return "right"
    elif position < last_position:
        return "left"
    return None

# Fonction pour initialiser l'écran et afficher une matrice de titres
def boot_display():
    global current_page
    clear_screen()
    x_centre_titre = centrer_texte(page_names[current_page], display.width)
    
    # Laisser une ligne de titre
    title_height = 11
    usable_height = screen_height - title_height

    # Dimensions de chaque case
    num_rows = 3
    num_cols = 3
    cell_width = screen_width // num_cols  # Largeur de chaque case
    cell_height = usable_height // num_rows  # Hauteur de chaque case
    spacing = 2  # Pas d'espace entre les cases pour remplir toute la largeur et la hauteur

    # Crée les cases et les espacements
    for row in range(num_rows):
        for col in range(num_cols):
            # Calcule la position de chaque case
            x = col * (cell_width + spacing)
            y = title_height + row * (cell_height + spacing)
            # Dessine l'espace blanc autour des cases
            if col < num_cols - 1:  # Espace à droite des cases
                spacer = Rect(x=x + cell_width, y=y, width=spacing, height=cell_height, fill=0xFFFFFF)
                splash.append(spacer)
            if row < num_rows - 1:  # Espace en dessous des cases
                spacer = Rect(x=x, y=y + cell_height, width=cell_width + spacing, height=spacing, fill=0xFFFFFF)
                splash.append(spacer)

    # Dessiner le fond blanc pour le titre
    title_bg = Rect(x=0, y=0, width=screen_width, height=title_height, fill=0xFFFFFF)
    splash.append(title_bg)

    # Dessiner le texte du titre en noir
    x_centre_titre = centrer_texte(page_names[current_page], display.width)
    splash.append(ajouter_texte(page_names[current_page], x_centre_titre, 5,1,0x000000))  # 2 pixels de marge du haut
    splash.append(ajouter_texte(pages[current_page][0], 3, 20))
    splash.append(ajouter_texte(pages[current_page][1], 3, 37))
    splash.append(ajouter_texte(pages[current_page][2], 3, 56))


    # Ajoute le splash au display pour l'affichage
    display.root_group = splash


def assignKeyMap():
    return {
        (0): (pages_object[current_page][0][2], pages_object[current_page][0][0]),
        (1): (pages_object[current_page][1][2], pages_object[current_page][1][0]),
        (2): (pages_object[current_page][2][2], pages_object[current_page][2][0]),
        (3): (pages_object[current_page][3][2], pages_object[current_page][3][0]),
        (4): (pages_object[current_page][4][2], pages_object[current_page][4][0]),
        (5): (pages_object[current_page][5][2], pages_object[current_page][5][0]),
        (6): (pages_object[current_page][6][2], pages_object[current_page][6][0]),
        (7): (pages_object[current_page][7][2], pages_object[current_page][7][0]),
        (8): (pages_object[current_page][8][2], pages_object[current_page][8][0])
    }



## PAGES ##
# MULTI-MEDIA
page_1 = [
    
    [[ConsumerControlCode.VOLUME_DECREMENT], "V-",MEDIA],
    [[ConsumerControlCode.MUTE], "MUTE",MEDIA],
    [[ConsumerControlCode.VOLUME_INCREMENT], "V+",MEDIA],
    [[ConsumerControlCode.SCAN_PREVIOUS_TRACK], "PREV", MEDIA],
    [[ConsumerControlCode.PLAY_PAUSE], "PLAY", MEDIA],
    [[ConsumerControlCode.SCAN_NEXT_TRACK], "NEXT", MEDIA],
    [[Keycode.COMMAND, Keycode.LEFT_SHIFT, Keycode.A], "Z-AUDIO" ,KEY],
    [[Keycode.COMMAND, Keycode.LEFT_SHIFT, Keycode.V], "Z-VIDEO",KEY],
    [[Keycode.RIGHT_GUI, Keycode.RIGHT_SHIFT, Keycode.F13], "AUDIO",KEY],
]

page_1_format = [
    f"  {page_1[0][1]}     {page_1[1][1]}     {page_1[2][1]}",
    f"{page_1[3][1]}     {page_1[4][1]}    {page_1[5][1]}",
    f"{page_1[6][1]} {page_1[7][1]} {page_1[8][1]}"
]

#Emojis
page_2 = [
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.A], "joy",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.B], "monkey",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.C], "smirk",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.D], "love",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.E], "sad",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.F], "o.o",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.G], "blazé",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.H], "cry",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.I], "géné",KEY],
]

page_2_format = [
    f"{page_2[0][1]}     {page_2[1][1]}  {page_2[2][1]}",
    f"{page_2[3][1]}     {page_2[4][1]}    {page_2[5][1]}",
    f"{page_2[6][1]}   {page_2[7][1]}     {page_2[8][1]}",
]


#Page pour tester les switchs
page_3 = [
    [[u'sw1'], "sw1",STRING],
    [[u'sw2'], "sw2",STRING],
    [[u'sw3'], "sw3",STRING],
    [[u'sw4'], "sw4",STRING],
    [[u'sw5'], "sw5",STRING],
    [[u'sw6'], "sw6",STRING],
    [[u'sw7'], "sw7",STRING],
    [[u'sw8'], "sw8",STRING],
    [[u'sw9'], "sw9",STRING]
    
]

page_3_format = [
    f"{page_3[0][1]}       {page_3[1][1]}     {page_3[2][1]}",
    f"{page_3[3][1]}      {page_3[4][1]}      {page_3[5][1]}",
    f"{page_3[6][1]}      {page_3[7][1]}      {page_3[8][1]}",
]

#Emojis ASCII
page_4 = [
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.J], "abaa",KEY], #¯\_(ツ)_/¯
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.K], "shoot",KEY], #( -_•)▄︻テحكـ━
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.L], "smirk",KEY], #( ͡° ͜ʖ ͡°)
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.M], "flpTbl",KEY], #(╯°□°）╯︵ ┻━┻
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.N], "angry",KEY], #ᕦ(ò_óˇ)ᕤ
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.O], "o.o",KEY], #(⊙ _ ⊙ )
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.P], "uWu",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.Q], "fr",KEY],
    [[Keycode.CONTROL, Keycode.WINDOWS, Keycode.R], "Russe",KEY], #если ты можешь это прочитать, то ты дерьмо
]
    


page_4_format = [
    f"{page_4[0][1]}     {page_4[1][1]}  {page_4[2][1]}",
    f"{page_4[3][1]}  {page_4[4][1]}    {page_4[5][1]}",
    f"{page_4[6][1]}       {page_4[7][1]}    {page_4[8][1]}",
]

pages = [page_1_format, page_2_format, page_3_format, page_4_format]
page_names = ["1 - MULTIMEDIA", "2 - EMOJI", "3 - TEST", "4 - CS2"]
pages_object = [page_1, page_2, page_3, page_4]

keymap = {
    (0): (pages_object[current_page][0][2], pages_object[current_page][0][0]),
    (1): (pages_object[current_page][1][2], pages_object[current_page][1][0]),
    (2): (pages_object[current_page][2][2], pages_object[current_page][2][0]),
    (3): (pages_object[current_page][3][2], pages_object[current_page][3][0]),
    (4): (pages_object[current_page][4][2], pages_object[current_page][4][0]),
    (5): (pages_object[current_page][5][2], pages_object[current_page][5][0]),
    (6): (pages_object[current_page][6][2], pages_object[current_page][6][0]),
    (7): (pages_object[current_page][7][2], pages_object[current_page][7][0]),
    (8): (pages_object[current_page][8][2], pages_object[current_page][8][0])
}

# Affichage de la matrice de titre lors du démarrage
boot_display()


## BOUCLE D'EXECUTION ##
while True:
    position = encoder.position
    comparison = left_or_right(position, last_position)
    if comparison:
        if comparison == "right" and current_page < len(pages)-1:
            current_page = current_page + 1
            keymap = assignKeyMap()
            boot_display()
        elif comparison == "left" and current_page != 0:
            current_page = current_page - 1
            keymap = assignKeyMap()
            boot_display()
    last_position = position

    #Mute sur chaque page avec le click de l'EC11
    if not buttonEC11.value:
        cc.send(ConsumerControlCode.MUTE)
        time.sleep(0.5)


    for button in range(9):
        if switch_state[button] == 0:
            if not switches[button].value:
                print("pressed")
                try:
                    if keymap[button][0] == KEY:
                        kbd.press(*keymap[button][1])
                        print(*keymap[button][1])
                    elif keymap[button][0] == STRING:
                        for letter in keymap[button][1][0]:
                            layout.write(letter)
                    else:
                        cc.send(keymap[button][1][0])
                except ValueError:  # deals w six key limit
                    pass
                switch_state[button] = 1

        if switch_state[button] == 1:
            if switches[button].value:
                try:
                    if keymap[button][0] == KEY:
                        kbd.release(*keymap[button][1])
                except ValueError:
                    pass
                switch_state[button] = 0


 # type: ignore

 