# PROOF NEXT – navigace a komunitní doprava

Stav: vývojový návrh, nikoli hotová implementace. Větev není určena k nasazení bez testů.

## Ověřený výchozí stav (2026-11-22)
- index.html obsahuje MapLibre, GPS watchPosition, výpočet tras, hlasové pokyny a logiku přepočtu.
- Dopravní hlášení se ukládají pouze do localStorage pod proofLocalTraffic, maximálně 30 za posledních 24 hodin. Nejsou sdílena mezi řidiči.
- GPS kamera při navigaci používá map.jumpTo; plynulost při jízdě nebyla ověřena.
- Zachovat OpenFreeMap/OpenStreetMap, české adresy, routing, hlasové pokyny a GTA vzhled.

## Etapa 1: stabilní navigace
- Změřit frekvenci GPS událostí, renderů a přepočtů na testovacích trasách.
- Omezit zbytečné animace a kamerové aktualizace; testovat plynulost bez zpoždění odboček.
- Přidat testy GPS přesnosti, zastaralých souřadnic, odchylky od trasy a reroute.

## Etapa 2: komunitní hlášení
- Zavést samostatné HTTPS API pro nehody, překážky, uzavírky a kolony; GitHub Pages samo backend neposkytuje.
- Datový model: id, typ, přibližná poloha, čas, expirace, potvrzení, stav moderace.
- Omezení spamu, rate limit, hlášení nevhodného obsahu, expirace a zásady soukromí.
- Nezveřejňovat identitu ani přesnou historii pohybu řidičů; minimální sběr dat.
- Na mapě zobrazovat jen potvrzené či jasně označené neověřené události.

## Etapa 3: dopravní routing
- Ověřit legálně licencovaný zdroj aktuální dopravy; nevyužívat neveřejná data Waze.
- Bez spolehlivých dat neoznačovat odhady jako živé kolony.
- Přepočet trasy na základě ověřených uzavírek a omezení, s fallbackem při výpadku API.

## Podmínky nasazení
- Syntax check a automatizované testy; kontrola mapových dlaždic, vyhledávání adres, trasování, navigace a offline chování.
- Testování na iPhone i desktopu a následně skutečná jízda pod dohledem; vzdálený audit ji nenahrazuje.
- Změny nasazovat postupně, bez automatického merge do main.
