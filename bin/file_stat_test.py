#!/usr/bin/env python3
import sys
import os
from os import stat
from stat import *

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
	