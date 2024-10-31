import requests

# Test api
api_response = requests.get("http://127.0.0.1:8000/helloword/")
print(api_response.json())
# # Test login
# login_response = requests.post("http://127.0.0.1:8000/login/", json={"email": "user@example.com", "password": "password123"})
# print(login_response.json())

# # Test search client
# client_response = requests.get("http://127.0.0.1:8000/client/12345")
# print(client_response.json())
