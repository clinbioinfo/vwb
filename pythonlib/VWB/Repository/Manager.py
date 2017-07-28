import logging
import VWB.Registrar
import VWB.Assets.Watcher
import VWB.Profiler

class Manager():
	'''A class for managing the orchestration of VWB activities.'''

	_instance = None


	@classmethod
	def getInstance(cls):

		if cls._instance == None:
			cls._instance = Manager()	

		return cls._instance


	def __init__(self):
		
		self._logger = logging.getLogger(__name__)

		self._watcher = VWB.Assets.Watcher.Watcher.getInstance()
		
		self._registrar = VWB.Registrar.Registrar.getInstance()

		self._profiler = VWB.Profiler.Profiler.getInstance()
		
		self._logger.info("Instantiated VWB.Repository.Manager")
		

	def watchAssets(self, assets_list):		

		self._watcher.watchAssets(assets_list)

	def watchAsset(self, asset):

		self._watcher.watchAsset(asset)

	def registerAssets(self, assets_list):		

		self._registrar.registerAssets(assets_list)

	def registerAsset(self, asset):

		self._registrar.registerAsset(asset)


	def profileAndRegisterAsset(self, asset):

		self._profiler.profile(asset)

		self._registrar.registerAsset(asset)

		self._logger.info("Have profiled and registered asset %s" % asset.getPath())

