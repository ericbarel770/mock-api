import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


# -------------------
# GET Tests
# -------------------
def test_get_valid_item():
    response = client.get("/items/?item_id=1")
    assert response.status_code == 200
    assert response.json() == {"id": 1, "name": "Sample Item"}


#def test_get_invalid_item_id():
 #   response = client.get("/items/0")
 #   assert response.status_code == 400
 #   assert response.json()["detail"] == "Invalid item ID"


#def test_get_not_found_item():
 #   response = client.get("/items/2")
 #   assert response.status_code == 404
 #   assert response.json()["detail"] == "Item not found"


# -------------------
# POST Tests
# -------------------
def test_post_valid_item():
    response = client.post("/items", json={"id": 10, "name": "TestItem"})
    assert response.status_code == 200
    assert response.json()["message"] == "Item created successfully"


def test_post_empty_name():
    response = client.post("/items", json={"id": 11, "name": ""})
    assert response.status_code == 400
    assert response.json()["detail"] == "Item name cannot be empty"


def test_post_db_error():
    response = client.post("/items", json={"id": 999, "name": "Broken"})
    assert response.status_code == 500
    assert response.json()["detail"] == "Database error simulation"


# -------------------
# PUT Tests
# -------------------
def test_put_valid_item():
    response = client.put("/items/10", json={"id": 10, "name": "Updated"})
    assert response.status_code == 200
    assert response.json()["message"] == "Item updated successfully"


def test_put_id_mismatch():
    response = client.put("/items/10", json={"id": 11, "name": "Mismatch"})
    assert response.status_code == 400
    assert response.json()["detail"] == "Item ID mismatch"


def test_put_server_error():
    response = client.put("/items/500", json={"id": 500, "name": "Crash"})
    assert response.status_code == 500
    assert response.json()["detail"] == "Unexpected server error"


# -------------------
# DELETE Tests
# -------------------
def test_delete_valid_item():
    response = client.delete("/items/1")
    assert response.status_code == 200
    assert response.json()["message"] == "Item deleted successfully"


def test_delete_invalid_id():
    response = client.delete("/items/0")
    assert response.status_code == 400
    assert response.json()["detail"] == "Invalid item ID"


def test_delete_not_found():
    response = client.delete("/items/2")
    assert response.status_code == 404
    assert response.json()["detail"] == "Item not found"
