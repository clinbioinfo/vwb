import logging
import pymongo
from pymongo import MongoClient

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

		self._mongo_url = 'mongodb://localhost:3001'
		self._mongo_database_name = 'meteor'
		self._mongo_collection_name = 'files'

		self._initMongoClient()

		self._logger.info("Instantiated VWB.MongoDB.DBUtil")


	def _initMongoClient(self):
		''' Instantiate the MongoClient '''

		self._mongo_client = MongoClient(self._mongo_url)

		self._db_handle = self._mongo_client[self._mongo_database_name]

		self._collection = self._db_handle[self._mongo_collection_name]


	def insertProfile(self, asset, profile):

		self.insertAssetProfile(asset)


	def insertAssetProfile(self, asset):
		''' Insert a profile object for the corresponding asset/file '''
		## Insert logic to insert the profile meta-data pertaining to the asset into the MongoDB
		## database in the files collection.
		## Will need to come up with logic to 
		self._logger.info("Going to monitor asset %s" % asset.getPath())

		## The presumption will be that the true uniqueness will come from the
		## MD5 checksum of the contents of the file.  A file may be copied to different
		## directories and onto different machines.  Thus a file may have multiple instance
		## each of those instances should be treated as individual objects in this object
		## store.
		try:
			self._collection.insert_one(asset.getProfile())
		except Exception:
			self._logger.critical("Caught some exception while attempting to insert profile for asset with path %s"% asset.getPath())

		