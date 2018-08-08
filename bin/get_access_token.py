#!/usr/bin/env python

# python 2.x

import sys
from oauth2client.service_account import ServiceAccountCredentials

def print_access_token():
  argv = sys.argv
  if (len(argv) < 1):
    print >> sys.stderr, 'a filepath to service-account.json must be specified as the 1st argument.'
    quit()
  credentials = ServiceAccountCredentials.from_json_keyfile_name(
      argv[1], ['https://www.googleapis.com/auth/firebase.remoteconfig'])
  access_token_info = credentials.get_access_token()
  print(access_token_info.access_token)

print_access_token()