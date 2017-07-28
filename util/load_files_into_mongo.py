#!/usr/bin/env python3
import pymongo
from pymongo import MongoClient

import sys
import os
from stat import *
import datetime
import pwd

indir = '/home/sundaramj/dev-utils'

client = MongoClient('mongodb://localhost:3001/')


database_name = 'meteor'
collection_name = 'assets'


## get handle for our database of interest: the meteor database
db_handle = client[database_name]

## get handle for the collection of interest: the assets collection
assets_collection = db_handle[collection_name]

file_ctr = 0
insert_ctr = 0

for path, subdirs, files in os.walk(indir):

	for name in files:

		file_ctr += 1

		file_path = os.path.join(path, name)

		lookup = {
			'basename' : os.path.basename(file_path),
			'path' : file_path,
			'mode'  : os.stat(file_path)[ST_MODE],
			'inode' : os.stat(file_path)[ST_INO],
			'dev'   : os.stat(file_path)[ST_DEV],
			'nlink' : os.stat(file_path)[ST_NLINK],
			'uid'   : os.stat(file_path)[ST_UID],
			'owner' : pwd.getpwuid(os.stat(file_path)[ST_UID])[0],
			'gid'   : os.stat(file_path)[ST_GID],
			'group'   : pwd.getpwuid(os.stat(file_path)[ST_GID])[0],
			'bytes_size'  : os.stat(file_path)[ST_SIZE],
			'atime' : os.stat(file_path)[ST_ATIME],
			'mtime' : os.stat(file_path)[ST_MTIME],
			'ctime' : os.stat(file_path)[ST_CTIME],
			'date_accessed' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_ATIME]),
			'date_modified' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_MTIME]),
			'date_created' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_CTIME])
		}


		try:
			assets_collection.insert_one(lookup)
			insert_ctr += 1
		except Exception:
			print("Caught some exception while attempting to insert record for file %s" % file_path)


print("Processed %d files" % file_ctr)
print("Inserted %d documents/records into the %s collection of database %s" % (insert_ctr, collection_name, database_name))