# Création du PCB et montage

## Matériel
- Raspberry pi PICO W
- Écran sh106 1,3"
- 9 switch MX 
- Encodeur rotatif EC11 (15mm)
- 3 resistances 10k
- Risers (min 40 pins)
- Ampoule incandescant 5V

## Assemblage

Voici les étapes d'assemblage à partir des pièces imprimées en 3d et disponibles dans le dossier 3dPrint.
![alt text](image.png)

1. Souder les risers pour le RaspberryPI PICO

![Description de l'image](../Images/IMG_20240912_13462115.jpg)

2. Souder l'EC11 et les resistances

![Description de l'image](../Images/IMG_20240910_163232.jpg)
![Description de l'image](../Images/IMG_20240910_163727.jpg)

3. Clipser les switchs sur la partie haute de la case

![Description de l'image](../Images/IMG_20240912_13463958.jpg)
![Description de l'image](../Images/IMG_20240910_163957.jpg)


4. Placer la partie supérieur de la case et souder les switch sur le PCB

![Description de l'image](../Images/IMG_20240912_13465054.jpg)

5. Souder le raspberry pico sur le PCB

![Description de l'image](../Images/IMG_20240910_164720.jpg)

6. Souder la lampe à filament sur le PCB

![Description de l'image](../Images/IMG_20240910_165334.jpg)

7. Flasher le Raspberry pico avant de refermer la case

![Description de l'image](../Images/IMG_20240910_170120.jpg)

8. Refermer la case et placer les keycaps

![Description de l'image](../Images/IMG_20240910_165454.jpg)
![Description de l'image](../Images/IMG_20240910_165650.jpg)

### Voilà c'est terminé ! 

![Description de l'image](../Images/IMG_20240910_165745.jpg)

## Circuit Imprimé (PCB)

Je ne vais pas rentrer trop précisément dans les détails électroniques de la confection de ce PCB car nous sommes en bas voltages et ainsi les erreures de sont pas très graves. De plus énormément de tutoriels sont présents sur internet.

Voici les deux schémas : 
![Dessous](pcb_bottom.png)
![Dessus](pcb_top.png)

Et le schéma fonctionnel : 

![alt](schematic.png)

> Pour toute question vous pouvez me contacter à l'adresse titouanfontaine@hackmedaddy.fr