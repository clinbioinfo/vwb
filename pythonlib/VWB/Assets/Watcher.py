import logging
import VWB.Registrar

class Watcher():
	'''A class for watching assets.'''

	_instance = None

	@classmethod
	def getInstance(cls):

		if cls._instance == None:
			cls._instance = Watcher()

		return cls._instance

	def __init__(self):

		self._logger = logging.getLogger(__name__)		

		self._registrar = VWB.Registrar.Registrar.getInstance()
		
		self._logger.info("Instantiated VWB.Assets.Watcher")

	def setAssetsList(self, assets_list):		
		self._assets_list = assets_list

	def getAssetsList(self):
		return self._assets_list

	def watchAssets(self, assets_list):
		if assets_list == None:
			assets_list = self._assets_list

		self._logger.info("Going to watch the following assets:")

		for asset in assets_list:
			self._logger.info("asset '%s'" % asset.getPath())
		## Insert logic for inotify here
