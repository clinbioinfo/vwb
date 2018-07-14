import logging

class Logger():
	'''A class for parsing the configuration file conf/vwb.json.'''

	_instance = None


	@classmethod
	def getInstance(cls, name, format, datefmt, level, logfile):

		if cls._instance == None:
			cls._instance = Logger(name, format, datefmt, level, logfile)	

		return cls._instance


	def __init__(self, name, format, datefmt, level, logfile):

		self._format  = format
		self._datefmt = datefmt
		self._level   = level
		self._logfile = logfile


		logging.basicConfig(
			format=format,
			datefmt=datefmt,
			filename=logfile,
			level=logging.INFO)


		logger = logging.getLogger(name)

		# return logger


	def getLogger(self):

		return self._logger
