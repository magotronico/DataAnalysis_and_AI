import sqlite3
import os

def init_test_db():
    # Connect to the database
    conn = sqlite3.connect('dimex_app.db')
    
    try:
        # Read the SQL file content
        with open('init_db.sql', 'r') as sql_file:
            sql_script = sql_file.read()
        
        # Execute the SQL script
        conn.executescript(sql_script)
        
        print("Test database initialized successfully!")
        
        # Print some statistics
        cur = conn.cursor()
        cur.execute("SELECT promo_type, COUNT(*) FROM users GROUP BY promo_type")
        stats = cur.fetchall()
        print("\nUser distribution by promo type:")
        for promo_type, count in stats:
            print(f"Promo {promo_type}: {count} users")
            
    except Exception as e:
        print(f"Error initializing database: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    init_test_db()