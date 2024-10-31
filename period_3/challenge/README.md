# DataAnalysis_and_AI - Period 3 Challenge

## Overview

This repository contains the code for a financial management tool designed for financial gestors. The project is divided into two main components:

1. **Backend** - Developed in Python.
2. **Dimex App** - Developed in Flutter.

## Dimex App

The Dimex App is a tool for financial gestors to manage client interactions efficiently. The app provides the following functionalities:

- **Client Contact Management**: Allows gestors to know who they need to contact and the best way to reach them.
- **Offer Management**: Enables gestors to provide clients with offers to help them pay their debts.
- **Connection Logging**: Gestors can add new connections and log whether the interaction was positive or negative.

## Backend

The backend is developed in Python and provides an API with the following features:

- **Google Sheets Integration**: Stores gestors' credentials to initiate sessions in the app.
- **Client Information**: Provides information about clients so gestors can know some details beforehand.
- **Task List**: Maintains a list of clients each gestor needs to attend to.
- **Connection Forms**: Stores new connection forms filled out after gestors contact clients.

## Getting Started

### Prerequisites

- Python 3.11.9
- Flutter SDK 3.24.0
- Google Sheets API credentials

### Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/DataAnalysis_and_AI.git
    cd DataAnalysis_and_AI/period_3/challenge
    ```

2. **Backend Setup**:
    - Navigate to the backend directory and install the required Python packages:
      ```sh
      cd backend
      pip install -r requirements.txt
      ```

3. **Dimex App Setup**:
    - Navigate to the Flutter app directory and get the dependencies:
      ```sh
      cd dimex_app
      flutter pub get
      ```

## Usage

### Running the Backend

1. Navigate to the backend directory:
    ```sh
    cd backend
    ```

2. Run the backend server:
    ```sh
    uvicorn app:main --reload
    ```

### Running the Dimex App

1. Navigate to the Flutter app directory:
    ```sh
    cd dimex_app
    ```

2. Run the Flutter app:
    ```sh
    flutter run
    ```


## Contact

For any questions or issues, please open an issue in the repository or contact the project maintainers.
