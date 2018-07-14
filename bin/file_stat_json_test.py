#!/usr/bin/env python3
import sys
import os
import json
from os import stat
from stat import *

outfile = '/tmp/file_stat.json'

infile = '/home/sundaramj/vwb/conf/vwb.ini'

mode   = os.stat(infile)[ST_MODE]
inode  = os.stat(infile)[ST_INO]
device = os.stat(infile)[ST_DEV]
nlink  = os.stat(infile)[ST_NLINK]
uid    = os.stat(infile)[ST_UID]
gid    = os.stat(infile)[ST_GID]
atime  = os.stat(infile)[ST_ATIME]
mtime  = os.stat(infile)[ST_MTIME]
ctime  = os.stat(infile)[ST_CTIME]


print("mode : %s" % mode)
print("atime : %s" % atime)
print("ctime : %s" % ctime)
print("mtime : %s" % mtime)

my_dictionary = {
	'mode' : mode,
	'atime' : atime,
	'uid' : uid,
	'mtime' : mtime
}


my_json_string = json.dumps(my_dictionary)

print(my_json_string)

with open(outfile, 'w') as of:
    json.dump(my_json_string, of)

print("Wrote JSON to output file %s" % outfile)