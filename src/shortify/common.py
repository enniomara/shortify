import boto3


def initialize_table():
    return boto3.resource("dynamodb").Table("Shortify")
