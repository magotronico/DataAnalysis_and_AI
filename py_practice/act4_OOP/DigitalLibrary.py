import sqlite3
from Book import Book

class DigitalLibrary:
    def __init__(self, db_name="library.db"):
        self.conn = sqlite3.connect(db_name)
        self.create_table()

    def create_table(self):
        """Create the books table if it doesn't exist."""
        with self.conn:
            self.conn.execute('''
                CREATE TABLE IF NOT EXISTS books (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title TEXT NOT NULL,
                    author TEXT NOT NULL,
                    year TEXT NOT NULL,
                    genre TEXT NOT NULL,
                    availability INTEGER NOT NULL
                )
            ''')

    def add_book(self, book):
        """Add a new book to the library."""
        with self.conn:
            self.conn.execute('''
                INSERT INTO books (title, author, year, genre, availability)
                VALUES (?, ?, ?, ?, ?)
            ''', (book.title, book.author, book.year, book.genre, int(book.availability)))

    def lookup_book(self, title):
        """Find a book by title."""
        cursor = self.conn.cursor()
        cursor.execute('SELECT * FROM books WHERE title = ?', (title,))
        return cursor.fetchone()

    def borrow_book(self, title):
        """Mark a book as borrowed."""
        with self.conn:
            cursor = self.conn.cursor()
            cursor.execute('SELECT availability FROM books WHERE title = ?', (title,))
            book = cursor.fetchone()
            if book and book[0] == 1:  # Check if book is available
                cursor.execute('UPDATE books SET availability = 0 WHERE title = ?', (title,))
                return True
        return False

    def return_book(self, title):
        """Mark a book as returned."""
        with self.conn:
            cursor = self.conn.cursor()
            cursor.execute('SELECT availability FROM books WHERE title = ?', (title,))
            book = cursor.fetchone()
            if book and book[0] == 0:  # Check if book is borrowed
                cursor.execute('UPDATE books SET availability = 1 WHERE title = ?', (title,))
                return True
        return False

    def save_library(self):
        """Commit changes to the database."""
        self.conn.commit()

    def load_library(self):
        """Load library from the database (not necessary since we query directly)."""
        pass  # All interactions are done directly with the database

    def display_books(self):
        """Display all books in the library."""
        cursor = self.conn.cursor()
        cursor.execute('SELECT title, author, availability FROM books')
        books = cursor.fetchall()
        for book in books:
            print(f"{book[0]} by {book[1]} - {'Available' if book[2] == 1 else 'Borrowed'}")
    
    def get_book_count(self) -> int:
        """Return the number of books in the library."""
        cursor = self.conn.cursor()
        cursor.execute('SELECT COUNT(*) FROM books')
        count = cursor.fetchone()[0]
        return count

    def main_menu(self):
        """Main menu for library interaction."""
        def show_menu():
            print("1. Add Book")
            print("2. Lookup Book")
            print("3. Borrow Book")
            print("4. Return Book")
            print("5. Display Books")
            print("6. Exit")
        
        show_menu()

        while True:
            choice = input("\nEnter your choice: ")

            if choice == '1':
                title = input("Enter title: ")
                author = input("Enter author: ")
                year = input("Enter year: ")
                genre = input("Enter genre: ")
                book = Book(title=title, author=author, year=year, genre=genre)
                self.add_book(book)
            elif choice == '2':
                title = input("Enter title: ")
                book = self.lookup_book(title)
                if book:
                    print(f"Book found: {book[1]} by {book[2]} - {'Available' if book[5] else 'Borrowed'}")
                else:
                    print("Book not found.")
            elif choice == '3':
                title = input("Enter title: ")
                if self.borrow_book(title):
                    print("Book borrowed successfully.")
                else:
                    print("Book could not be borrowed.")
            elif choice == '4':
                title = input("Enter title: ")
                if self.return_book(title):
                    print("Book returned successfully.")
                else:
                    print("Book could not be returned.")
            elif choice == '5':
                self.display_books()
            elif choice == '6':
                break
            else:
                print("Invalid choice")

    def __del__(self):
        """Close the database connection when the library is destroyed."""
        self.conn.close()
