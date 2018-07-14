import logging
import hashlib

class Helper():
	'''A class for helping with getting the MD5 checksum of assets.'''
	
	_instance = None

	@classmethod
	def getInstance(cls):

		if cls._instance == None:
			cls._instance = Helper()

		return cls._instance


	def __init__(self):

		self._logger = logging.getLogger(__name__)

		self._logger.info("Instantiated VWB.Checksum.Helper")


	def getChecksum(self, infile):
	    
	    self._logger.info("Going to derive the MD5 checksum for file %s" % infile)

	    hash_md5 = hashlib.md5()

	    with open(infile, "rb") as f:
	        for chunk in iter(lambda: f.read(4096), b""):
	            hash_md5.update(chunk)

	    return hash_md5.hexdigest()
