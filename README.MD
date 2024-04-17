# Inlämningsuppgift 1

Artificiell Intelligens (AI)

Grupp 02:
Alexandra Jansson alja5888,
Tyr Hullmann tyhu6316,
Martin Hansson maha6445

## Beskrivning

Uppgiften använder kod från `tanks_bas_v1_0(240327).zip` som grund samt använder viss kod från `tanks_190324.zip`. Algoritmen för A\* grundar sig i Martin Hanssons kod från en inlämning i kursen Algoritmer och Datastrukturer (ALDA) från VT24 som implementerades för att lösa projektet SL-light i temat grafer. Breadth-first-search (BFS) har delvis implementerats utifrån de tips och pseudokoden som Russell & Norvig (2021, p.76-77) presenterar.

Denna uppgift är implementerad i Processing. För att köra koden, öppna mappen med tillhörande kod i Processing (eller miljö som kan exekvera .pde-filer). Huvudfilen är `AIGrupp2.pde` som har tillhörande `setup()` och `draw()` som krävs för att sätta upp miljön i Processing.

När agenten hamnar i motståndarnas bas ska den automatiskt söka efter den kortaste vägen hem, detta sker när noden innuti basen är nådd.

## Tangentfunktioner

### P-tangenten

P-tangenten pausar programmet

### S-tangenten

S-tangenten söker efter den kortaste vägen hem enligt den aktiva sökalgoritmen. Tanken ändrar tillstånd först när den "anlänt" vid positionen den rör sig mot. Detta förenklar logiken för när agenten byter tillstånd och den behöver inte förändra beteende förens den stannat.

### D-tangenten

D-tangenten startar programmets debug-läge. I debug-läget visas mer information kring status i miljön. De noder som finns i `Grid.pde` visas nu visuellt. Den interna grafen som tanken bygger upp under utforskande visas också. Noderna och kanterna som tanken besökt och fyllt i `GridGraph.pde` illustreras ifyllda i rött och röda linjer illustrerar de kanter som kopplats mellan besökta noder.

### R-tangenten

R-tangenten återställer tanken till att utforska, även om det sker en pågående sökning eller att tanken följer sökvägen tillbaka till hemmabasen.

### B-tangenten

B-tangenten byter den aktiva sökalgoritmen. Programmet initialiserar med A\* som aktiv sökalgoritm.

## Referenser

Russell, S. & Norvig, P. (2021). Artificial intelligence: A modern approach (4th, US edition). London, United Kingdom: Pearson Education Limited.
