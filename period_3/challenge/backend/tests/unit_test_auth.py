import requests

# # Test login
login_response = requests.post("http://127.0.0.1:8000/login/", params={"id": "user@example.com", "password": "password123"})
print(login_response.json())