import pytest
from app import app  # this refers to app.py

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_home_status(client):
    resp = client.get("/")
    assert resp.status_code == 200
    assert b"Welcome to TaskNest ToDo API with RDS!" in resp.data
