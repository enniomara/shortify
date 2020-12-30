import json
import re

from . import common

# Define what characters are allowed in path
path_regex = re.compile(r"[^a-z0-9-.]")


def handler(event, context):
    table = common.initialize_table()

    path = event["path"].lstrip("/").lower()
    if path == "":
        return handle_not_found()

    if bool(path_regex.search(path)):
        return handle_forbidden("Path contains diallowed characters")

    response = table.get_item(
        Key={
            "name": path,
        }
    )
    if "Item" not in response:
        print("error")
        return handle_not_found()

    return handle_found(response["Item"])


def handle_error():
    print("handle error")
    response = {
        "statusCode": "500",
        "body": json.dumps({"message": "Error: See logs for more info."}),
        "isBase64Encoded": False,
    }
    return response


def handle_not_found():
    print("handle not found")
    response = {
        "statusCode": "404",
        "body": json.dumps({"message": "Could not find the given alias."}),
        "isBase64Encoded": False,
    }
    return response


def handle_forbidden(reason=""):
    print("handle not found")
    response = {
        "statusCode": "403",
        "body": json.dumps({"message": reason}),
        "isBase64Encoded": False,
    }
    return response


def handle_found(item):
    print("handle found")
    response = {
        "statusCode": "302",
        "headers": {
            "Location": item["location"],
            "Cache-Control": "private,max-age=84600",
        },
    }
    return response
