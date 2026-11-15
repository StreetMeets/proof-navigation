# Proof Navigation

První veřejná verze automobilové navigace Proof.

## Funkce
- OpenStreetMap mapa
- vyhledávání cíle (Nominatim)
- výpočet automobilové trasy (OSRM)
- GPS poloha a sledování během navigace
- detekce odchylky přibližně nad 75 m a automatický přepočet
- hlasové oznámení při přepočtu (pokud jej prohlížeč podporuje)
- motivy Proof, BMW M, AMG, Audi RS, Porsche, Mustang a NISMO
- PWA instalace na domovskou obrazovku

## iPhone
Otevři web v Safari přes HTTPS → Sdílet → Přidat na plochu. Povol polohu. Během navigace nech aplikaci otevřenou; iOS může omezovat běh a GPS na pozadí.

## Důležitá omezení
Jde o prototyp, nikoli certifikovanou navigaci. Veřejné demo servery Nominatim, OSRM a OSM dlaždice mají pravidla a limity; negarantují dostupnost ani provoz pro velké množství uživatelů. Pro produkční nasazení je potřeba vhodný poskytovatel map, geokódování a routingu. Vždy dodržuj dopravní značení a telefon ovládej pouze bezpečně.
