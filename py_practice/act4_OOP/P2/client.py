class Client:
    def __init__(self, name: str, phone: str, email: str) -> None:
        self.name = name
        self.phone = phone
        self.email = email
    
    def __str__(self):
        return f"{self.name} ({self.phone}, {self.email})"
