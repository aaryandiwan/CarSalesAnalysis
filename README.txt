hey everyone this is my new project.
Car Dealership sales SQL + Python Project.

Contents:-

1) create_tables_and_data.sql  -> Creates DB, tables, and seeds 20 customers, 10 cars, 20 sales
2) fake_data_generator.py      -> Adds more customers and sales using Faker (Python)

How to Run them 
A) SQL (MySQL Workbench or MySQL Shell)
   1. Open MySQL.
   2. Run: SOURCE <path>/create_tables_and_data.sql;
      Or open the file and execute in MySQL Workbench.

   This creates database CarDealership with sample data.

B) Python (Command Prompt/Terminal)
   1. Install requirements:
      pip install mysql-connector-python faker

   2. Edit DB credentials in fake_data_generator.py if needed (defaults: user=root, password=1234).

   3. Run:
      python fake_data_generator.py

   This will add ~80 customers and ~300 sales on top of the seeded data.

TO Verify:-
USE CarDealership;
SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Cars;
SELECT COUNT(*) FROM Sales;

Note:-
- Re-running create_tables_and_data.sql will DROP and recreate the database (clean reset).
- Emails are unique; if you run Python multiple times in the same session, Faker.unique prevents clashes.
