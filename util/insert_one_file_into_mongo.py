#!/usr/bin/env python3
import pymongo
from pymongo import MongoClient
import json
import sys,os
from stat import *
import datetime
import pwd

file_path = '/home/sundaramj/dev-utils/conf/commit_code.ini'

client = MongoClient('mongodb://localhost:3001/')

## get handle for our database of interest: the meteor database
db = client.meteor

## get handle for the collection of interest: the assets collection
assets_collection = db.assets

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
    'atime' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_ATIME]),
    'mtime' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_MTIME]),
    'ctime' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_CTIME]),
    'date_accessed' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_ATIME]),
    'date_modified' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_MTIME]),
    'date_created' : datetime.datetime.fromtimestamp(os.stat(file_path)[ST_CTIME])

}

assets_collection.insert_one(lookup)