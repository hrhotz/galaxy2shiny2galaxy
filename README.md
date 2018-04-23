galaxy2shiny2galaxy
===================


For our NGS analysis, we have combined Galaxy with Shiny. Each time a data set (e. g.: a count table from an RNA-Seq experiment) is created in Galaxy, a new app is set up on a local Shiny server. The Galaxy user can then decide to look at the data in a interactive manner and generate a variety of different plots (e. g. heatmaps, correlation plots, scatter plots, MDS plots...) or select data points of interest. If the Galaxy user wants to store a particular plot or data points, the Shiny server has enough privileges to store the visualizations (or data table) back into the original Galaxy history with the help of the Galaxy API. At the same time, each step is tracked in a log file on the Shiny server.

![image](https://github.com/hrhotz/galaxy2shiny2galaxy/blob/master/Galaxy2Shiny2Galaxy.png)

Since the set-up relies on several site specific parts (like URLS, Galaxy API keys, PostgreSQL database, etc), this repository contains uncomplete code, where you need to make your site specific modifications (lines start with '###REPLACE###'). Also, the provided Galaxy tool (selecting columns in a table) as well as the shiny app is very simple. It is a proof-of-concept, which can be easily modified and extended to your needs.

In this example, the Galaxy tool is a shell script. It can be easily re-written as an R or python script. It takes a table as input and generates a new table and a simple html page as the two outputs. You can replace the code (here: selecting columns in a table) with any other functionality which creates a table (e.g.: generation of a 'Toptable' in a differential gene expression analysis). Or you could even skip the table generation and take an existing table and only provide the html page as output.


Requirements
------------

 * You need to be an admin for your Galaxy installation, and need to have access to the Galaxy code in order to install the tool. 
 * You need read/write access to the Galaxy PostgreSQL database
 
 * The user, the Galaxy server runs as, needs to have write access to the apps directory of a Shiny server. 
 
 * The apps directory of the Shiny server needs to be mounted on the server(s) Galaxy runs on 



Installation 
------------

This tool is currently not available via the Galaxy tool shed. Although, the tool and the scripts in this repository work, the code is not polished. There are several places for improvements, I am happy to discuss with you.

To start go into the _tools_ directory and clone this repository:

    git clone https://github.com/hrhotz/galaxy2shiny2galaxy.git

you should now have a new directory: _galaxy2shiny2galaxy_


#### Setting up the Galaxy tool:

Within the new directory _galaxy2shiny2galaxy_ you will find the tool wrapper (_galaxy2shiny2galaxy.xml_) and the tool (_galaxy2shiny2galaxy.sh_). 

Modify the _tool_conf.xml_ by adding:

    <section name="Galaxy2Shiny2Galaxy" id="galaxy2shiny2galaxy_section">
    <tool file="galaxy2shiny2galaxy/galaxy2shiny2galaxy.xml"/>
    </section>

You should now see the new tool in the tool list.

The actual tool (_galaxy2shiny2galaxy.sh_) needs several modifications specific to your Galaxy installation and your Shiny server:

    ###REPLACE###    SHINYHOME="/PATH/TO/shiny-server/apps/"
This path is given under 'site_dir' in the Shiny server configuration (_shiny-server.conf_)

    ###REPLACE###    SHINYAPPTEMPLATES="GALAXYROOT/tools/galaxy2shiny2galaxy/app_templates"

    ###REPLACE###    SHINYLINK="BASE URL for SHINY SERVER"

    ###REPLACE###    APITOOLS="GALAXYROOT/tools/galaxy2shiny2galaxy/helper_scripts"


#### Helper scripts:

The Galaxy tool relies on several helper scripts in order to work properly:


##### _dataset2history_id.py_ (_dataset2history_id.wrapper.sh_)

This python scripts (make sure it is executable) makes a simple SQL query to get the "history_id" for the id ("dataset_id") of the first of the two generated dataset. You need to provide the required credentials to connect to the PostgreSQL database:

    ###REPLACE### conn = pg.DB(host="hostname", user="ro_user", passwd="password", dbname="dbname", port=port)

Depending on your local set up you might need to modify the environment variables. You can do this using the _dataset2history_id.wrapper.sh_ file (chek for ###REPLACE### lines).


##### _encode_history_id.sh_

This is just a wrapper to activate the galaxy virtual environment and call _secret_decoder_ring.py_ (see: https://github.com/galaxyproject/galaxy/blob/dev/scripts/secret_decoder_ring.py ).

    ###REPLACE###    cd GALAXYROOT



If everything is set up properly, the Galaxy tool should now work. If you run it, a new directory (named by the Galaxy job id) will be created in the apps directory of your Shiny server. It will look like this:

    encoded.history.id  
    table  (a sym link to the dataset)
    www/styles.css
    server.R
    ui.R


#### The required files for the shiny app:

##### _ui.R_ 

This file encodes the GUI for the Shiny app. It is a simple example, just providing two views for the table, which are selectable using the top bar


##### _www/styles.css_

This file modifies the default style sheet allowing to change colors of the sliderInput (it is based on an idea found here: https://stackoverflow.com/questions/30879743/changing-the-color-of-the-sliderinput-in-shiny-walkthrough ).



##### _server.R_

This is the actual R code to generate the plots. The functionality of the download buttons (download plot or download dataset) is hacked in order to generate a second png (or svg) file and data table, respectively. This second copy is stored in the apps directory and used by the _import.py_ script to copy back into the Galaxy history.

    ###REPLACE###   path_to_API_tools <- "GALAXYROOT/tools/galaxy2shiny2galaxy/helper_scripts/"
If the Shiny server has no access to the GALAXYROOT directory, you need to move the _import.py_ script to a location accessible to the Shiny server.

After the first use of the Shiny app (i.e.: as soon as you click on the URL for the Shiny app in Galaxy) a log file is created. Each movement in the Shiny app is written down in this log file (see all the lines with _write(log_text, file = "log", append = TRUE, sep = "\n")_ ).  


##### _import.py_

This is the script which copies the data/figures generated by the Shiny app back into the Galaxy history. Make sure it has the right accesses permission (i.e.: it should be read-only by the user, the Shiny server runs at), as it contains the API key of an Galaxy admin

    ###REPLACE###  sys.path.append('/PATH/TO/lib/python2.7/site-packages/bioblend-0.8.0-py2.7.egg')    
    ###REPLACE###  sys.path.append('/PATH/TOlib/python2.7/site-packages/requests_toolbelt-0.7.0-py2.7.egg') 

    ###REPLACE###  url = "GALAXY URL"  
    ###REPLACE###  key = "API KEY of an ADMIN USER"


You could modify this script by adding a delete statement, once the file is copied back into the Galaxy history


Support & Bug Reports
---------------------

You can file a [github issue](https://github.com/hrhots/galaxy2shiny2galaxy/issues) or contact me directly  hrhotz@googlemail.com 

