import pytest
import src.shortify.service as service
import tests.helpers


@pytest.mark.parametrize(
    'path,location',
    [
        ('test', 'http://example.com'),
        ('name-a', 'http://example.com/abc'),
        ('A1', 'http://example.com/a')
    ]
)
def test_lambda_handler(create_table, dynamodb, path, location):
    table = dynamodb.Table('Shortify')
    _ = table.put_item(Item={
        'name': path.lower(),
        'location': location
    })

    apigw_event = tests.helpers.make_apigateway_event(path)
    response = service.handler(event=apigw_event, context={})

    assert response['statusCode'] == '302'
    assert response['headers']['Location'] == location
