# SAP_tests

# ZMODERN_PURCHASE_ORDER_LIST
This code allows the user to quickly retrieve and display purchase order data based on the specified conditions.

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

## Output example
```abap
Bestellnr: 4500000012   Pos: 0010   Material: 12345678   Menge: 100,000   Preis: 150,00   Währung: EUR
Bestellnr: 4500000013   Pos: 0010   Material: 87654321   Menge: 200,000   Preis: 200,00   Währung: USD
```


# ZCUSTOMER_DATA_EXPORT
This program not only retrieves and displays customer data based on the entered city name but also exports these data to a CSV file for further analysis or reporting, adding significant utility to the original functionality.

### REPORT ZCUSTOMER_DATA_EXPORT.

This declares an ABAP program with the name ZCUSTOMER_DATA_EXPORT, indicating to the SAP system that a new program starts here.
### PARAMETERS: p_city TYPE kna1-ort01 OBLIGATORY.

Defines a parameter p_city of type kna1-ort01, which will be used to input the city name. This parameter is mandatory for execution.
### TYPES: BEGIN OF ty_customer, ... END OF ty_customer.

This defines a structure named ty_customer which includes fields for customer number, name, city, country, region, and phone number, each corresponding to a field in the KNA1 table.
### DATA: lt_customers TYPE STANDARD TABLE OF ty_customer WITH EMPTY KEY.

Creates an internal table lt_customers of type STANDARD TABLE, which will hold customer data. The table consists of rows of type ty_customer and has an empty key, allowing duplicate entries.
### SELECT kunnr name1 ort01 land1 regio telf1 INTO TABLE lt_customers FROM kna1 WHERE ort01 = p_city UP TO 20 ROWS.

Executes an SQL query to select data from the KNA1 table, retrieving the customer data based on the entered city name (p_city). Results are stored in the internal table lt_customers, with a limit of 20 rows.
### LOOP AT lt_customers INTO DATA(ls_customer).

Starts a loop to iterate over each row in the internal table lt_customers, assigning the current row to the variable ls_customer.
### WRITE: ...

Outputs the field values of the current row to the screen. Each field (customer number, name, city, country, region, and phone number) is displayed with descriptive text.
### OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

Opens a file named Customer_Data.csv in text mode for writing. This is done to prepare for exporting the data to a CSV file.
### TRANSFER 'Kundennr,Name,Stadt,Land,Region,Telefon' TO lv_file.

Writes the column headers to the CSV file.
### LOOP AT lt_customers INTO ls_customer.

Iterates over each row in the internal table lt_customers again for exporting the data to the CSV file.
### DATA(lv_line) = ...

Forms a line of customer data in CSV format by concatenating fields separated by commas.
### TRANSFER lv_line TO lv_file.

Writes the formed line of customer data to the CSV file.
### CLOSE DATASET lv_file.

Closes the CSV file after writing all data.

### Output example
'Berlin' as a p_city
```abap
Kundennr: 100001   Name: ABC Corp          Stadt: Berlin   Land: DE   Region: BE   Telefon: 0301234567
Kundennr: 100002   Name: XYZ Ltd           Stadt: Berlin   Land: DE   Region: BE   Telefon: 0307654321
...
```
#### Customer_Data.csv:
```abap
Kundennr,Name,Stadt,Land,Region,Telefon
100001,ABC Corp,Berlin,DE,BE,0301234567
100002,XYZ Ltd,Berlin,DE,BE,0307654321
...
```
# ZCUSTOMER_SALES_REPORT
This provides a powerful tool for analyzing customer order data interactively within SAP GUI and the ability to export this data for further analysis or reporting.

### PARAMETERS: p_city TYPE kna1-ort01 OBLIGATORY.

This parameter p_city allows for the input of a city name to filter customer data. It is mandatory for execution.
### Define types for customer, order, and report structures:

ty_customer: Structure for customer data.
ty_order: Structure for order data.
ty_report: Combined structure for the final report to be displayed and exported.
### Create internal tables:

lt_customers: To store customer data.
lt_orders: To store order data.
lt_report: To store final report data combining customer and order data.
### Data selection:

SELECT ... INTO TABLE lt_customers: Gets customer data from KNA1 filtered by the city (parameter p_city).
SELECT ... INTO TABLE lt_orders: Gets order data from VBAK for all selected customers (using FOR ALL ENTRIES).
### Merge customer and order data:

Nested loops combine customer and order data into the lt_report table.
### ALV Display:

Creates and initializes an ALV Grid.
Sets the screen status and title.
Displays the data in lt_report using ALV.
### User command handling:

Handles user commands, such as exporting data to CSV or exiting the program.
### Export to CSV:

FORM export_to_csv.: Opens a file, writes headers, loops through the report data (lt_report), writes each record to the CSV file, and closes the file.
Displays a message indicating a successful export.
## Example Output:
### SAP GUI ALV Report
* Interactive report with columns: Customer No, Name, City, Country, Region, Phone, Order No, Order Date, Order Amount.
* Users can sort, filter, and interact with the displayed data.
### CSV File
```abap
Customer No, Name, City, Country, Region, Phone, Order No, Order Date, Order Amount
100001,ABC Corp,Berlin,DE,BE,0301234567,4500000010,2023-01-01,1000.00
100002,XYZ Ltd,Berlin,DE,BE,0307654321,4500000011,2023-01-02,1500.00
...
```
