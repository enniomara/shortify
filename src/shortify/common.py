import boto3

TABLE_NAME = "Shortify"


def initialize_table():
    return boto3.resource("dynamodb").Table(TABLE_NAME)
