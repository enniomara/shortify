from . import common, entries, path

table = common.initialize_table()


def path_handler(event, context):
    return path.sub_handler(event, table)


def entries_handler(event, context):
    return entries.get_all_shortcut_names(event=event, table=table)
