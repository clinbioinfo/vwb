from colorama import init, Fore, Back, Style
import os
import sys
import logging
import argparse


## This is precarious declaration of mongodb configuration settings
## not currently passed into the VWB.MongoDB.DBUtil object.
# collection_name = 'files'
# database_name = 'meteor'

import VWB.Logger
import VWB.Config.Manager
import VWB.Repository.Manager

# init()

command_args = {}

config_manager = None

cwd = os.getcwd()
# indir = '/home/sundaramj/dev-utils'


##-------------------------------------------
## check_directory() will check whether the
## thing specified is in fact a directory and
## not something else.
##-------------------------------------------
def check_directory(dir):

	if not os.path.isdir(dir):

		print(Fore.RED + "'%s' is not a directory" % dir)
		print(Style.RESET_ALL)
		exit(1)


##-------------------------------------------
## append_lib_to_search_path() will append the
## pythonlib directory to the current seearch
## path thus making the Python modules 
## available to this program.
##-------------------------------------------
def append_lib_to_search_path():

	curdir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../pythonlib")

	check_directory(curdir)

	print(Fore.YELLOW + "Appended %s to path" % curdir)

	print(Style.RESET_ALL)

	sys.path.append(curdir)


##--------------------------------------------
## check_command_line_args() will parse the
## command-line arguments for this executable
## and will abort if required values are not
## provided by the invoker.
##--------------------------------------------
def check_command_line_args():

	parser = argparse.ArgumentParser()

	parser.add_argument('-v', "--verbose", help="set verbose mode (default is True)", action="store_true", default=True)
	
	parser.add_argument("--config_file", help="configuration file in JSON format", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "../conf/vwb.json"))
	
	parser.add_argument('-i', "--indir", help="input directory (default is [current working directory]", default=cwd)
	
	parser.add_argument('-l', "--logfile", help="output log file (default is [current working directory]/my.log)", default=os.path.join(cwd, 'my.log'))
	
	parser.add_argument("--database_name", help="Name of the database in which the metadata will be inserted (default is 'meteor')", default='meteor')
	
	parser.add_argument("--collection_name", help="Name of the collection in which the metadata will be inserted (default is 'files')", default='files')



	args = parser.parse_args()

	fatal_ctr = 0

	if not args.verbose:	
		print("--verbose was not specified and therefore was set to default %d" % args.verbose)

	if not args.indir:
		print("--indir was not specified and therefore was set to default %d" % args.indir)	

	if not args.config_file:
		print("--config_file was not specified and therefore was set to default %d" % args.config_file)	

	if not os.path.isfile(args.config_file):
		print(Fore.RED + "'%s' is not a file" % args.config_file)
		print(Style.RESET_ALL)
		exit(1)
		

	global command_args

	command_args = args



def init_logger():

	logging.basicConfig(
	format=config_manager.getLogFormat(),
	datefmt=config_manager.getLogDateFormat(),
	filename=command_args.logfile,
	level=logging.INFO)

	logger = logging.getLogger(__name__)


##-----------------------------------------
## main() is the main directory that will
## carry out the key steps of the program.
##
##-----------------------------------------
def main():


	# append_lib_to_search_path()

	check_command_line_args()

	# config_file = command_args.config_file
	
	# print("The configuration file is set to '%s'" % config_file)

	global config_manager

	config_manager = VWB.Config.Manager.Manager.getInstance(command_args.config_file)

	init_logger()

	# logger = VWB.Logger.Logger.getInstance(
	# 	__name__, 
	# 	config_manager.getLogFormat(), 
	# 	config_manager.getLogDateFormat(), 
	# 	command_args.logfile, 
	# 	config_manager.getLogLevel()
	# 	)


	check_directory(command_args.indir)


	repository_manager = VWB.Repository.Manager.Manager.getInstance()
	

	repository_manager.loadInitialFilesIntoMongo(command_args.indir)


	print("%s execution completed" % os.path.abspath(__file__))


	exit(0)


if __name__ == "__main__":
	main()
