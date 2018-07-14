import calendar
import time
import logging

class Manager():
	'''A class for managing UUID values'''

	_instance = None

	@classmethod
	def getInstance(cls):

		if cls._instance == None:
			cls._instance = Manager()	

		return cls._instance


	def __init__(self):
		
		self._logger = logging.getLogger(__name__)
				
		self._logger.info("Instantiated VWB.Repository.Manager")


	def getUUID(self, token):

		uuid_time = calendar.timegm(time.gmtime())

		str_uuid = str(uuid_time) + '_' + token

		self._logger.info("Generated uuid '%s' for token '%s'" % (str_uuid, token))

		return str_uuid