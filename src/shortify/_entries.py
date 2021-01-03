from . import common, entries

table = common.initialize_table()


def handler(event, context):
    return entries.get_all_shortcut_names(event=event, table=table)
