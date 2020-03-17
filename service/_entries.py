import json

import boto3
from boto3.dynamodb.conditions import Attr, Key
from botocore.exceptions import ClientError

dynamodb = boto3.resource("dynamodb")

table = dynamodb.Table('Shortify')


def handler(event, context):

    query = table.scan(AttributesToGet=['name'])

    response = {
        'statusCode': "200",
        'body': json.dumps(query['Items']),
        "isBase64Encoded": False,
    }
    return response
