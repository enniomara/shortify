import json

import src.shortify.common as src_common
import src.shortify.entries as entries
import tests.helpers


def test_lambda_handler(create_table, dynamodb):
    items = [
        {"name": "test", "location": "http://example.com"},
        {"name": "name-a", "location": "http://example.com/abc"},
        {"name": "A1", "location": "http://example.com/a"},
    ]

    # seed the table with example items
    table = dynamodb.Table(src_common.TABLE_NAME)
    with table.batch_writer() as batch:
        for item in items:
            batch.put_item(
                Item={"name": item["name"].lower(), "location": item["location"]}
            )

    apigw_event = tests.helpers.make_apigateway_event("_entries")
    response = entries.get_all_shortcut_names(event=apigw_event, table=table)
    body = json.loads(response["body"])

    # lower because the database stores them in lower-case
    prior_names = [i["name"].lower() for i in items]

    assert response["statusCode"] == "200"
    for item in body:
        assert item["name"] in prior_names
