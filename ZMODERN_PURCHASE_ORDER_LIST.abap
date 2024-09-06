REPORT ZMODERN_PURCHASE_ORDER_LIST.

* Schritt 1: Definition einer Struktur zur Speicherung von Bestelldaten
TYPES: BEGIN OF ty_porders,
         ebeln TYPE ekpo-ebeln,  " Bestellnummer (Einkauf Beleg Nummer)
         ebelp TYPE ekpo-ebelp,  " Bestellposition (Einkauf Bestellung Position)
         matnr TYPE ekpo-matnr,  " Materialnummer (Material Nummer)
         menge TYPE ekpo-menge,  " Menge (Menge)
         netpr TYPE ekpo-netpr,  " Nettopreis (Netto Preis)
         waers TYPE ekpo-waers,  " Währung (Währung)
       END OF ty_porders.

* Schritt 2: Erstellen einer internen Tabelle zur Speicherung der Daten
DATA: lt_porders TYPE STANDARD TABLE OF ty_porders WITH EMPTY KEY.

* Schritt 3: Auswahl von Daten aus der EKPO-Tabelle mit spezifischen Kriterien
SELECT ebeln ebelp matnr menge netpr waers
  INTO TABLE lt_porders
  FROM ekpo
  UP TO 10 ROWS
  WHERE loekz = '' AND netpr > 100.  " Auswahlkriterien (kein Löschkennzeichen, Preis > 100)

* Schritt 4: Schleife durch die Daten und Ausgabe
LOOP AT lt_porders INTO DATA(ls_porder).
  WRITE: / 'Bestellnr:', ls_porder-ebeln,   " Bestellnummer
         'Pos:', ls_porder-ebelp,           " Bestellposition
         'Material:', ls_porder-matnr,      " Materialnummer
         'Menge:', ls_porder-menge,         " Menge
         'Preis:', ls_porder-netpr,         " Nettopreis
         'Währung:', ls_porder-waers.       " Währung
ENDLOOP.
