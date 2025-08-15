import mysql.connector
from mysql.connector import Error
from faker import Faker
import random

DB_CONFIG = dict(
    host="localhost",
    user="root",      # your MySQL username
    password="1234",  # your MySQL password
    database="CarDealership"
)

fake = Faker()

def get_conn():
    return mysql.connector.connect(**DB_CONFIG)

def ensure_seed_cars(cursor):
    cursor.execute("SELECT COUNT(*) FROM Cars")
    count = cursor.fetchone()[0]
    if count == 0:
        cars = [
            ("Toyota","Fortuner",2024,3500000.00),
            ("Hyundai","Creta",2025,1600000.00),
            ("Maruti","Swift",2023,1200000.00),
            ("BMW","X5",2024,9000000.00),
            ("Kia","Seltos",2025,1800000.00),
            ("Tata","Harrier",2024,2400000.00),
            ("Mercedes","GLS 450",2025,11200000.00),
            ("Audi","Q7",2024,8900000.00),
            ("Mahindra","XUV700",2024,2300000.00),
            ("Honda","City",2024,1500000.00),
        ]
        cursor.executemany(
            "INSERT INTO Cars (brand, model, year, price) VALUES (%s,%s,%s,%s)",
            cars
        )

def add_customers(n=50):
    try:
        conn = get_conn()
        cur = conn.cursor()
        rows = []
        for _ in range(n):
            name = fake.name()
            city = fake.city()
            email = fake.unique.email()
            phone = fake.msisdn()[:10]
            rows.append((name, city, email, phone))
        cur.executemany(
            "INSERT INTO Customers (name, city, email, phone) VALUES (%s,%s,%s,%s)",
            rows
        )
        conn.commit()
        print(f"Inserted {n} customers.")
    except Error as e:
        print("Error inserting customers:", e)
    finally:
        try:
            cur.close(); conn.close()
        except:
            pass

def add_sales(n=200):
    try:
        conn = get_conn()
        cur = conn.cursor()

        # Ensure cars exist
        ensure_seed_cars(cur)
        conn.commit()

        cur.execute("SELECT customer_id FROM Customers")
        customers = [r[0] for r in cur.fetchall()]
        if not customers:
            print("No customers found. Please insert customers first.")
            return

        cur.execute("SELECT car_id, price FROM Cars")
        cars = cur.fetchall()
        if not cars:
            print("No cars found.")
            return

        rows = []
        for _ in range(n):
            customer_id = random.choice(customers)
            car_id, price = random.choice(cars)
            sale_date = fake.date_between(start_date='-180d', end_date='today')
            quantity = 1
            total_amount = float(price) * quantity
            rows.append((customer_id, car_id, sale_date, quantity, total_amount))

        cur.executemany(
            "INSERT INTO Sales (customer_id, car_id, sale_date, quantity, total_amount) VALUES (%s,%s,%s,%s,%s)",
            rows
        )
        conn.commit()
        print(f"Inserted {n} sales.")
    except Error as e:
        print("Error inserting sales:", e)
    finally:
        try:
            cur.close(); conn.close()
        except:
            pass

if __name__ == "__main__":
    # You can tweak these numbers
    add_customers(80)   # Adds 80 extra customers
    add_sales(300)      # Adds 300 sales linked to existing customers/cars
