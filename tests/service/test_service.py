import pytest

import src.shortify.common as src_common
import src.shortify.path as path_service
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
    table = dynamodb.Table(src_common.TABLE_NAME)
    _ = table.put_item(Item={"name": path.lower(), "location": location})

    apigw_event = tests.helpers.make_apigateway_event(path)
    response = path_service.sub_handler(event=apigw_event, table=table)

    assert response["statusCode"] == "302"
    assert response["headers"]["Location"] == location


def test_item_not_found(create_table, dynamodb):
    table = dynamodb.Table(src_common.TABLE_NAME)

    apigw_event = tests.helpers.make_apigateway_event("nonexistant-path")
    response = path_service.sub_handler(event=apigw_event, table=table)

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
    table = dynamodb.Table(src_common.TABLE_NAME)

    apigw_event = tests.helpers.make_apigateway_event(path)
    response = path_service.sub_handler(event=apigw_event, table=table)

    assert response["statusCode"] == "403"


def test_empty_path(create_table, dynamodb):
    table = dynamodb.Table(src_common.TABLE_NAME)

    apigw_event = tests.helpers.make_apigateway_event("")
    response = path_service.sub_handler(event=apigw_event, table=table)

    assert response["statusCode"] == "404"
