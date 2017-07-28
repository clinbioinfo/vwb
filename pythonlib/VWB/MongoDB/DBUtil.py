import logging

class DBUtil():
	'''A class for interacting with a MongoDB instance.'''

	_instance = None

	@classmethod
	def getInstance(cls):

		if cls._instance == None:
			cls._instance = DBUtil()

		return cls._instance

	def __init__(self):
		## Insert all connection info here.
		## At some point, should implement support to retrieve mission critical configuration info
		## from configuration file instead of hard-coding here.
		self._logger = logging.getLogger(__name__)

		self._logger.info("Instantiated VWB.MongoDB.DBUtil")


	def insertProfile(self, asset, profile):
		## Insert logic to insert the profile meta-data pertaining to the asset into the MongoDB
		## database in the assets collection.
		## Will need to come up with logic to 
		self._logger.info("Going to monitor asset %s" % asset.getPath())


		