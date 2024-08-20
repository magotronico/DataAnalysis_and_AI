from reservation_system import ReservationSystem
from client import Client
from table import Table
from reservation import Reservation
from datetime import datetime


if __name__ == "__main__":
    # Print a welcome message
    print("Welcome to the Reservation System!")
    print("Today is:", datetime.now().strftime("%d-%m-%Y"))

    # Create a reservation system
    system = ReservationSystem()

    # Create clients
    alice = Client("Alice", "6644423355", "alice@gmail.com")
    bob = Client("Bob", "6644423356", "bob@gmail.com")
    charlie = Client("Charlie", "6644423357", "charlie@gmail")

    # Create tables
    table1 = Table(1, 4)
    table2 = Table(2, 6)
    table3 = Table(3, 2)
    table4 = Table(4, 8)

    # Add tables to the system
    system.add_table(table1)
    system.add_table(table2)
    system.add_table(table3)
    system.add_table(table4)

    # Add clients and tables to the system
    reservation1 = Reservation(alice, table1, "20-08-2024", "19:00", 4)
    reservation2 = Reservation(bob, table2, "20-08-2024", "20:00", 6)
    reservation3 = Reservation(charlie, table3, "13-10-2024", "21:00", 2)
    reservation4 = Reservation(alice, table4, "20-08-2024", "22:00", 8)
    reservation5 = Reservation(bob, table1, "14-10-2024", "19:00", 4)

    # Add reservations to the system
    system.add_reservation(reservation1)
    system.add_reservation(reservation2)
    system.add_reservation(reservation3)
    system.add_reservation(reservation4)
    system.add_reservation(reservation5)

    # Generate a report
    system.generate_report()

    # Cancel a reservation
    system.cancel_reservation(reservation2)

    # Update a reservation
    system.update_reservation(reservation5, "15-10-2024", "19:00", 6)

    # Generate a report
    system.generate_report()

    # Show all reservations
    print("\nAll reservations today:")
    system.show_reservations()

    # Search for reservations by client
    print("\nReservations for Alice:")
    system.search_reservation("client", "Alice")

    # Search for reservations by date
    print("\nReservations for 15-10-2024:")
    system.search_reservation("date", "15-10-2024")
    