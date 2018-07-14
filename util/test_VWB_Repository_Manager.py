import os
import sys
import logging

logging.basicConfig(
	format='%(asctime)s,%(msecs)d %(levelname)-8s [%(pathname)s:%(lineno)d] %(message)s',
    datefmt='%d-%m-%Y:%H:%M:%S',
	filename='my.log', 
	level=logging.INFO)

curdir = os.getcwd() + '/../pythonlib/'

curdir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../pythonlib")
print("Appended %s to path" % curdir)
sys.path.append(curdir)

import VWB.Repository.Manager
import VWB.Asset


logger = logging.getLogger(__name__)

# from VWB.Repository.Manager import Manager

# _DEFAULT_LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

# _LOGGER = logging.getLogger(__name__)

# def _configure_logging():
#     _LOGGER.setLevel(logging.DEBUG)

#     ch = logging.StreamHandler()

#     formatter = logging.Formatter(_DEFAULT_LOG_FORMAT)
#     ch.setFormatter(formatter)

#     _LOGGER.addHandler(ch)


# _configure_logging()

asset1 = VWB.Asset.Asset("/home/sundaramj/projects/vwb/package.json")
asset2 = VWB.Asset.Asset("/home/sundaramj/projects/vwb/README.md")

assets_list = [asset1, asset2]

manager = VWB.Repository.Manager.Manager.getInstance()

manager.watchAssets(assets_list)

logging.info("Finished")

print("%s execution completed" % os.path.abspath(__file__))

exit(0)