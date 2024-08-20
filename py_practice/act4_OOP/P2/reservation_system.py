from datetime import datetime
from typing import List
from client import Client
from table import Table
from reservation import Reservation

from datetime import datetime
from typing import List

class ReservationSystem:
    """
    A class to manage restaurant reservations, clients, and tables.
    
    Attributes
    ----------
    clients : list
        List of all clients in the system.
    tables : list
        List of all tables available in the restaurant.
    reservations : list
        List of all reservations made.
    """

    def __init__(self):
        """Initialize the reservation system with empty lists for clients, tables, and reservations."""
        self.clients = []
        self.tables = []
        self.reservations = []

    def generate_report(self) -> None:
        """
        Generate a report on the number of occupied tables and reservations for the current day.
        """
        try:

            # Reservations for today
            today_reservation = 0
            today = datetime.now().strftime("%d-%m-%Y")
            for reservation in self.reservations:
                if reservation.date == today and reservation.status == "Confirmed":
                    today_reservation += 1


            # Results
            print("\nRestaurant Report")
            print(f"Today we have: {today_reservation} reservations.")
            self.show_reservations()
        except Exception as e:
            print(f"Error generating report: {e}")

    def add_client(self, client: Client) -> None:
        """
        Add a new client to the system.

        Parameters
        ----------
        client : Client
            The client object to be added.
        """
        try:
            self.clients.append(client)
        except Exception as e:
            print(f"Error adding client: {e}")

    def add_table(self, table: Table) -> None:
        """
        Add a new table to the system.

        Parameters
        ----------
        table : Table
            The table object to be added.
        """
        try:
            self.tables.append(table)
        except Exception as e:
            print(f"Error adding table: {e}")

    def add_reservation(self, reservation: Reservation) -> None:
        """
        Add a new reservation to the system and update the table status.

        Parameters
        ----------
        reservation : Reservation
            The reservation object to be added.
        """
        try:
            self.reservations.append(reservation)
            reservation.table.update_status()
            self.clients.append(reservation.client)
        except Exception as e:
            print(f"Error adding reservation: {e}")

    def cancel_reservation(self, reservation: Reservation) -> None:
        """
        Cancel an existing reservation and update the table status.

        Parameters
        ----------
        reservation : Reservation
            The reservation object to be canceled.
        """
        try:
            reservation.cancel_reservation()
            reservation.table.update_status()
        except Exception as e:
            print(f"Error canceling reservation: {e}")

    def update_reservation(self, reservation: Reservation, date, time, how_many) -> None:
        """
        Update an existing reservation with new details.

        Parameters
        ----------
        reservation : Reservation
            The reservation object to be updated.
        date : str
            The new date for the reservation.
        time : str
            The new time for the reservation.
        how_many : int
            The new number of people for the reservation.
        """
        try:
            reservation.update_reservation(date, time, how_many)
        except Exception as e:
            print(f"Error updating reservation: {e}")

    def show_reservations(self, date: datetime = None) -> None:
        """
        Print all reservations in the system.
        """
        if date == None:
            date = datetime.now().strftime("%d-%m-%Y")

        try:
            for reservation in self.reservations:
                if reservation.status == "Confirmed" and reservation.date == date:
                    print(f'Reservation by {reservation.client.name} at table {reservation.table.id} on {reservation.date} at {reservation.time} for {reservation.how_many} people.')
        except Exception as e:
            print(f"Error showing reservations: {e}")

    def search_reservation(self, filter: str, value: str) -> List:
        """
        Search for all reservations made by a specific client or on a specific date.

        Parameters
        ----------
        filter : str
            The filter type, either "client" or "date".
        value : str
            The client name or date in which reservations are to be searched.

        Returns
        -------
        List
            A list of reservations made by the client or happening on that date.
        """
        try:
            for reservation in self.reservations:
                if (filter == "client" and reservation.client.name == value) or (filter == "date" and reservation.date == value):
                    print(f'Reservation by {reservation.client.name} at table {reservation.table.id} on {reservation.date} at {reservation.time} for {reservation.how_many} people.')
        except Exception as e:
            print(f"Error searching for reservations: {e}")
        
    def __del__(self):
        print("Reservation system closed.")
