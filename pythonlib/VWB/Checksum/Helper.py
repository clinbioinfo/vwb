import logging

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
		## Insert logic to derive the MD5 checksum of the specified file
		self._logger.info("Going to derive the MD5 checksum for file %" % infile)
		
		return "BS-laksjflasjflkdsjflkjsdlfjlssdflksdjflkds"