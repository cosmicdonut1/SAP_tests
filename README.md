# SAP_tests
small tests

## ZMODERN_PURCHASE_ORDER_LIST

### REPORT ZMODERN_PURCHASE_ORDER_LIST.
This is the declaration of an ABAP program named `ZMODERN_PURCHASE_ORDER_LIST`. It informs the SAP system that a new program is starting.

### TYPES: BEGIN OF ty_porders, ... END OF ty_porders.
This defines a data structure named `ty_porders`. This structure contains several fields (purchase order number, purchase order item, material number, etc.), each corresponding to a field from the EKPO table.

### DATA: lt_porders TYPE STANDARD TABLE OF ty_porders WITH EMPTY KEY.
This creates an internal table `lt_porders` of type STANDARD TABLE. The table consists of rows of type `ty_porders` and has an empty key, allowing duplicate entries.

### SELECT ... INTO TABLE lt_porders ... WHERE loekz = '' AND netpr > 100.
This executes an SQL query that selects data from the EKPO table based on the specified conditions (the `loekz` field is empty and the `netpr` field is greater than 100). The selected data is stored in the internal table `lt_porders`. The number of selected rows is limited to 10.

### LOOP AT lt_porders INTO DATA(ls_porder).
This starts a loop through the internal table `lt_porders`. The current row is saved into a temporary structure `ls_porder`.

### WRITE: ...
This outputs the field values of the current row to the screen with explanatory text. Each line of output starts with a new line (`/`).

### ENDLOOP.
This ends the LOOP cycle.

## Output
```abap
Bestellnr: 4500000012   Pos: 0010   Material: 12345678   Menge: 100,000   Preis: 150,00   Währung: EUR
Bestellnr: 4500000013   Pos: 0010   Material: 87654321   Menge: 200,000   Preis: 200,00   Währung: USD
```
