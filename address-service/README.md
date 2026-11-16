# PROOF NEXT – samostatná adresní služba

Statická navigace zůstává na GitHub Pages. Tato služba se nasazuje samostatně na Cloudflare Workers + D1.

1. Vytvoř Cloudflare účet, přihlas se přes `npx wrangler login`.
2. `npx wrangler d1 create proof-next-addresses` a doplň skutečné database_id do wrangler.toml.
3. `npx wrangler d1 execute proof-next-addresses --remote --file=schema.sql`.
4. Naimportuj **oficiální RÚIAN CSV** do tabulky addresses. Zdroj ČÚZK poskytuje souřadnice S-JTSK; před importem je nutný převod do WGS84 (EPSG:4326), normalizace textu bez diakritiky a dávkování podle limitů D1. Bez importu API nevrací adresy.
5. `npx wrangler deploy` a výslednou HTTPS URL nastav v PROOF NEXT (konfigurace `PROOF_ADDRESS_API` v index.html).

API: `GET /health` a `GET /search?q=Praha%20V%C3%A1clavsk%C3%A9%20n%C3%A1m%C4%9Bst%C3%AD%201`.
Odpověď `{results:[{code,city,street,house,postcode,lat,lon}],source:"RÚIAN / ČÚZK"}`.

Pozor: D1 Free má kvóty; kompletní RÚIAN může vyžadovat placený tarif nebo rozdělený index. Nepoužívej cizí Google Maps data. Vyhledávání bez spuštěného backendu dál používá původní OSM/Photon.
