import mysql.connector

# Database connection setup
def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",  # Change this if your MySQL user is different
        password="BSHitman@999",  # Enter your MySQL password
        database="InfiComm"  # Change this to your actual database
    )

# Insert a new user
def insert_user():
    db = connect_db()
    cursor = db.cursor()

    name = input("Enter name: ")
    email = input("Enter email: ")
    contact = input("Enter contact ")
    address = input("Enter address ")
    date_registered = input("Enter date registered ")

    sql = "INSERT INTO user (name, email, contact, address, date_registered) VALUES (%s, %s, %s, %s, %s)"
    values = (name, email, contact, address, date_registered)

    cursor.execute(sql, values)
    db.commit()
    print(f"User {name} added successfully!")
    db.close()

# Read users (all or specific)
def read_users():
    db = connect_db()
    cursor = db.cursor()

    choice = input("Do you want to view all users? (yes/no): ").strip().lower()
    if choice == "no":
        user_id = input("Enter User ID to fetch details: ")
        cursor.execute("SELECT * FROM user WHERE user_id = %s", (user_id,))
    else:
        cursor.execute("SELECT * FROM user")

    results = cursor.fetchall()
    for row in results:
        print(row)

    db.close()

# Update a user
def update_user():
    db = connect_db()
    cursor = db.cursor()

    user_id = input("Enter User ID to update: ")
    column = input("Enter column to update (name, email, contact, address): ").strip().lower()
    new_value = input(f"Enter new value for {column}: ")

    sql = f"UPDATE user SET {column} = %s WHERE user_id = %s"
    cursor.execute(sql, (new_value, user_id))
    db.commit()
    print(f"User ID {user_id} updated successfully!")
    db.close()

# Delete a user
def delete_user():
    db = connect_db()
    cursor = db.cursor()

    user_id = input("Enter User ID to delete: ")
    cursor.execute("DELETE FROM user WHERE user_id = %s", (user_id,))
    db.commit()
    print(f"User ID {user_id} deleted successfully!")
    db.close()

# Main menu
def main():

    while True:
        print("\nMenu:")
        print("1. Insert User")
        print("2. Read Users")
        print("3. Update User")
        print("4. Delete User")
        print("5. Exit")

        choice = input("Enter your choice: ").strip()

        if choice == "1":
            insert_user()
        elif choice == "2":
            read_users()
        elif choice == "3":
            update_user()
        elif choice == "4":
            delete_user()
        elif choice == "5":
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
