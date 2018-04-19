#!/usr/bin/python

# version 1.0.0  18-Apr-2018

"""
This tools imports a data set into galaxy


"""


import sys

###REPLACE###  sys.path.append('/PATH/TO/lib/python2.7/site-packages/bioblend-0.8.0-py2.7.egg')    
###REPLACE###  sys.path.append('/PATH/TOlib/python2.7/site-packages/requests_toolbelt-0.7.0-py2.7.egg') 

from bioblend.galaxy import GalaxyInstance
from bioblend.galaxy.tools import ToolClient


###REPLACE###  url = "GALAXY URL"  
###REPLACE###  key = "API KEY of an ADMIN USER"

history_id = sys.argv[1]
file_path = sys.argv[2]

#print("Initiating Galaxy connection")

gi = GalaxyInstance(url=url, key=key)

toolClient = ToolClient(gi)

uploadedFile = toolClient.upload_file(file_path, history_id )

