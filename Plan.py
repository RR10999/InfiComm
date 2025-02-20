import mysql.connector

# Database connection setup
def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",  # Change this if your MySQL user is different
        password="BSHitman@999",  # Enter your MySQL password
        database="InfiComm"  # Change this to your actual database
    )

# Insert a new plan
def insert_plan():
    db = connect_db()
    cursor = db.cursor()

    name = input("Enter plan name: ")
    price = float(input("Enter price: "))
    validity_days = int(input("Enter validity days: "))
    data_limit = input("Enter data limit (GB, optional, press Enter to skip): ") or None
    call_minutes = input("Enter call minutes (optional, press Enter to skip): ") or None
    sms_limit = input("Enter SMS limit (optional, press Enter to skip): ") or None

    sql = "INSERT INTO plan (name, price, validity_days, data_limit, call_minutes, sms_limit) VALUES (%s, %s, %s, %s, %s, %s)"
    values = (name, price, validity_days, data_limit, call_minutes, sms_limit)

    cursor.execute(sql, values)
    db.commit()
    print(f"Plan '{name}' added successfully!")
    db.close()

# Read plans (all or specific)
def read_plans():
    db = connect_db()
    cursor = db.cursor()

    choice = input("Do you want to view all plans? (yes/no): ").strip().lower()
    if choice == "no":
        plan_id = input("Enter Plan ID to fetch details: ")
        cursor.execute("SELECT * FROM plan WHERE plan_id = %s", (plan_id,))
    else:
        cursor.execute("SELECT * FROM plan")

    results = cursor.fetchall()
    for row in results:
        print(row)

    db.close()

# Update a plan
def update_plan():
    db = connect_db()
    cursor = db.cursor()

    plan_id = input("Enter Plan ID to update: ")
    column = input("Enter column to update (name, price, validity_days, data_limit, call_minutes, sms_limit): ").strip().lower()
    new_value = input(f"Enter new value for {column}: ")

    sql = f"UPDATE plan SET {column} = %s WHERE plan_id = %s"
    cursor.execute(sql, (new_value, plan_id))
    db.commit()
    print(f"Plan ID {plan_id} updated successfully!")
    db.close()

# Delete a plan
def delete_plan():
    db = connect_db()
    cursor = db.cursor()

    plan_id = input("Enter Plan ID to delete: ")
    cursor.execute("DELETE FROM plan WHERE plan_id = %s", (plan_id,))
    db.commit()
    print(f"Plan ID {plan_id} deleted successfully!")
    db.close()

# Main menu
def main():

    while True:
        print("\nMenu:")
        print("1. Insert Plan")
        print("2. Read Plans")
        print("3. Update Plan")
        print("4. Delete Plan")
        print("5. Exit")

        choice = input("Enter your choice: ").strip()

        if choice == "1":
            insert_plan()
        elif choice == "2":
            read_plans()
        elif choice == "3":
            update_plan()
        elif choice == "4":
            delete_plan()
        elif choice == "5":
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
