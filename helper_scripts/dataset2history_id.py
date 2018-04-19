#!/usr/bin/python
# 
# this script is called from dataset2history_id.wrapper.sh

# version 1.0.0 



"""
getting the history_id based on the dataset_id

Usage: dataset2history_id.py <dataset_id>
"""
from __future__ import print_function
import sys
import pg
 
import os, fnmatch


dataset_id = sys.argv[1] 

###REPLACE### conn = pg.DB(host="hostname", user="ro_user", passwd="password", dbname="dbname", port=port)

result = conn.query("select history_id from  history_dataset_association where dataset_id='%s'" % (dataset_id))



for row in result.namedresult() :
#    history_id = count
     print(row.history_id)


conn.close()




