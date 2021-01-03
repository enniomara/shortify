from . import common, path

table = common.initialize_table()


def handler(event, context):
    return path.sub_handler(event, table)
