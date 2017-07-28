import sys
import os
from stat import *
import datetime
import pwd
import logging
import VWB.Checksum.Helper

class Profiler():
	'''A class for profiling the asset.'''
	
	_instance = None

	@classmethod
	def getInstance(cls):

		if cls._instance == None:
			cls._instance = Profiler()

		return cls._instance


	def __init__(self):

		self._logger = logging.getLogger(__name__)

		self._helper = VWB.Checksum.Helper.Helper.getInstance()

		self._logger.info("Instantiated VWB.Asset.Profiler")



	def profile(self, asset):
		## Insert logic to derive the MD5 checksum of the specified file
		
		self._logger.info("Going to profile asset %s" % asset.getPath())
		
		file_path = asset.getPath()

		checksum = self._helper.getChecksum(file_path)

		asset.setChecksum(checksum) 
		## redundant at this time considering we're inserting the checksum
		## into the profile dictionary below

		profile = {
			'path' : file_path,
			'checksum' : checksum,
			'basename' : os.path.basename(file_path),
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

		asset.setProfile(profile)	

		self._logger.info("Finished profiling file %s" % file_path)		

