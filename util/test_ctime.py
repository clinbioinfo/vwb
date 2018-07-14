import datetime
import os
import time


file_path = '/home/sundaramj/dev-utils/conf/commit_code.ini'

ctime = time.ctime()
print(ctime)
formatted_ctime = datetime.datetime.strptime(ctime, "%a %b %d %H:%M:%S %Y")
print(formatted_ctime)


t = os.stat(file_path).st_mtime
print(t)
tformat = datetime.datetime.fromtimestamp(t)
print(tformat)