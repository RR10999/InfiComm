import mysql.connector

def check_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",  
            user="root",       
            password="BSHitman@999",        
            database="InfiComm"  
        )
        if conn.is_connected():
            print("MySQL Connection Successful!")
        else:
            print("MySQL Connection Failed!")
    except mysql.connector.Error as e:
        print(f"Error: {e}")

check_connection()