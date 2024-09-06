REPORT ZCUSTOMER_DATA_EXPORT.  " Definition des Programms mit dem Namen ZCUSTOMER_DATA_EXPORT

* Definition des Eingabeparameters für die Filterung
PARAMETERS: p_city TYPE kna1-ort01 OBLIGATORY.  " Eingabe der Stadt zur Filterung von Kunden (obligatorischer Parameter)

* Schritt 1: Definition einer Struktur zur Speicherung von Kundendaten
TYPES: BEGIN OF ty_customer,
         kunnr TYPE kna1-kunnr,  " Kundennummer (Kundennummer)
         name1 TYPE kna1-name1,  " Kundenname (Name der Organisation 1)
         ort01 TYPE kna1-ort01,  " Stadt (Ort)
         land1 TYPE kna1-land1,  " Land (Land)
         regio TYPE kna1-regio,  " Region (Region)
         telf1 TYPE kna1-telf1,  " Telefon (Telefon)
       END OF ty_customer.

* Schritt 2: Erstellen einer internen Tabelle zur Speicherung von Daten
DATA: lt_customers TYPE STANDARD TABLE OF ty_customer WITH EMPTY KEY.

* Schritt 3: Auswahl von Daten aus der KNA1-Tabelle basierend auf dem eingegebenen Parameter
SELECT kunnr name1 ort01 land1 regio telf1
  INTO TABLE lt_customers
  FROM kna1
  WHERE ort01 = p_city  " Filterung nach eingegebener Stadt (Parameter p_city)
  UP TO 20 ROWS.  " Auswahl auf 20 Zeilen begrenzen

* Schritt 4: Verarbeitung und Ausgabe der Daten auf dem Bildschirm
LOOP AT lt_customers INTO DATA(ls_customer).
  WRITE:/ 'Kundennr:', ls_customer-kunnr,   " Kundennummer
         'Name:', ls_customer-name1,        " Kundenname
         'Stadt:', ls_customer-ort01,       " Stadt
         'Land:', ls_customer-land1,        " Land
         'Region:', ls_customer-regio,      " Region
         'Telefon:', ls_customer-telf1.     " Telefon
ENDLOOP.  " Ende der Schleife über die interne Tabelle

* Schritt 5: Export der Daten in eine CSV-Datei
DATA: lv_file TYPE string VALUE 'C:\TEMP\Customer_Data.csv'.  " Definition des Dateipfads
OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  " Datei zum Schreiben im Textmodus öffnen

* Schreiben der Spaltenüberschriften
TRANSFER 'Kundennr,Name,Stadt,Land,Region,Telefon' TO lv_file.

* Schreiben der Kundendaten
LOOP AT lt_customers INTO ls_customer.
  DATA(lv_line) = |{ ls_customer-kunnr },{ ls_customer-name1 },{ ls_customer-ort01 },{ ls_customer-land1 },{ ls_customer-regio },{ ls_customer-telf1 }|.
  TRANSFER lv_line TO lv_file.
ENDLOOP.

CLOSE DATASET lv_file.  " Datei nach dem Schreiben schließen
