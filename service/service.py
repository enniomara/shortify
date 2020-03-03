import json

import boto3
from boto3.dynamodb.conditions import Attr, Key
from botocore.exceptions import ClientError

dynamodb = boto3.resource("dynamodb")

table = dynamodb.Table('Shortify')


def handler(event, context):
    path = event['path'].lstrip('/')
    if path == "":
        return handle_not_found()

    response = table.get_item(
        Key={
            'name': path,
        }
    )
    if 'Item' not in response:
        print('error')
        return handle_not_found()

    return handle_found(response['Item'])


def handle_error():
    print("handle error")
    response = {
        'statusCode': "500",
        'body': json.dumps({
            'message': 'Error: See logs for more info.'
        }),
        "isBase64Encoded": False,
    }
    return response


def handle_not_found():
    print("handle not found")
    response = {
        'statusCode': "404",
        'body': json.dumps({
            'message': 'Could not find the given alias.'
        }),
        "isBase64Encoded": False
    }
    return response


def handle_found(item):
    print("handle found")
    response = {
        "statusCode": "302",
        'headers': {
            "Location": item['location'],
            "Cache-Control": "private,max-age=84600"
        },
    }
    return response
