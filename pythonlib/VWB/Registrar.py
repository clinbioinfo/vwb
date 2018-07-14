import logging
import VWB.MongoDB.DBUtil
import VWB.Profiler

class Registrar():
	'''A class for registering meta-data pertaining to an asset.'''
	
	_instance = None

	@classmethod
	def getInstance(cls):

		if cls._instance == None:
			cls._instance = Registrar()

		return cls._instance


	def __init__(self):
		
		self._logger = logger = logging.getLogger(__name__)

		self._dbutil = VWB.MongoDB.DBUtil.DBUtil.getInstance()

		self._profiler = VWB.Profiler.Profiler.getInstance()

		self._logger.info("Instantiated VWB.Registrar")


	def registerAsset(self, asset):		
		
		profile = self._profiler.profileAsset(asset)
		
		self._dbutil.insertProfile(asset, profile)
