import pytest
from app import application   # ✅ points to the app/app.py

@pytest.fixture
def client():
    with application.test_client() as client:
        yield client

def test_home_status(client):
    resp = client.get("/")
    assert resp.status_code == 200
    assert b"Welcome to TaskNest ToDo API" in resp.data
