import mysql.connector

# Database connection setup
def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",  # Change this if your MySQL user is different
        password="BSHitman@999",  # Enter your MySQL password
        database="InfiComm"  # Change this to your actual database
    )

# Insert a new customer
def insert_customer():
    db = connect_db()
    cursor = db.cursor()

    user_id = input("Enter user ID: ")
    dob = input("Enter date of birth (YYYY-MM-DD, optional, press Enter to skip): ") or None
    gender = input("Enter gender (Male/Female/Other, optional, press Enter to skip): ") or None
    national_id = input("Enter national ID: ")
    customer_type = input("Enter customer type (Individual/Business): ")

    sql = "INSERT INTO customer (user_id, dob, gender, national_id, customer_type) VALUES (%s, %s, %s, %s, %s)"
    values = (user_id, dob, gender, national_id, customer_type)

    try:
        cursor.execute(sql, values)
        db.commit()
        print(f"Customer with User ID {user_id} added successfully!")
    except mysql.connector.Error as err:
        print("Error:", err)

    db.close()

# Read customer data
def read_customers():
    db = connect_db()
    cursor = db.cursor()

    choice = input("Do you want to view all customers? (yes/no): ").strip().lower()
    if choice == "no":
        customer_id = input("Enter Customer ID to fetch details: ")
        cursor.execute("SELECT * FROM customer WHERE customer_id = %s", (customer_id,))
    else:
        cursor.execute("SELECT * FROM customer")

    results = cursor.fetchall()
    for row in results:
        print(row)

    db.close()

# Update a customer
def update_customer():
    db = connect_db()
    cursor = db.cursor()

    customer_id = input("Enter Customer ID to update: ")
    column = input("Enter column to update (dob, gender, national_id, customer_type): ").strip().lower()
    new_value = input(f"Enter new value for {column}: ")

    sql = f"UPDATE customer SET {column} = %s WHERE customer_id = %s"
    cursor.execute(sql, (new_value, customer_id))
    db.commit()
    print(f"Customer ID {customer_id} updated successfully!")
    db.close()

# Delete a customer
def delete_customer():
    db = connect_db()
    cursor = db.cursor()

    customer_id = input("Enter Customer ID to delete: ")
    cursor.execute("DELETE FROM customer WHERE customer_id = %s", (customer_id,))
    db.commit()
    print(f"Customer ID {customer_id} deleted successfully!")
    db.close()

# Main menu
def main():

    while True:
        print("\nMenu:")
        print("1. Insert Customer")
        print("2. Read Customers")
        print("3. Update Customer")
        print("4. Delete Customer")
        print("5. Exit")

        choice = input("Enter your choice: ").strip()

        if choice == "1":
            insert_customer()
        elif choice == "2":
            read_customers()
        elif choice == "3":
            update_customer()
        elif choice == "4":
            delete_customer()
        elif choice == "5":
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
