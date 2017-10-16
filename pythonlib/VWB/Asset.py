import logging

class Asset():
	'''A class for encapsulating an asset.'''
	
	def __init__(self, path):

		self._logger = logging.getLogger(__name__)

		if not path == None:
			self._path = path

		self._lookup = {}

		self._logger.info("Instantiated VWB.Asset for path '%s'"  % path)


	def setPath(self, path):		

		self._path = path

	def getPath(self):

		return self._path

	def setChecksum(self, checksum):		

		self._checksum = checksum

	def getChecksum(self):

		return self._checksum

	def setProfile(self, profile):
		self._lookup = profile

	def getProfile(self):
		return self._lookup

	def addMetaData(self, key, val):

		self._lookup[key].append(val)

	def addMetaDataValuesByKey(self, key, val_list):

		val_ctr = 0

		for val in val_list:
		
			self._lookup[key].append(val)
		
			val_ctr += 1

		self._logger.info("Added %d values for key %s"% val_ctr, key)

	def getMetaDataByKey(self, key):
		
		return self._lookup[key]

	def hasMetaDataByKey(self, key):
		
		if key in self._lookup:
		
			return True
		
		else:

			return False