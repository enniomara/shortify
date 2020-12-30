import json

from . import common


def handler(event, context):
    table = common.initialize_table()

    query = table.scan(AttributesToGet=["name"])

    response = {
        "statusCode": "200",
        "body": json.dumps(query["Items"]),
        "isBase64Encoded": False,
    }
    return response
