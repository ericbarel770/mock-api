from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_success():
    r = client.get("/success")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"

def test_bad_request():
    r = client.get("/bad-request")
    assert r.status_code == 400

def test_error():
    r = client.get("/error")
    assert r.status_code == 5000
