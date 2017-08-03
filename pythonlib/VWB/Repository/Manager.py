import os
import logging
import VWB.Asset
import VWB.Registrar
import VWB.Assets.Watcher
import VWB.Profiler
import VWB.UUID.Manager
import VWB.Config.Manager

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

		self._config_manager = VWB.Config.Manager.Manager.getInstance()

		self._watcher = VWB.Assets.Watcher.Watcher.getInstance()
		
		self._registrar = VWB.Registrar.Registrar.getInstance()

		self._profiler = VWB.Profiler.Profiler.getInstance()

		self._uuid_manager = VWB.UUID.Manager.Manager.getInstance()

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


	def loadInitialFilesIntoMongo(self, indir):


		if not os.path.isdir(indir):
			self._logger.critical("%s is not a directory" % indir)
			print("%s is not a directory" % indir)
			exit(1)


		self._logger.info("Going to register the files in directory %s" % indir)

		file_ctr = 0

		insert_ctr = 0


		for path, subdirs, files in os.walk(indir):

			for name in files:

				file_ctr += 1

				file_path = os.path.join(path, name)

				asset = VWB.Asset.Asset(file_path)

				self.profileAndRegisterAsset(asset)

				insert_ctr += 1


		print("Processed %d files" % file_ctr)

		collection_name = self._config_manager.getCollectionName()
		
		database_name = self._config_manager.getDatabaseName()

		print("Inserted %d documents/records into the %s collection of database %s" % (insert_ctr, collection_name, database_name))


		self._logger.info("Finished processing all files in directory %s" % indir)
