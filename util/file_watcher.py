from colorama import init, Fore, Back, Style
import os
import sys
import logging
import argparse

cwd = os.getcwd()

DEFAULT_CONFIG_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../conf/vwb.json")

DEFAULT_LOG_FILE = os.path.join(cwd, 'my.log')


DEFAULT_MONGODB_DATABASE_NAME = 'meteor'

DEFAULT_COLLECTION_NAME = 'files'

##-------------------------------------------
## check_directory() will check whether the
## thing specified is in fact a directory and
## not something else.
##-------------------------------------------
def check_directory(dir):

    if not os.path.isdir(dir):

        print(Fore.RED + "'%s' is not a directory" % dir)
        print(Style.RESET_ALL)
        sys.exit(1)



## This is precarious declaration of mongodb configuration settings
## not currently passed into the VWB.MongoDB.DBUtil object.
# collection_name = 'files'
# database_name = 'meteor'

curdir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../pythonlib")

check_directory(curdir)

print(Fore.YELLOW + "Appended %s to path" % curdir)

print(Style.RESET_ALL)

sys.path.append(curdir)


import VWB.Logger
import VWB.Config.Manager
import VWB.Repository.Manager

# init()

command_args = {}

config_manager = None


# indir = '/home/sundaramj/dev-utils'



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

    parser.add_argument('-v', "--verbose", help="set verbose mode (default is True)", action="store_true")
    
    parser.add_argument("--config_file", help="configuration file in JSON format")
    
    parser.add_argument('-i', "--indir", help="input directory (default is [current working directory]")
    
    parser.add_argument('-l', "--logfile", help="output log file (default is [current working directory]/my.log)")
    
    parser.add_argument("--database_name", help="Name of the database in which the metadata will be inserted (default is 'meteor')")
    
    parser.add_argument("--collection_name", help="Name of the collection in which the metadata will be inserted (default is 'files')")



    args = parser.parse_args()

    fatal_ctr = 0

    if not args.verbose:    
        args.verbose = True
        print(Fore.YELLOW + "--verbose was not specified and therefore was set to default %d" % args.verbose)
        print(Style.RESET_ALL)


    if not args.indir:
        args.indir = cwd
        print(Fore.YELLOW + "--indir was not specified and therefore was set to default %s" % args.indir) 
        print(Style.RESET_ALL)

    if not args.logfile:
        args.logfile = DEFAULT_LOG_FILE
        print(Fore.YELLOW + "--config_file was not specified and therefore was set to default %s" % args.config_file) 
        print(Style.RESET_ALL)

    if not args.config_file:
        args.config_file = DEFAULT_CONFIG_FILE
        print(Fore.YELLOW + "--config_file was not specified and therefore was set to default %s" % args.config_file) 
        print(Style.RESET_ALL)

    if not args.database_name:
        args.database_name = DEFAULT_MONGODB_DATABASE_NAME
        print(Fore.YELLOW + "--database_name was not specified and therefore was set to default %s" % args.database_name) 
        print(Style.RESET_ALL)

    if not args.collection_name:
        args.collection_name = DEFAULT_COLLECTION_NAME
        print(Fore.YELLOW + "--collection_name was not specified and therefore was set to default %s" % args.collection_name) 
        print(Style.RESET_ALL)


    if not os.path.isfile(args.config_file):
        print(Fore.RED + "'%s' is not a file" % args.config_file)
        print(Style.RESET_ALL)
        sys.exit(1)
        

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


    check_command_line_args()

    global config_manager

    config_manager = VWB.Config.Manager.Manager.getInstance(command_args.config_file)

    init_logger()

    check_directory(command_args.indir)

    repository_manager = VWB.Repository.Manager.Manager.getInstance()   

    repository_manager.watchDirectory(command_args.indir)

    print("%s execution completed" % os.path.abspath(__file__))

    sys.exit(0)


if __name__ == "__main__":
    main()
