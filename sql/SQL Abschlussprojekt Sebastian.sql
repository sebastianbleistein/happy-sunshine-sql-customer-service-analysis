-- =========================================
-- HAPPY SUNSHINE - SQL ABSCHLUSSPROJEKT
----------------von Sebastian Bleistein
-- =========================================


-- =========================================
-- 1. Schema erstellen
-- hier lege ich meinen Arbeitsbereich für das Projekt an
-- =========================================
CREATE SCHEMA IF NOT EXISTS happy_sunshine;


/*CREATE SCHEMA

Query returned successfully in 86 msec.
*/

-- =========================================
-- 2. Tabellen erstellen
-- hier baue ich das relationale Datenmodell passend zu den finalen CSVs auf
-- =========================================

-- -----------------------------------------
-- Mitarbeiter
-- hier speichere ich alle Support-Mitarbeiter
-- -----------------------------------------
CREATE TABLE happy_sunshine.mitarbeiter
(
    mitarbeiter_id          INT PRIMARY KEY,
    vorname                 VARCHAR(100),
    nachname                VARCHAR(100),
    support_level           VARCHAR(50),
    erfahrungslevel         VARCHAR(50),
    startdatum              DATE,
    aktiv                   BOOLEAN
);

/*CREATE TABLE

Query returned successfully in 65 msec.
*/

-- -----------------------------------------
-- Kanaele
-- hier definiere ich die Kontaktkanaele
-- -----------------------------------------
CREATE TABLE happy_sunshine.kanaele
(
    kanal_id                VARCHAR(10) PRIMARY KEY,
    kanal_name              VARCHAR(50)
);

/*CREATE TABLE

Query returned successfully in 37 msec.
*/


-- -----------------------------------------
-- Kunden
-- hier speichere ich alle Kundendaten
-- -----------------------------------------
CREATE TABLE happy_sunshine.kunden
(
    kunden_id                           VARCHAR(20) PRIMARY KEY,
    vorname                             VARCHAR(100),
    nachname                            VARCHAR(100),
    geburtsdatum                        DATE,
    email                               VARCHAR(150),
    handynummer                         VARCHAR(50),
    festnetznummer                      VARCHAR(50),
    strasse                             VARCHAR(150),
    hausnummer                          VARCHAR(20),
    plz                                 VARCHAR(10),
    stadt                               VARCHAR(100),
    region                              VARCHAR(50),
    iban                                VARCHAR(34),
    registrierungsdatum                 DATE,
    kaufdatum                           DATE,
    kundendauer_tage_bis_2025_03_31     INT,
    produkt_id                          INT
);


/*CREATE TABLE

Query returned successfully in 40 msec.
*/

-- -----------------------------------------
-- Interaktionen
-- hier speichere ich jeden Inbound-Kundenkontakt
-- -----------------------------------------
CREATE TABLE happy_sunshine.interaktionen
(
    interaktion_id              VARCHAR(20) PRIMARY KEY,
    kunden_id                   VARCHAR(20),
    kanal_id                    VARCHAR(10),
    mitarbeiter_id              INT,
    interaktion_zeitpunkt       TIMESTAMP,
    interaktion_datum           DATE,
    interaktion_uhrzeit         TIME,
    wochentag                   VARCHAR(30),
    kalenderwoche               INT,
    monat                       INT,
    warteschlange               VARCHAR(50),
    interaktionstyp             VARCHAR(30),
    richtung                    VARCHAR(30),
    anruf_ergebnis              VARCHAR(30),
    wartezeit_sekunden          INT,
    gespraechsdauer_sekunden    INT,
    nachbearbeitung_sekunden    INT,
    haltezeit_sekunden          INT,
    ist_peak_zeit               INT,
    wurde_transferiert          INT,
    transfer_zu_level           VARCHAR(30),
    anliegen_typ                VARCHAR(50),
    prioritaet                  VARCHAR(30),
    rueckruf_noetig             INT,
    kunde_erreicht              INT
);

/*CREATE TABLE

Query returned successfully in 37 msec.
*/

-- -----------------------------------------
-- Tickets
-- hier speichere ich alle Service-Tickets
-- -----------------------------------------
CREATE TABLE happy_sunshine.tickets
(
    ticket_id                                VARCHAR(20) PRIMARY KEY,
    kunden_id                                VARCHAR(20),
    erstellt_am                              TIMESTAMP,
    ursprung_interaktion_id                  VARCHAR(20),
    kanal_id                                 VARCHAR(10),
    anliegen_typ                             VARCHAR(50),
    prioritaet                               VARCHAR(30),
    aktueller_status                         VARCHAR(50),
    ticket_level                             VARCHAR(30),
    erstbearbeiter_id                        INT,
    aktueller_bearbeiter_id                  INT,
    erste_reaktion_am                        TIMESTAMP,
    geloest_am                               TIMESTAMP,
    geschlossen_am                           TIMESTAMP,
    wartezeit_bis_erste_reaktion_stunden     NUMERIC(10,2),
    bearbeitungsdauer_stunden                NUMERIC(10,2),
    eskaliert                                INT,
    backlog_flag                             INT
);

