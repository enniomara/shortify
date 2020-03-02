import json

def handler(event, context):
    response = {
        "statusCode": 302,
        'headers': {
            "Location": "https://www.google.com"
        }
    }
    return response
