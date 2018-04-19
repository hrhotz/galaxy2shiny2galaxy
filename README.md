galaxy2shiny2galaxy
===================


For our NGS analysis, we have combined Galaxy with Shiny. Each time a data set (e. g.: a count table from an RNA-Seq experiment) is created in Galaxy, a new app is set up on a local Shiny server. The Galaxy user can then decide to look at the data in a interactive manner and generate a variety of different plots (e. g. heatmaps, correlation plots, scatter plots, MDS plots...) or select data points of interest. If the Galaxy user wants to store a particular plot or data points, the Shiny server has enough privileges to store the visualizations (or data table) back into the original Galaxy history with the help of the Galaxy API. At the same time, each step is tracked in a log file on the Shiny server.

![image](https://github.com/hrhotz/galaxy2shiny2galaxy/blob/master/Galaxy2Shiny2Galaxy.png)

Since the set-up relies on several site specific parts (like URLS, Galaxy API keys, PostgreSQL database, etc), this repository contains uncomplete code, where you need to make your site specific modifications (lines start with '###REPLACE###'). Also, the actual Galaxy tool (selecting columns in a table) as well as the shiny app is very simple. It is a proof-of-concept, which can be easily modified and extended to your needs.




Requirements
------------

 * You need to be an admin for your Galaxy installation, and need to have access to the Galaxy code in order to install the tool. 
 * You need read/write access to the Galaxy PostgreSQL database
 
 * The user, the Galaxy server runs as, needs to have write access to the apps directory of a Shiny server. 
 
 * The apps directory of the Shiny server needs to be mounted on the server(s) Galaxy runs on 


Installation   [WIP]
------------

This tool is currently not available via the Galaxy tool shed. Although, the tool and the scripts in this repository work, the code is not polished and should rather be considered as a 'proof of concept' study. There are several places for improvements, I am to discuss with you.

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

The actual tool (_galaxy2shiny2galaxy.sh_) needs several modifications specific to your Galaxy instalation:



#### The required files for the shiny app:

_ui.R_ 

_server.R_

_styles.css_


#### Helper scripts:

_import.py_

_dataset2history_id.sh_

_encode_history_id.sh_





Support & Bug Reports
---------------------

You can file a [github issue](https://github.com/hrhots/galaxy2shiny2galaxy/issues) or contact me directly  hrhotz@googlemail.com 

