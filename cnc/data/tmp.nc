(CID    IP V  ON OFF SET SPT SV WT WS WP MS PM SS )
(The hole NH0001 ERODING PARAMETER:)
E1640 = 15 14  8  15  6  15 45 10 18  6  0  0  0 
E1641 = 15 14 14   8  7   8 40 13 18  7  0  0  0 
E1642 = 15 14  2   8  2   8 55 17 18  1  6  0  0 
E1643 =  9 14  7   3  1   1 55 17 18  1  6  1  0 
NH0001
H089=000
T84 T86
H000=9           H001=211+H089
H002=146+H089           H003=134+H089
H099=0
G54 G90 G92X-300Y+10000
E1640
G01X-300Y+6200
E1641
G41H000
G01X-300Y+5700
G41H001
G01X+0Y+5700
G01X+0Y+6000
G01X+6000Y+6000
G01X+6000Y-6000
G01X-6000Y-6000
G01X-6000Y+6000
G01X-4500Y+6000
G01X-4500Y+5700
G01X-1300Y+5700
G40H000G01X-1300Y+6200
G04X3.0
T85
M00
E1642
G42H000
G01X-1300Y+5700
G42H002
G01X-4500Y+5700
G01X-4500Y+6000
G01X-6000Y+6000
G01X-6000Y-6000
G01X+6000Y-6000
G01X+6000Y+6000
G01X+0Y+6000
G01X+0Y+5700
G01X-300Y+5700
G40H000G01X-300Y+6200
E1643
G41H000
G01X-300Y+5700
G41H003
G01X+0Y+5700
G01X+0Y+6000
G01X+6000Y+6000
G01X+6000Y-6000
G01X-6000Y-6000
G01X-6000Y+6000
G01X-4500Y+6000
G01X-4500Y+5700
G01X-1300Y+5700
G40H000G01X-1300Y+6200
M00
T84
E1640
G41H000
G01X-1300Y+5700
G41H001
E1641
G01X-300Y+5700
G40H000G01X-300Y+6200
E1642
G42H000
G01X-300Y+5700
G42H002
G01X-1300Y+5700
G40H000G01X-1300Y+6200
E1643
G41H000
G01X-1300Y+5700
G41H003
G01X-300Y+5700
G40H000G01X-300Y+6200
G01X-300Y+10000
T85 T87 M02
(The Total Cutting length=  148.600000 mm )