# Library System

To make this digiital library work, I would need to create a class for the library, and then create a class for the books.
The library class would have a list of books, and methods to add, remove, lookup, borrow and return books from the list.
The book class would have attributes for title, author, and availability, and method to change the availability of the book.

I would also need to create:
1.    A menu for the user to interact with the library, and a loop to keep the program running until the user decides to exit.
2.    File to store the books in the library, so that the library can be reloaded with the same books when the program is restarted.
3.    A way to save the changes to the library to the file when the program is exited.

For testing, if there was no db, then it is created and 5 book added.

For this case, I used some standars to practice good pracitces:
PEP 8 (identation), PEP 257 (DOCSTRINGS), PEP 318 (DECORATOR), PEP 454 (TYPE HINTS)

Also, to go further, I used sqlite to create a db to store the books even after the program is closed.