/*
CREATE TABLE

Query returned successfully in 32 msec.
*/

-- -----------------------------------------
-- Ticket-Status-Historie
-- hier speichere ich die Statusveraenderungen zur Prozessanalyse
-- -----------------------------------------
CREATE TABLE happy_sunshine.ticket_status_historie
(
    statushistorie_id            INT PRIMARY KEY,
    ticket_id                    VARCHAR(20),
    status                       VARCHAR(50),
    geaendert_am                 TIMESTAMP,
    geaendert_von_agent_id       INT,
    kommentar_typ                VARCHAR(30),
    kommentar                    TEXT
);

/*CREATE TABLE

Query returned successfully in 37 msec.
*/

-- -----------------------------------------
-- Zufriedenheit
-- hier speichere ich CSAT, NPS und Feedback
-- -----------------------------------------
CREATE TABLE happy_sunshine.zufriedenheit
(
    zufriedenheit_id             VARCHAR(20) PRIMARY KEY,
    ticket_id                    VARCHAR(20),
    csat_score                   INT,
    nps_score                    INT,
    feedback_text                TEXT,
    bewertet_am                  TIMESTAMP
);

/*CREATE TABLE

Query returned successfully in 36 msec.
*/

-- =========================================
-- 3. Foreign Keys setzen
-- hier verknuepfe ich alle Tabellen miteinander
-- =========================================

-- Interaktionen gehoeren zu Kunden
ALTER TABLE happy_sunshine.interaktionen
ADD CONSTRAINT fk_interaktion_kunde
FOREIGN KEY (kunden_id)
REFERENCES happy_sunshine.kunden(kunden_id);

/*ALTER TABLE

Query returned successfully in 43 msec.
*/

