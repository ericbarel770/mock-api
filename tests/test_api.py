import requests

BASE_URL = "http://localhost:8000"

def test_success():
    r = requests.get(f"{BASE_URL}/success")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"

def test_bad_request():
    r = requests.get(f"{BASE_URL}/bad-request")
    assert r.status_code == 400

def test_error():
    r = requests.get(f"{BASE_URL}/error")
    assert r.status_code == 500
