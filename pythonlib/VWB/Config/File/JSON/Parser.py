import json

class Parser():
	'''A class for parsing the configuration file conf/vwb.json.'''

	_instance = None


	@classmethod
	def getInstance(cls, infile):

		if cls._instance == None:
			cls._instance = Parser(infile)	

		return cls._instance


	def __init__(self, infile):

		self._infile = infile

		self._parse_file()


	def _parse_file(self):

		with open(self._infile) as f:
			self._json_data = json.load(f)
		

	def getLogLevel(self):		

		if 'logging' in self._json_data:
			if 'level' in self._json_data:
				return self._json_data['logging']['level']

		return None

	def getLogFormat(self):		

		if 'logging' in self._json_data:
			if 'format' in self._json_data:
				return self._json_data['logging']['format']

		return None

	def getLogDateFormat(self):		

		if 'logging' in self._json_data:
			if 'datefmt' in self._json_data:
				return self._json_data['logging']['datefmt']

		return None

	def getUUIDType(self):		

		if 'uuid-type' in self._json_data:
			return self._json_data['uuid-type']

		return None

	def getDatabaseType(self):		

		if 'database-type' in self._json_data:
			return self._json_data['database-type']

		return None

	def getDatabaseName(self):		

		if 'database-connectivity' in self._json_data:
			if 'database-name' in self._json_data["database-connectivity"]:
				return self._json_data['database-connectivity']['database-name']

		return None

	def getCollectionName(self):		

		if 'database-connectivity' in self._json_data:
			if 'collection-name' in self._json_data['database-connectivity']:
				return self._json_data['database-connectivity']['collection-name']

		return None

	def getDatabaseURI(self):		

		if 'database-connectivity' in self._json_data:
			if 'uri' in self._json_data['database-connectivity']:
				return self._json_data['database-connectivity']['uri']

		return None

