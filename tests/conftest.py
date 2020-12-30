import os

import boto3
import moto
import pytest


@pytest.fixture(scope="function")
def aws_credentials():
    """Mocked AWS Credentials for moto."""
    os.environ["AWS_ACCESS_KEY_ID"] = "testing"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
    os.environ["AWS_SECURITY_TOKEN"] = "testing"
    os.environ["AWS_SESSION_TOKEN"] = "testing"


@pytest.fixture(scope="function")
def dynamodb(aws_credentials):
    with moto.mock_dynamodb2():
        yield boto3.resource("dynamodb")


@moto.mock_dynamodb2
@pytest.fixture()
def create_table(dynamodb, monkeypatch):
    table = dynamodb.create_table(
        TableName="Shortify",
        KeySchema=[{"AttributeName": "name", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "name", "AttributeType": "S"}],
    )
    yield
