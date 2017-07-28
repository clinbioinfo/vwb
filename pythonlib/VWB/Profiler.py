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
		
		checksum = self._helper.getChecksum(asset.getPath())
		
		asset.setChecksum(checksum)
		