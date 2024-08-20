class Table:
    def __init__(self, id, capacity: int) -> None:
        self.id = id
        self.capacity = capacity
        self._is_available = True  # Use _is_available as the internal variable

    @property
    def is_available(self) -> bool:
        return self._is_available  # Return the internal variable

    @is_available.setter
    def is_available(self, value: bool) -> None:
        self._is_available = value  # Set the internal variable

    def update_status(self) -> None:
        """Change the current value to its opposite"""
        self.is_available = not self.is_available
    
    def __str__(self):
        return f"Table {self.number} (Capacity: {self.capacity})"
