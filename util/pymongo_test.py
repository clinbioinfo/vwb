#!/usr/bin/env python3
import pymongo
import pprint

from pymongo import MongoClient

client = MongoClient('mongodb://localhost:3001/')

## get handle for our database of interest: the meteor database
db = client.meteor

## get handle for the collection of interest: the assets collection
assets_collection = db.assets

asset_ctr = 0

for asset in assets_collection.find():
	pprint.pprint(asset)
	asset_ctr += 1



print("Found %d assets" % asset_ctr)