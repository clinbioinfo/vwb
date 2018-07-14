#!/usr/bin/env python3
import argparse
import os
import json

cwd = os.getcwd()

parser = argparse.ArgumentParser()
parser.add_argument('-v', "--verbose", help="set verbose mode (default is True)", action="store_true", default=True)
parser.add_argument('-c', "--config_file", help="configuration file in JSON format", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "../conf/vwb.json"))

args = parser.parse_args()


if not args.verbose:	
	print("--verbose was not specified and therefore was set to default %d" % args.verbose)

if not args.config_file:	
	print("--config_file was not specified and therefore was set to default %d" % args.config_file)



if args.verbose:
	print("Being verbose")
else:
	print("Not being verbose")

print("The configuration  file is %s" % args.config_file)


with open(args.config_file) as f:
	json_data = json.load(f)
	print(" log level: %s" % json_data['logging']['level'])
	print(" log format: %s" % json_data['logging']['format'])
	print(" log date format: %s" % json_data['logging']['datefmt'])
	print(" uuid type: %s" % json_data['uuid-type'])
	print(" database-type: %s" % json_data['database-type'])
	print(" database-name: %s" % json_data['database-connectivity']['database-name'])
	print(" collection-name: %s" % json_data['database-connectivity']['collection-name'])
	print(" uri: %s" % json_data['database-connectivity']['uri'])
