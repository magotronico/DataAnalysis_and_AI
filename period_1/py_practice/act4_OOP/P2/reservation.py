class Reservation:
    def __init__(self, client, table, date, time, how_many):
        self.client = client
        self.table = table
        self.date = date
        self.time = time
        self.how_many = how_many
        self.status = "Confirmed"

    def cancel_reservation(self) -> None:
        self.status = "Cancelled"
    
    def update_reservation(self, date, time, how_many) -> None:
        self.date = date
        self.time = time
        self.how_many = how_many
    
    def __str__(self) -> str:
        return f"Reservation for {self.client.name} at {self.table.id} on {self.date} at {self.time} for {self.how_many} people."