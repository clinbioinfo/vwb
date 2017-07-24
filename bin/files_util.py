#!/usr/bin/env python3
import sys
import os

DEFAULT_INDIR = '/home/sundaramj/vwb/'

DISPLAY_LISTS = False

indir = DEFAULT_INDIR

file_ctr = 0
file_list = []

dir_ctr = 0
dir_list = []

unknown_ctr = 0
unknown_list = []

for path, subdirs, files in os.walk(indir):

    for name in files:

    	file_path = os.path.join(path, name)

    	if os.path.isfile(file_path):
    		file_ctr += 1
    		file_list.append(file_path)
    	else:
    		if os.path.isdir(file_path):
    			dir_ctr += 1
    			dir_list.append(file_path)
    		else:
    			unknown_ctr += 1
    			unknown_list.append(file_path)

if file_ctr > 0:
	if DISPLAY_LISTS:
		print("Found the following %d files" % file_ctr)
		for file in file_list:
			print(file)
	else:
		print("Found %d files" % file_ctr)

if dir_ctr > 0:
	if DISPLAY_LISTS:
		print("Found the following %d directories" % dir_ctr)
		for dir in dir_list:
			print(dir)
	else:
		print("Found %d directories" % dir_ctr)

if unknown_ctr > 0:
	if DISPLAY_LISTS:
		print("Found the following %d unknown assets" % unknown_ctr)
		for unknown in unknown_list:
			print(unknown)
	else:
		print("Found %d unknown assets" % unknown_ctr)

print("Execution completed")
exit(0)