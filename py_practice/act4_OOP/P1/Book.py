from typing import Any, Dict, List, Optional


class Book:
    def __init__(self, *args: Any, **kwargs: Dict[str, Any]) -> None:
        """
        Initialize a new book instance.

        Args:
            title (str): The title of the book.
            author (str): The author of the book.
            year (str): The year the book was published.
            genre (str): The genre of the book.
        """
        self.title = kwargs.get('title', 'Unknown Title')
        self.author = kwargs.get('author', 'Unknown Author')
        self.year = kwargs.get('year', 'Unknown Year')
        self.genre = kwargs.get('genre', 'Unknown Genre')
        self.availability = True

    @property
    def info(self) -> str:
        """
        Return a string representation of the book.

        Returns:
            str: A string representing the book.
        """
        return f'{self.title} by {self.author} ({self.year})'
    
    @property
    def availability(self) -> bool:
        """Get the availability of the book."""
        return self._availability

    @availability.setter
    def availability(self, value: bool) -> None:
        """Set the availability of the book."""
        
        if not isinstance(value, bool):
            raise ValueError("Availability must be a boolean.")
        self._availability = value

    def borrow_book(self) -> bool:
        """
        Mark the book as borrowed.

        Returns:
            bool: True if the book was successfully borrowed, False otherwise.
        """
        try:
            self.availability = False
            return True
        except:
            raise Exception('Book is not available')
        
    def return_book(self) -> bool:
        """
        Mark the book as returned.

        :return: True if the book was successfully returned, False otherwise.
        """
        try:
            self.availability = True
            return True
        except:
            raise Exception('Book is already available')