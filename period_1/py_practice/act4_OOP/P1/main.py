from DigitalLibrary import DigitalLibrary
from Book import Book

def add_books(library):
    # Create and add 5 books to the library using the Book class
    books = [
        Book(title="To Kill a Mockingbird", author="Harper Lee", year="1960", genre="Fiction"),
        Book(title="1984", author="George Orwell", year="1949", genre="Dystopian"),
        Book(title="The Great Gatsby", author="F. Scott Fitzgerald", year="1925", genre="Fiction"),
        Book(title="The Catcher in the Rye", author="J.D. Salinger", year="1951", genre="Fiction"),
        Book(title="Moby-Dick", author="Herman Melville", year="1851", genre="Adventure"),
    ]

    for book in books:
        library.add_book(book)


if __name__ == "__main__":
    TecLibrary = DigitalLibrary()

    if TecLibrary.get_book_count() < 5:
        add_books(TecLibrary)
    
    TecLibrary.main_menu()