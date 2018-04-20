#!/bin/sh

# galaxy2shiny2galaxy scatterplot example
#
# Author: Hans-Rudolf Hotz
#
#
#
# Version: 1.0.0  17-Apr-2018
#
# 
#
##############################################################################



TABLE="$1" 

IDENTIFIER="$2"

COLUMNS="$3" 

OUTPUTFILE1="$4" 
OUTPUTFILE2="$5"


# for this dummy example, we just cut out the selected colums and generate a new table
#######################################################################################

cut -f  $IDENTIFIER,$COLUMNS < $TABLE > $OUTPUTFILE1


# in a real tool, this command would for example calculate a count table from 
# BAM files or generate the top table in a differential gene expression analysis.



# now, we create a new shiny app to look at this table
######################################################

# set up the stage for shiny

###REPLACE###    SHINYHOME="/PATH/TO/shiny-server/apps"

###REPLACE###    SHINYAPPTEMPLATES="GALAXYROOT/tools/galaxy2shiny2galaxy/app_templates"

###REPLACE###    SHINYLINK="BASE URL for SHINY SERVER"

###REPLACE###    APITOOLS="GALAXYROOT/tools/galaxy2shiny2galaxy/helper_scripts"




# get the job id (12345) from the working directory (/PATH/TO/GALAXY/database/jobs_directory/012/12345/working)
# the job id will be used to generate a unique URL for the new shiny app

pwd=$(pwd)
IFS='/' array=($pwd)
JOBID="${array[-2]}"



# make a new directory on the shiny server for the new app and sym-link the table

mkdir "$SHINYHOME"$JOBID
ln -s "$OUTPUTFILE1" "$SHINYHOME"$JOBID"/table"




# copy the shiny code
# (I recommend copy the code from templates, instead of a symlink)

cp -p "$SHINYAPPTEMPLATES"/"ui.R" "$SHINYHOME"$JOBID
cp -p "$SHINYAPPTEMPLATES"/"server.R" "$SHINYHOME"$JOBID

mkdir "$SHINYHOME"$JOBID"/www"
cp -p "$SHINYAPPTEMPLATES"/"styles.css" "$SHINYHOME"$JOBID"/www"




# store the encoded history id 
# (the encoded history id is required by the Galaxy API to store plots and tables back into the Galaxy history)

# first, get the dataset id from the outputpath
IFS='/' read -ra ARRAY <<< "$OUTPUTFILE1"
DATAFILE="${ARRAY[-1]}"
DATASET=$(echo $DATAFILE | tr -dc '0-9')

# second, get the history id from the dataset id and encode it
HISTORYID=$(sh "$APITOOLS/dataset2history_id.wrapper.sh" $DATASET)
sh "$APITOOLS/encode_history_id.sh" $HISTORYID  > "$SHINYHOME"$JOBID"/encoded.history.id"



# generate the simple html page 

echo "access the shiny server here  <a href=\"$SHINYLINK$JOBID\">$JOBID</a>" > "$OUTPUTFILE2"

