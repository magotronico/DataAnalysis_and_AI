"""
If you want to use SQLite, you can use the following code to create a database and a table.
The use of SQLite is very simple and easy to use. But it should only be used for small projects. 
For large projects, you should use MySQL or PostgreSQL. Running an SQL server and then connecting to it is a better option for large projects.

By Dilan G. Castañeda @magotronico
"""

import sqlite3

# Create a database
conn = sqlite3.connect('example.db')

# Create a table
conn.execute('''CREATE TABLE IF NOT EXISTS stocks (date text PRIMARY KEY)''')

# Insert data
conn.execute("INSERT INTO stocks (date) VALUES ('2020-01-01)')")
conn.execute("INSERT INTO stocks (date) VALUES ('2020-01-02)')")
conn.execute("INSERT INTO stocks (date) VALUES ('2020-01-03)')")
conn.execute("INSERT INTO stocks (date) VALUES ('2020-01-04)')")

# Commit the changes
conn.commit()

# Close the connection
conn.close()
