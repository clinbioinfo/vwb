from colorama import init, Fore, Back, Style
import os
import sys
import logging

init()

def _check_directory(dir):

	if not os.path.isdir(dir):

		print(Fore.RED + "'%s' is not a directory" % dir)
		print(Style.RESET_ALL)
		exit(1)

def _init_logging():

	logging.basicConfig(
		format='%(asctime)s,%(msecs)d %(levelname)-8s [%(pathname)s:%(lineno)d] %(message)s',
	    datefmt='%d-%m-%Y:%H:%M:%S',
		filename='my.log', 
		level=logging.INFO)

indir = '/home/sundaramj/dev-utils'

_check_directory(indir)

# curdir = os.getcwd() + '/../pythonlib/'



curdir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../pythonlib")
_check_directory(curdir)

print(Fore.YELLOW + "Appended %s to path" % curdir)
print(Style.RESET_ALL)

sys.path.append(curdir)

import VWB.Repository.Manager
import VWB.Asset


logger = logging.getLogger(__name__)

manager = VWB.Repository.Manager.Manager.getInstance()

file_ctr = 0
insert_ctr = 0

logger.info("Going to register the files in directory %s" % indir)

for path, subdirs, files in os.walk(indir):

	for name in files:

		file_ctr += 1

		file_path = os.path.join(path, name)

		asset = VWB.Asset.Asset(file_path)

		manager.profileAndRegisterAsset(asset)


print("Processed %d files" % file_ctr)
print("Inserted %d documents/records into the %s collection of database %s" % (insert_ctr, collection_name, database_name))


logging.info("Finished processing all files in directory %s" % indir)

print("%s execution completed" % os.path.abspath(__file__))

exit(0)