import sys
import os
import VWB.Config.File.JSON.Parser

class Manager():
	'''A class for parsing the configuration file conf/vwb.json.'''

	_instance = None


	@classmethod
	def getInstance(cls, infile=None):

		if cls._instance == None:
			cls._instance = Manager(infile)	

		return cls._instance


	def __init__(self, infile=None):

		if infile:
			if os.path.isfile(infile):
				self._infile = infile
			else:
				print("%s is not a file" % infile)
				sys.exit(1)

		self._parser = VWB.Config.File.JSON.Parser.Parser.getInstance(infile)
	

	def getLogLevel(self):		

		return self._parser.getLogLevel()

	def getLogFormat(self):		

		return self._parser.getLogFormat()

	def getLogDateFormat(self):		

		return self._parser.getLogDateFormat()

	def getUUIDType(self):		

		return self._parser.getUUIDType()

	def getDatabaseType(self):		

		return self._parser.getDatabaseType()

	def getDatabaseName(self):		

		return self._parser.getDatabaseName()

	def getCollectionName(self):		

		return self._parser.getCollectionName()

	def getDatabaseURI(self):		

		return self._parser.getDatabaseURI()