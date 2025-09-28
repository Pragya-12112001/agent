import mysql.connector
from mysql.connector import Error

def get_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="123456",
            database="sales_db"
        )
        if conn.is_connected():
            print("Successfully connected to the database")
        return conn
    except Error as e:
        print("Error connecting to database:", e)
        return None
