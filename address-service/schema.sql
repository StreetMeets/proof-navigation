CREATE TABLE IF NOT EXISTS addresses (code INTEGER PRIMARY KEY, city TEXT NOT NULL, street TEXT, house TEXT NOT NULL, postcode TEXT, lat REAL NOT NULL, lon REAL NOT NULL, search_text TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS addresses_city ON addresses(city);
