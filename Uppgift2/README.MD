# Inlämningsuppgift

Artificiell Intelligens (AI)

Grupp 02:
Alexandra Jansson alja5888,
Tyr Hullmann tyhu6316,
Martin Hansson maha6445

## Beskrivning

Uppgiften använder kod från `tanks_bas_v1_0(240327).zip` och använder `Tank2` som grund. Uppgiften grundas i psudokoden som Russell & Norvig (2021, p. 150) presenterar för Minimax search samt pseudokoden för Alpha-Beta search (Russell & Norvig, 2021 p. 154).

Denna uppgift är implementerad i Processing. För att köra koden, öppna mappen med tillhörande kod i Processing (eller miljö som kan exekvera .pde-filer). Huvudfilen är `Uppgift2.pde` som har tillhörande `setup()` och `draw()` som krävs för att sätta upp miljön i Processing.

Agenterna som implementerats ska försöka ta över så många noder på fältet som möjligt. Den ena agenten baserar sina beslut på minimax search, och den andra på samma minimax algoritm med tillagd Alpha-Beta pruning.

För att ändra vilken strategi som agenten använder, byt ut initaliseringen av `MinimaxSearch` eller `AlphaBetaSearch` i `Team1.pde` på rad 73 respektive `Team2.pde` på rad 70. För att förändra djupnivån ändra värdet på variabeln `LIMIT` i antingen `MinimaxSearch.pde` eller `AlphaBetaSearch.pde` på rad 10.

Om tankerna kolliderar med varandra så skjuter de. Detta gör att en eller båda tanker kan bli immobiliserade och i detta skede så utförs sökningen oavbrutet för den immobiliserade tanken. Det här orsakar att simulationen blir väldigt trög och det är i dessa fall bättre att starta om den.

För att simuleringen skulle vara mer intressant använder vi oss av slump för att avgöra hur långt tankerna får gå i den valda riktingen. Om de istället går hela längden hamnar de i en förbestämd loop av drag då de varje gång utvärderar samma drag eftersom de alltid startar från samma position. Det här elementet av slump gör däremot att det inte alltid är "det bästa beslutet" som gör att en tank vinner utan det kan ibland göra att en tank hamnar i ett underläge även om den valde ett drag som skulle vara mer gynnsamt.

## Tangentfunktioner

### P-tangenten

P-tangenten pausar programmet.

### D-tangenten

D-tangenten startar programmets debug-läge. I debug-läget visas mer information kring status i miljön. Här visas noderna som respektive lag har tagit, antingen röd eller blå, och de noderna som är outforskade. Det syns även vilken nod en tank är påväg mot då målnoden markeras och färgen på noderna markeras med teamlagets färg när tanken rör sig.

## Referenser

Russell, S. & Norvig, P. (2021). Artificial intelligence: A modern approach (4th, US edition). London, United Kingdom: Pearson Education Limited.
