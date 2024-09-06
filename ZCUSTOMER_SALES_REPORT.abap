REPORT ZCUSTOMER_SALES_REPORT.

* Definition von Parametern für die Filterung
PARAMETERS: p_city TYPE kna1-ort01 OBLIGATORY.  " Eingabe der Stadt zur Filterung von Kunden (obligatorischer Parameter)

* Schritt 1: Definition von Strukturen zur Speicherung von Kundendaten und Aufträgen
TYPES: BEGIN OF ty_customer,
         kunnr TYPE kna1-kunnr,  " Kundennummer (Kundennummer)
         name1 TYPE kna1-name1,  " Kundenname (Name der Organisation 1)
         ort01 TYPE kna1-ort01,  " Stadt (Ort)
         land1 TYPE kna1-land1,  " Land (Land)
         regio TYPE kna1-regio,  " Region (Region)
         telf1 TYPE kna1-telf1,  " Telefon (Telefon)
       END OF ty_customer.

TYPES: BEGIN OF ty_order,
         vbeln TYPE vbak-vbeln,  " Auftragsnummer (Verkaufsbelegnummer)
         erdat TYPE vbak-erdat,  " Erstellungsdatum (Erstellungsdatum)
         netwr TYPE vbak-netwr,  " Auftragswert (Nettowert)
         kunnr TYPE vbak-kunnr,  " Kundennummer (Kundennummer)
       END OF ty_order.

TYPES: BEGIN OF ty_report,
         kunnr TYPE kna1-kunnr,  " Kundennummer (Kundennummer)
         name1 TYPE kna1-name1,  " Kundenname (Name der Organisation 1)
         ort01 TYPE kna1-ort01,  " Stadt (Ort)
         land1 TYPE kna1-land1,  " Land (Land)
         regio TYPE kna1-regio,  " Region (Region)
         telf1 TYPE kna1-telf1,  " Telefon (Telefon)
         vbeln TYPE vbak-vbeln,  " Auftragsnummer (Verkaufsbelegnummer)
         erdat TYPE vbak-erdat,  " Erstellungsdatum (Erstellungsdatum)
         netwr TYPE vbak-netwr   " Auftragswert (Nettowert)
       END OF ty_report.

* Schritt 2: Erstellen von internen Tabellen zur Speicherung der Daten
DATA: lt_customers TYPE STANDARD TABLE OF ty_customer WITH EMPTY KEY.
DATA: lt_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY.
DATA: lt_report TYPE STANDARD TABLE OF ty_report WITH EMPTY KEY.

* Schritt 3: Auswahl von Daten aus den Tabellen KNA1 und VBAK
SELECT kunnr name1 ort01 land1 regio telf1
  INTO TABLE lt_customers
  FROM kna1
  WHERE ort01 = p_city.  " Filterung nach eingegebener Stadt (Parameter p_city)

SELECT vbeln erdat netwr kunnr
  INTO TABLE lt_orders
  FROM vbak
  FOR ALL ENTRIES IN lt_customers
  WHERE kunnr = lt_customers-kunnr.

* Schritt 4: Zusammenführen von Kunden- und Auftragsdaten
LOOP AT lt_customers INTO DATA(ls_customer).
  LOOP AT lt_orders INTO DATA(ls_order)
    WHERE kunnr = ls_customer-kunnr.
    DATA(ls_report) = VALUE ty_report(
      kunnr = ls_customer-kunnr
      name1 = ls_customer-name1
      ort01 = ls_customer-ort01
      land1 = ls_customer-land1
      regio = ls_customer-regio
      telf1 = ls_customer-telf1
      vbeln = ls_order-vbeln
      erdat = ls_order-erdat
      netwr = ls_order-netwr ).
    APPEND ls_report TO lt_report.
  ENDLOOP.
ENDLOOP.

* Schritt 5: Darstellung der Daten mit ALV
DATA: alv_grid TYPE REF TO cl_gui_alv_grid.
DATA: alv_container TYPE REF TO cl_gui_custom_container.

CALL SCREEN 100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'SCREEN_100'.
  SET TITLEBAR 'SCREEN_100'.

  IF alv_container IS INITIAL AND alv_grid IS INITIAL.
    CREATE OBJECT alv_container
      EXPORTING
        container_name = 'ALV_CONTAINER'.

    CREATE OBJECT alv_grid
      EXPORTING
        i_parent = alv_container.

    CALL METHOD alv_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = 'TY_REPORT'
      CHANGING
        it_outtab = lt_report.
  ENDIF.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'EXPORT'.
      PERFORM export_to_csv.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

FORM export_to_csv.
  DATA: lv_file TYPE string VALUE 'C:\TEMP\Customer_Sales_Data.csv'.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  TRANSFER 'Customer No, Name, City, Country, Region, Phone, Order No, Order Date, Order Amount' TO lv_file.

  LOOP AT lt_report INTO DATA(ls_report).
    DATA(lv_line) = |{ ls_report-kunnr },{ ls_report-name1 },{ ls_report-ort01 },{ ls_report-land1 },{ ls_report-regio },{ ls_report-telf1 },{ ls_report-vbeln },{ ls_report-erdat },{ ls_report-netwr }|.
    TRANSFER lv_line TO lv_file.
  ENDLOOP.

  CLOSE DATASET lv_file.
  MESSAGE 'Data exported to CSV.' TYPE 'S'.
ENDFORM.