-- Interaktionen kommen ueber Kanaele
ALTER TABLE happy_sunshine.interaktionen
ADD CONSTRAINT fk_interaktion_kanal
FOREIGN KEY (kanal_id)
REFERENCES happy_sunshine.kanaele(kanal_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Interaktionen koennen einem Mitarbeiter zugeordnet sein
ALTER TABLE happy_sunshine.interaktionen
ADD CONSTRAINT fk_interaktion_mitarbeiter
FOREIGN KEY (mitarbeiter_id)
REFERENCES happy_sunshine.mitarbeiter(mitarbeiter_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Tickets gehoeren zu Kunden
ALTER TABLE happy_sunshine.tickets
ADD CONSTRAINT fk_ticket_kunde
FOREIGN KEY (kunden_id)
REFERENCES happy_sunshine.kunden(kunden_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Tickets kommen ueber Kanaele
ALTER TABLE happy_sunshine.tickets
ADD CONSTRAINT fk_ticket_kanal
FOREIGN KEY (kanal_id)
REFERENCES happy_sunshine.kanaele(kanal_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Tickets verweisen auf die urspruengliche Interaktion
ALTER TABLE happy_sunshine.tickets
ADD CONSTRAINT fk_ticket_interaktion
FOREIGN KEY (ursprung_interaktion_id)
REFERENCES happy_sunshine.interaktionen(interaktion_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Erstbearbeiter
ALTER TABLE happy_sunshine.tickets
ADD CONSTRAINT fk_ticket_erstbearbeiter
FOREIGN KEY (erstbearbeiter_id)
REFERENCES happy_sunshine.mitarbeiter(mitarbeiter_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Aktueller Bearbeiter
ALTER TABLE happy_sunshine.tickets
ADD CONSTRAINT fk_ticket_aktueller_bearbeiter
FOREIGN KEY (aktueller_bearbeiter_id)
REFERENCES happy_sunshine.mitarbeiter(mitarbeiter_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Status-Historie gehoert zu Tickets
ALTER TABLE happy_sunshine.ticket_status_historie
ADD CONSTRAINT fk_status_ticket
FOREIGN KEY (ticket_id)
REFERENCES happy_sunshine.tickets(ticket_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Status-Historie kann von Mitarbeiter geaendert werden
ALTER TABLE happy_sunshine.ticket_status_historie
ADD CONSTRAINT fk_status_mitarbeiter
FOREIGN KEY (geaendert_von_agent_id)
REFERENCES happy_sunshine.mitarbeiter(mitarbeiter_id);

/*ALTER TABLE

Query returned successfully in 38 msec.
*/

-- Zufriedenheit gehoert zu Tickets
ALTER TABLE happy_sunshine.zufriedenheit
ADD CONSTRAINT fk_zufriedenheit_ticket
FOREIGN KEY (ticket_id)
REFERENCES happy_sunshine.tickets(ticket_id);

--Performance absichern:

--Für die Tabelle Index
CREATE INDEX idx_tickets_kunden_id
ON happy_sunshine.tickets (kunden_id);

CREATE INDEX idx_tickets_kanal_id
ON happy_sunshine.tickets (kanal_id);

CREATE INDEX idx_tickets_status
ON happy_sunshine.tickets (aktueller_status);

CREATE INDEX idx_tickets_anliegen_typ
ON happy_sunshine.tickets (anliegen_typ);

CREATE INDEX idx_tickets_erstellt_am
ON happy_sunshine.tickets (erstellt_am);


--Für die Tabelle interaktionen:
CREATE INDEX idx_interaktionen_kunden_id
ON happy_sunshine.interaktionen (kunden_id);

CREATE INDEX idx_interaktionen_kanal_id
ON happy_sunshine.interaktionen (kanal_id);

CREATE INDEX idx_interaktionen_datum
ON happy_sunshine.interaktionen (interaktion_datum);

CREATE INDEX idx_interaktionen_zeitpunkt
ON happy_sunshine.interaktionen (interaktion_zeitpunkt);

CREATE INDEX idx_interaktionen_anliegen_typ
ON happy_sunshine.interaktionen (anliegen_typ);

--Für die Tabelle ticket_status_historie:

CREATE INDEX idx_ticket_status_ticket_id
ON happy_sunshine.ticket_status_historie (ticket_id);


--Index für das Management für schnelle Abfragen zum Thema Tickets:

CREATE INDEX idx_tickets_status_prio
ON happy_sunshine.tickets (aktueller_status, prioritaet);

CREATE INDEX idx_ticket_status_geaendert_am
ON happy_sunshine.ticket_status_historie (geaendert_am);

--Für die Tabelle zufriedenheit:

CREATE INDEX idx_zufriedenheit_ticket_id
ON happy_sunshine.zufriedenheit (ticket_id);



-- hier analysiere ich Calls nach Wochentag und Stunde
-- und lege die Erreichbarkeit direkt dahinter

SELECT
    CASE 
        WHEN wochentag = 'Monday' THEN 'Montag'
        WHEN wochentag = 'Tuesday' THEN 'Dienstag'
        WHEN wochentag = 'Wednesday' THEN 'Mittwoch'
        WHEN wochentag = 'Thursday' THEN 'Donnerstag'
        WHEN wochentag = 'Friday' THEN 'Freitag'
    END AS wochentag,

    EXTRACT(HOUR FROM interaktion_uhrzeit) AS stunde,

    COUNT(*) AS anzahl_interaktionen,

    COUNT(*) FILTER (WHERE anruf_ergebnis = 'answered') AS answered,

    COUNT(*) FILTER (WHERE anruf_ergebnis = 'missed') AS missed,

    COUNT(*) FILTER (WHERE anruf_ergebnis = 'abandoned') AS abandoned,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE anruf_ergebnis = 'answered')
        / NULLIF(COUNT(*), 0),
        2
    ) AS erreichbarkeit_prozent

FROM happy_sunshine.interaktionen

WHERE wochentag IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')

GROUP BY wochentag, stunde

ORDER BY
    CASE 
        WHEN wochentag = 'Monday' THEN 1
        WHEN wochentag = 'Tuesday' THEN 2
        WHEN wochentag = 'Wednesday' THEN 3
        WHEN wochentag = 'Thursday' THEN 4
        WHEN wochentag = 'Friday' THEN 5
    END,
    stunde;




-- hier analysiere ich Tickets nach Monat

SELECT
    EXTRACT(MONTH FROM erstellt_am) AS monat,

    COUNT(*) AS gesamt_tickets,

    COUNT(*) FILTER (
        WHERE aktueller_status = 'geschlossen'
    ) AS geschlossene_tickets,

    COUNT(*) FILTER (
        WHERE aktueller_status <> 'geschlossen'
    ) AS offene_tickets,

    COUNT(*) FILTER (
        WHERE eskaliert = 1
    ) AS eskalierte_tickets

FROM happy_sunshine.tickets

GROUP BY monat
ORDER BY monat;

-- hier analysiere ich, bei welchen Anliegen Tickets am häufigsten eskalieren

SELECT
    anliegen_typ,

    COUNT(*) AS gesamt_tickets,

    COUNT(*) FILTER (
        WHERE eskaliert = 1
    ) AS eskalierte_tickets,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE eskaliert = 1)
        / NULLIF(COUNT(*), 0),
        2
    ) AS eskalationsquote_prozent

FROM happy_sunshine.tickets

GROUP BY anliegen_typ

ORDER BY eskalationsquote_prozent DESC;



-- hier kombiniere ich Support-Level und Erfahrungslevel

SELECT
    m.support_level,
    m.erfahrungslevel,

    COUNT(*) AS gesamt_tickets,

    COUNT(*) FILTER (
        WHERE t.eskaliert = 1
    ) AS eskalierte_tickets,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE t.eskaliert = 1)
        / NULLIF(COUNT(*), 0),
        2
    ) AS eskalationsquote_prozent

FROM happy_sunshine.tickets t

JOIN happy_sunshine.mitarbeiter m
    ON t.aktueller_bearbeiter_id = m.mitarbeiter_id

GROUP BY 
    m.support_level,
    m.erfahrungslevel

ORDER BY eskalationsquote_prozent DESC;



--Index Test:)


SET search_path TO happy_sunshine;

EXPLAIN ANALYZE
SELECT
    t.ticket_id,
    t.aktueller_status,
    t.prioritaet,
    k.vorname,
    k.nachname
FROM tickets t
JOIN kunden k
    ON t.kunden_id = k.kunden_id
WHERE t.aktueller_status = 'offen'
  AND t.prioritaet = 'hoch';


/*
  "Nested Loop  (cost=5.04..366.91 rows=46 width=41) (actual time=0.084..0.420 rows=50.00 loops=1)"
"  Buffers: shared hit=190 read=2"
"  ->  Bitmap Heap Scan on tickets t  (cost=4.75..76.99 rows=46 width=36) (actual time=0.070..0.128 rows=50.00 loops=1)"
"        Recheck Cond: (((aktueller_status)::text = 'offen'::text) AND ((prioritaet)::text = 'hoch'::text))"
"        Heap Blocks: exact=40"
"        Buffers: shared hit=40 read=2"
"        ->  Bitmap Index Scan on idx_tickets_status_prio  (cost=0.00..4.74 rows=46 width=0) (actual time=0.044..0.044 rows=50.00 loops=1)"
"              Index Cond: (((aktueller_status)::text = 'offen'::text) AND ((prioritaet)::text = 'hoch'::text))"
"              Index Searches: 1"
"              Buffers: shared read=2"
"  ->  Index Scan using kunden_pkey on kunden k  (cost=0.29..6.30 rows=1 width=21) (actual time=0.006..0.006 rows=1.00 loops=50)"
"        Index Cond: ((kunden_id)::text = (t.kunden_id)::text)"
"        Index Searches: 50"
"        Buffers: shared hit=150"
"Planning:"
"  Buffers: shared hit=49 read=3"
"Planning Time: 12.083 ms"
"Execution Time: 0.455 ms"

*/

DROP INDEX IF EXISTS happy_sunshine.idx_tickets_status_prio;

EXPLAIN ANALYZE
SELECT
    t.ticket_id,
    t.aktueller_status,
    t.prioritaet,
    k.vorname,
    k.nachname
FROM happy_sunshine.tickets t
JOIN happy_sunshine.kunden k
    ON t.kunden_id = k.kunden_id
WHERE t.aktueller_status = 'offen'
  AND t.prioritaet = 'hoch';


  CREATE INDEX idx_tickets_status_prio
ON happy_sunshine.tickets (aktueller_status, prioritaet);

EXPLAIN ANALYZE
SELECT
    t.ticket_id,
    t.aktueller_status,
    t.prioritaet,
    k.vorname,
    k.nachname
FROM happy_sunshine.tickets t
JOIN happy_sunshine.kunden k
    ON t.kunden_id = k.kunden_id
WHERE t.aktueller_status = 'offen'
  AND t.prioritaet = 'hoch';



-- Management View


CREATE VIEW vw_management AS
SELECT
    COUNT(*) AS tickets_gesamt,
    ROUND(AVG(bearbeitungsdauer_stunden), 0) AS avg_bearbeitungszeit_minuten,
    SUM(CASE WHEN eskaliert = 1 THEN 1 ELSE 0 END) AS eskalationen
FROM tickets;

SELECT * FROM vw_management;

-- Management View für einen festen Stichtag bis 16 Uhr
DROP VIEW IF EXISTS vw_management_stichtag_2803;

CREATE VIEW vw_management_stichtag_2803 AS
SELECT
    DATE '2025-03-28' AS stichtag,
    TIME '16:00:00' AS stand_uhrzeit,

    -- Calls / Interaktionen
    (
        SELECT COUNT(*)
        FROM interaktionen i
        WHERE i.interaktion_datum = DATE '2025-03-28'
          AND i.interaktion_uhrzeit <= TIME '16:00:00'
    ) AS calls_bis_jetzt,

    (
        SELECT COUNT(*)
        FROM interaktionen i
        WHERE i.interaktion_datum = DATE '2025-03-28'
          AND i.interaktion_uhrzeit <= TIME '16:00:00'
          AND i.anruf_ergebnis = 'answered'
    ) AS angenommene_calls_bis_jetzt,

    (
        SELECT ROUND(
            100.0 * COUNT(*) FILTER (WHERE i.anruf_ergebnis = 'answered')
            / NULLIF(COUNT(*), 0),
            0
        )
        FROM interaktionen i
        WHERE i.interaktion_datum = DATE '2025-03-28'
          AND i.interaktion_uhrzeit <= TIME '16:00:00'
    ) AS erreichbarkeit_prozent_heute,

    -- Tickets
    (
        SELECT COUNT(*)
        FROM tickets t
        WHERE DATE(t.erstellt_am) = DATE '2025-03-28'
          AND CAST(t.erstellt_am AS time) <= TIME '16:00:00'
    ) AS tickets_erstellt_heute,

    (
        SELECT COUNT(*)
        FROM tickets t
        WHERE DATE(t.erstellt_am) = DATE '2025-03-28'
          AND CAST(t.erstellt_am AS time) <= TIME '16:00:00'
          AND t.aktueller_status = 'geschlossen'
    ) AS tickets_geschlossen_heute,

    (
        SELECT COUNT(*)
        FROM tickets t
        WHERE DATE(t.erstellt_am) = DATE '2025-03-28'
          AND CAST(t.erstellt_am AS time) <= TIME '16:00:00'
          AND t.aktueller_status <> 'geschlossen'
    ) AS tickets_offen_heute,

    (
        SELECT COUNT(*)
        FROM tickets t
        WHERE DATE(t.erstellt_am) = DATE '2025-03-28'
          AND CAST(t.erstellt_am AS time) <= TIME '16:00:00'
          AND t.eskaliert = 1
    ) AS tickets_eskaliert_heute;

SELECT * 
FROM vw_management_stichtag_2803;



-- =========================================
-- Calls nach Support Level und Erfahrungslevel
-- =========================================

SELECT
    CASE
        WHEN m.support_level = 'first_level' THEN 'First Level'
        WHEN m.support_level = 'second_level' THEN 'Second Level'
        ELSE m.support_level
    END AS support_level,

    CASE
        WHEN m.erfahrungslevel = 'senior' THEN 'Senior'
        WHEN m.erfahrungslevel = 'junior' THEN 'Junior'
        ELSE m.erfahrungslevel
    END AS erfahrungslevel,

    COUNT(*) FILTER (
        WHERE i.interaktionstyp = 'call'
    ) AS anzahl_calls,

    ROUND(AVG(i.gespraechsdauer_sekunden), 2) AS avg_call_dauer_sekunden,

    COUNT(*) FILTER (
        WHERE i.wurde_transferiert = 1
    ) AS transfers

FROM happy_sunshine.interaktionen i

JOIN happy_sunshine.mitarbeiter m
    ON i.mitarbeiter_id = m.mitarbeiter_id

WHERE i.mitarbeiter_id IS NOT NULL

GROUP BY
    m.support_level,
    m.erfahrungslevel

ORDER BY
    support_level,
    erfahrungslevel DESC;


-- =========================================
-- Mitarbeiter Performance (inkl. Senior / Junior)
-- =========================================

SELECT
    m.mitarbeiter_id,
    m.vorname,
    m.nachname,

    CASE
        WHEN m.support_level = 'first_level' THEN 'First Level'
        WHEN m.support_level = 'second_level' THEN 'Second Level'
        ELSE m.support_level
    END AS support_level,

    CASE
        WHEN m.erfahrungslevel = 'senior' THEN 'Senior'
        WHEN m.erfahrungslevel = 'junior' THEN 'Junior'
        ELSE m.erfahrungslevel
    END AS erfahrungslevel,

    COUNT(*) FILTER (
        WHERE i.interaktionstyp = 'call'
    ) AS anzahl_calls,

    ROUND(AVG(i.gespraechsdauer_sekunden), 2) AS avg_call_dauer_sekunden,

    COUNT(*) FILTER (
        WHERE i.anruf_ergebnis = 'missed'
    ) AS missed_calls,

    ROUND(
        COUNT(*) FILTER (
            WHERE i.anruf_ergebnis = 'missed'
        )::numeric
        / NULLIF(
            COUNT(*) FILTER (
                WHERE i.interaktionstyp = 'call'
            ),
            0
        ) * 100,
        2
    ) AS missed_quote_prozent,

    COUNT(*) FILTER (
        WHERE i.wurde_transferiert = 1
    ) AS transfers,

    ROUND(
        COUNT(*) FILTER (
            WHERE i.wurde_transferiert = 1
        )::numeric
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS transferquote_prozent

FROM happy_sunshine.interaktionen i

JOIN happy_sunshine.mitarbeiter m
    ON i.mitarbeiter_id = m.mitarbeiter_id

WHERE i.mitarbeiter_id IS NOT NULL

GROUP BY
    m.mitarbeiter_id,
    m.vorname,
    m.nachname,
    m.support_level,
    m.erfahrungslevel

ORDER BY
    support_level,
    erfahrungslevel DESC,
    anzahl_calls DESC;


-- =========================================
-- Ticketleistung pro Mitarbeiter
-- Wer schließt wie viele Tickets?
-- inkl. Level, Erfahrungslevel und Eskalationen
-- =========================================

SELECT
    m.mitarbeiter_id,
    m.vorname,
    m.nachname,

    CASE
        WHEN m.support_level = 'first_level' THEN 'First Level'
        WHEN m.support_level = 'second_level' THEN 'Second Level'
        ELSE m.support_level
    END AS support_level,

    CASE
        WHEN m.erfahrungslevel = 'senior' THEN 'Senior'
        WHEN m.erfahrungslevel = 'junior' THEN 'Junior'
        ELSE m.erfahrungslevel
    END AS erfahrungslevel,

    COUNT(*) AS gesamt_tickets_bearbeitet,

    COUNT(*) FILTER (
        WHERE t.aktueller_status = 'geschlossen'
    ) AS tickets_geschlossen,

    COUNT(*) FILTER (
        WHERE t.eskaliert = 1
    ) AS tickets_eskaliert,

    ROUND(
        COUNT(*) FILTER (
            WHERE t.eskaliert = 1
        )::numeric
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS eskalationsquote_prozent,

    ROUND(AVG(t.bearbeitungsdauer_stunden), 2) AS durchschnitt_bearbeitungsdauer_stunden

FROM happy_sunshine.tickets t

JOIN happy_sunshine.mitarbeiter m
    ON t.aktueller_bearbeiter_id = m.mitarbeiter_id

GROUP BY
    m.mitarbeiter_id,
    m.vorname,
    m.nachname,
    m.support_level,
    m.erfahrungslevel

ORDER BY
    tickets_geschlossen DESC,
    tickets_eskaliert DESC;

	
-- ==============================================
--Bei welchem Mitarbeiter eskalieren die Tickets?
-- ==============================================


SELECT
    m.vorname || ' ' || m.nachname AS mitarbeiter_name,

    CASE
        WHEN m.support_level = 'first_level' THEN 'First Level'
        WHEN m.support_level = 'second_level' THEN 'Second Level'
        ELSE m.support_level
    END AS support_level,

    CASE
        WHEN m.erfahrungslevel = 'senior' THEN 'Senior'
        WHEN m.erfahrungslevel = 'junior' THEN 'Junior'
        ELSE m.erfahrungslevel
    END AS erfahrungslevel,

    COUNT(*) FILTER (
        WHERE t.eskaliert = 1
    ) AS eskalierte_tickets,

    COUNT(*) AS gesamt_tickets,

    ROUND(
        COUNT(*) FILTER (WHERE t.eskaliert = 1)::numeric
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS eskalationsquote_prozent

FROM happy_sunshine.tickets t

JOIN happy_sunshine.mitarbeiter m
    ON t.aktueller_bearbeiter_id = m.mitarbeiter_id

GROUP BY
    m.vorname,
    m.nachname,
    m.support_level,
    m.erfahrungslevel

ORDER BY
    eskalierte_tickets DESC;


-- =========================================
-- Eskalationen nach Mitarbeiter UND Anliegen
-- =========================================

SELECT
    m.vorname || ' ' || m.nachname AS mitarbeiter_name,

    CASE
        WHEN m.support_level = 'first_level' THEN 'First Level'
        WHEN m.support_level = 'second_level' THEN 'Second Level'
        ELSE m.support_level
    END AS support_level,

    CASE
        WHEN m.erfahrungslevel = 'senior' THEN 'Senior'
        WHEN m.erfahrungslevel = 'junior' THEN 'Junior'
        ELSE m.erfahrungslevel
    END AS erfahrungslevel,

    t.anliegen_typ,

    COUNT(*) FILTER (WHERE t.eskaliert = 1) AS eskalationen

FROM happy_sunshine.tickets t

JOIN happy_sunshine.mitarbeiter m
    ON t.aktueller_bearbeiter_id = m.mitarbeiter_id

GROUP BY
    m.vorname,
    m.nachname,
    m.support_level,
    m.erfahrungslevel,
    t.anliegen_typ

HAVING COUNT(*) FILTER (WHERE t.eskaliert = 1) > 0

ORDER BY
    mitarbeiter_name ASC;



-- =========================================
-- Teamstruktur: Anzahl Mitarbeiter nach Level und Erfahrung
-- =========================================

SELECT
    CASE 
        WHEN m.support_level = 'first_level' THEN 'First Level'
        WHEN m.support_level = 'second_level' THEN 'Second Level'
        ELSE m.support_level
    END AS support_level,

    CASE 
        WHEN m.erfahrungslevel = 'junior' THEN 'Junior'
        WHEN m.erfahrungslevel = 'senior' THEN 'Senior'
        ELSE m.erfahrungslevel
    END AS erfahrungslevel,

    COUNT(*) AS anzahl_mitarbeiter

FROM happy_sunshine.mitarbeiter m

WHERE m.aktiv = TRUE

GROUP BY
    support_level,
    erfahrungslevel

ORDER BY
    support_level,
    erfahrungslevel;



-- =========================================
-- Ticketstatus Übersicht
-- Wie viele Tickets sind in welchem Status?
-- =========================================

SELECT
    t.aktueller_status,

    COUNT(*) AS anzahl_tickets,

    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS anteil_prozent

FROM happy_sunshine.tickets t

GROUP BY
    t.aktueller_status

ORDER BY
    anzahl_tickets DESC;

-- =========================================
-- CSAT Score prüfen
-- =========================================

SELECT
    csat_score,
    COUNT(*) AS anzahl
FROM happy_sunshine.zufriedenheit
GROUP BY csat_score
ORDER BY csat_score;

-- =========================================
-- NPS Score prüfen
-- =========================================

SELECT
    ROUND(
        (
            COUNT(*) FILTER (WHERE nps_score >= 9) * 100.0 / COUNT(*)
        )
        -
        (
            COUNT(*) FILTER (WHERE nps_score <= 6) * 100.0 / COUNT(*)
        ),
    2) AS nps_score_berechnet
FROM happy_sunshine.zufriedenheit;

-- =========================================
-- Wie lange waren Tickets offen?
-- von erstellt_am bis geschlossen_am
-- =========================================

SELECT
    t.ticket_id,
    t.anliegen_typ,
    t.prioritaet,
    t.aktueller_status,
    t.erstellt_am,
    t.geschlossen_am,

    ROUND(
        EXTRACT(EPOCH FROM (t.geschlossen_am - t.erstellt_am)) / 3600,
        2
    ) AS offen_dauer_stunden,

    ROUND(
        EXTRACT(EPOCH FROM (t.geschlossen_am - t.erstellt_am)) / 86400,
        2
    ) AS offen_dauer_tage

FROM happy_sunshine.tickets t

WHERE t.geschlossen_am IS NOT NULL

ORDER BY offen_dauer_stunden DESC;


-- =========================================
-- Durchschnittliche Offenzeit aller geschlossenen Tickets
-- =========================================

SELECT
    COUNT(*) AS anzahl_geschlossene_tickets,

    ROUND(
        AVG(EXTRACT(EPOCH FROM (t.geschlossen_am - t.erstellt_am)) / 3600),
        2
    ) AS avg_offen_dauer_stunden,

    ROUND(
        AVG(EXTRACT(EPOCH FROM (t.geschlossen_am - t.erstellt_am)) / 86400),
        2
    ) AS avg_offen_dauer_tage

FROM happy_sunshine.tickets t

WHERE t.geschlossen_am IS NOT NULL;



-- =========================================
-- Wie viele Tickets kommen pro Tag rein?
-- =========================================

SELECT
    DATE(t.erstellt_am) AS datum,
    COUNT(*) AS eingegangene_tickets

FROM happy_sunshine.tickets t

GROUP BY DATE(t.erstellt_am)

ORDER BY datum;




-- =========================================
-- Wie viele Tickets kommen pro Monat rein?
-- =========================================

SELECT
    EXTRACT(YEAR FROM t.erstellt_am) AS jahr,
    EXTRACT(MONTH FROM t.erstellt_am) AS monat,
    COUNT(*) AS eingegangene_tickets

FROM happy_sunshine.tickets t

GROUP BY
    EXTRACT(YEAR FROM t.erstellt_am),
    EXTRACT(MONTH FROM t.erstellt_am)

ORDER BY
    jahr,
    monat;


-- =========================================
-- Wie viele Tickets kommen je Anliegen rein?
-- =========================================

SELECT
    t.anliegen_typ,
    COUNT(*) AS eingegangene_tickets

FROM happy_sunshine.tickets t

GROUP BY t.anliegen_typ

ORDER BY eingegangene_tickets DESC;

-- =========================================
-- Wie oft wurden Tickets erneut geöffnet?
-- Reopen = von geschlossen/geloest zurück in offenen Status
-- =========================================

WITH statuswechsel AS
(
    SELECT
        tsh.ticket_id,
        tsh.status,
        tsh.geaendert_am,

        LAG(LOWER(tsh.status)) OVER
        (
            PARTITION BY tsh.ticket_id
            ORDER BY tsh.geaendert_am
        ) AS vorheriger_status,

        LOWER(tsh.status) AS aktueller_status

    FROM happy_sunshine.ticket_status_historie tsh
),

reopened_tickets AS
(
    SELECT
        sw.ticket_id,
        sw.geaendert_am AS reopened_am,
        sw.vorheriger_status,
        sw.aktueller_status
    FROM statuswechsel sw
    WHERE sw.vorheriger_status IN ('geschlossen', 'geloest')
      AND sw.aktueller_status IN ('offen', 'in bearbeitung', 'neu')
)

SELECT
    rt.ticket_id,
    COUNT(*) AS anzahl_reopens
FROM reopened_tickets rt
GROUP BY rt.ticket_id
ORDER BY anzahl_reopens DESC, rt.ticket_id;

-- =========================================
-- Gesamtübersicht Reopen
-- =========================================

WITH statuswechsel AS
(
    SELECT
        tsh.ticket_id,
        tsh.geaendert_am,
        LAG(LOWER(tsh.status)) OVER
        (
            PARTITION BY tsh.ticket_id
            ORDER BY tsh.geaendert_am
        ) AS vorheriger_status,
        LOWER(tsh.status) AS aktueller_status
    FROM happy_sunshine.ticket_status_historie tsh
),

reopened_tickets AS
(
    SELECT
        sw.ticket_id
    FROM statuswechsel sw
    WHERE sw.vorheriger_status IN ('geschlossen', 'geloest')
      AND sw.aktueller_status IN ('offen', 'in bearbeitung', 'neu')
)

SELECT
    COUNT(*) AS gesamt_reopens,
    COUNT(DISTINCT ticket_id) AS betroffene_tickets
FROM reopened_tickets;


-- =========================================
-- First Response Time pro Ticket
-- =========================================

SELECT
    t.ticket_id,
    t.anliegen_typ,
    t.prioritaet,
    t.erstellt_am,
    t.erste_reaktion_am,

    ROUND(
        EXTRACT(EPOCH FROM (t.erste_reaktion_am - t.erstellt_am)) / 3600,
        2
    ) AS first_response_time_stunden

FROM happy_sunshine.tickets t

WHERE t.erste_reaktion_am IS NOT NULL

ORDER BY first_response_time_stunden DESC;



SELECT
    ROUND(
        AVG(EXTRACT(EPOCH FROM (t.erste_reaktion_am - t.erstellt_am)) / 3600),
        2
    ) AS avg_first_response_time_stunden
FROM happy_sunshine.tickets t
WHERE t.erste_reaktion_am IS NOT NULL;


-- =========================================
-- Wie viele Kontakte gibt es pro Ticket?
-- =========================================

SELECT
    t.ticket_id,
    t.anliegen_typ,
    COUNT(i.interaktion_id) AS kontakte_pro_ticket
FROM happy_sunshine.tickets t
LEFT JOIN happy_sunshine.interaktionen i
    ON t.kunden_id = i.kunden_id
GROUP BY
    t.ticket_id,
    t.anliegen_typ
ORDER BY kontakte_pro_ticket DESC;


-- =========================================
-- Offener Backlog nach Priorität
-- =========================================

SELECT
    t.prioritaet,
    COUNT(*) AS offene_tickets
FROM happy_sunshine.tickets t
WHERE t.aktueller_status <> 'geschlossen'
GROUP BY t.prioritaet
ORDER BY offene_tickets DESC;



-- =========================================
-- Alte offene Tickets
-- =========================================

SELECT
    t.ticket_id,
    t.anliegen_typ,
    t.prioritaet,
    t.aktueller_status,
    t.erstellt_am,
    ROUND(
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - t.erstellt_am)) / 3600,
        2
    ) AS offene_stunden
FROM happy_sunshine.tickets t
WHERE t.aktueller_status <> 'geschlossen'
ORDER BY offene_stunden DESC;


-- =========================================
-- Durchschnittliche Bearbeitungsdauer nach Anliegen
-- =========================================

SELECT
    t.anliegen_typ,
    COUNT(*) AS anzahl_tickets,
    ROUND(AVG(t.bearbeitungsdauer_stunden), 2) AS avg_bearbeitungsdauer_stunden
FROM happy_sunshine.tickets t
WHERE t.bearbeitungsdauer_stunden IS NOT NULL
GROUP BY t.anliegen_typ
ORDER BY avg_bearbeitungsdauer_stunden DESC;



-- =========================================
-- CSAT nach Anliegen
-- =========================================

SELECT
    t.anliegen_typ,
    COUNT(z.zufriedenheit_id) AS anzahl_bewertungen,
    ROUND(AVG(z.csat_score), 2) AS avg_csat
FROM happy_sunshine.tickets t
JOIN happy_sunshine.zufriedenheit z
    ON t.ticket_id = z.ticket_id
GROUP BY t.anliegen_typ
ORDER BY avg_csat ASC;


-- =========================================
-- CSAT nach aktuellem Bearbeiter
-- =========================================

SELECT
    m.vorname,
    m.nachname,
    COUNT(z.zufriedenheit_id) AS anzahl_bewertungen,
    ROUND(AVG(z.csat_score), 2) AS avg_csat
FROM happy_sunshine.tickets t
JOIN happy_sunshine.mitarbeiter m
    ON t.aktueller_bearbeiter_id = m.mitarbeiter_id
JOIN happy_sunshine.zufriedenheit z
    ON t.ticket_id = z.ticket_id
GROUP BY
    m.vorname,
    m.nachname
ORDER BY avg_csat ASC;



-- =========================================
-- Peak-Zeiten je Kanal
-- =========================================

SELECT
    k.kanal_name,
    i.wochentag,
    EXTRACT(HOUR FROM i.interaktion_uhrzeit) AS stunde,
    COUNT(*) AS anzahl_interaktionen
FROM happy_sunshine.interaktionen i
JOIN happy_sunshine.kanaele k
    ON i.kanal_id = k.kanal_id
GROUP BY
    k.kanal_name,
    i.wochentag,
    EXTRACT(HOUR FROM i.interaktion_uhrzeit)
ORDER BY
    k.kanal_name,
    anzahl_interaktionen DESC;



-- =========================================
-- Transferquote nach Anliegen
-- =========================================

SELECT
    i.anliegen_typ,
    COUNT(*) AS gesamt_interaktionen,
    COUNT(*) FILTER (WHERE i.wurde_transferiert = 1) AS transfers,
    ROUND(
        COUNT(*) FILTER (WHERE i.wurde_transferiert = 1)::numeric
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS transferquote_prozent
FROM happy_sunshine.interaktionen i
GROUP BY i.anliegen_typ
ORDER BY transferquote_prozent DESC;


-- =========================================
-- Welche Kunden melden sich besonders oft?
-- Kundenname in einer Spalte
-- =========================================

SELECT
    i.kunden_id,
    k.vorname || ' ' || k.nachname AS kundenname,
    COUNT(*) AS anzahl_kontakte

FROM happy_sunshine.interaktionen i

JOIN happy_sunshine.kunden k
    ON i.kunden_id = k.kunden_id

GROUP BY
    i.kunden_id,
    k.vorname,
    k.nachname

ORDER BY anzahl_kontakte DESC, kundenname ASC;