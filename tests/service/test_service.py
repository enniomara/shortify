import pytest

import src.shortify.service as service
import tests.helpers


@pytest.mark.parametrize(
    "path,location",
    [
        ("test", "http://example.com"),
        ("name-a", "http://example.com/abc"),
        ("A1", "http://example.com/a"),
    ],
)
def test_lambda_handler(create_table, dynamodb, path, location):
    table = dynamodb.Table("Shortify")
    _ = table.put_item(Item={"name": path.lower(), "location": location})

    apigw_event = tests.helpers.make_apigateway_event(path)
    response = service.handler(event=apigw_event, context={})

    assert response["statusCode"] == "302"
    assert response["headers"]["Location"] == location


def test_item_not_found(create_table, dynamodb):
    apigw_event = tests.helpers.make_apigateway_event("nonexistant-path")
    response = service.handler(event=apigw_event, context={})

    assert response["statusCode"] == "404"


@pytest.mark.parametrize(
    "path,location",
    [
        ("name_1", ""),
        ("File-1ö", ""),
        ("*$ö", ""),
        ("url/to/file", ""),
    ],
)
def test_disallowed_characters(create_table, dynamodb, path, location):
    apigw_event = tests.helpers.make_apigateway_event(path)
    response = service.handler(event=apigw_event, context={})

    assert response["statusCode"] == "403"


def test_empty_path(create_table, dynamodb):
    apigw_event = tests.helpers.make_apigateway_event("")
    response = service.handler(event=apigw_event, context={})

    assert response["statusCode"] == "404"
