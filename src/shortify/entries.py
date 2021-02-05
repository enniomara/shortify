import json


def get_all_shortcut_names(event, table):
    query = table.scan(AttributesToGet=["name"])

    response = {
        "statusCode": "200",
        "body": json.dumps(query["Items"]),
        "isBase64Encoded": False,
        "headers": {
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
        },
    }
    return response
