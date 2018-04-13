galaxy2shiny2galaxy
===================

This repository will contain example code to combine Galaxy with Shiny. In particular: the Galaxy tool (scatterplot.sh), the tool wrapper (scatterplot.xml), the required files for the shiny app (server.R, ui.R, styles.css), and some helper scripts (import.py, 
dataset2history_id.sh, encode_history_id.sh).

All files and scripts will be available by the time of presentation - though, I hope they will be up sooner. Please contact me if you want to see the code already now.


Introduction
------------

For our NGS analysis, we have combined Galaxy with Shiny. Each time a data set (e. g.: a count table from an RNA-Seq experiment) is created in Galaxy, a new app is set up on a local Shiny server. The Galaxy user can then decide to look at the data in a interactive manner and generate a variety of different plots (e. g. heatmaps, correlation plots, scatter plots, MDS plots...) or select data points of interest. If the Galaxy user wants to store a particular plot or data points, the Shiny server has enough privileges to store the visualizations (or data table) back into the original Galaxy history with the help of the Galaxy API. At the same time, each step is tracked in a log file on the Shiny server.

Since the set-up contains several site specific parts (like URLS, Galaxy API keys, etc), this repository will contain uncomplete code, where you need to make your site specific modifications. Also, the actual Galaxy tool (selecting columns in a table) as well as the shiny app is very simple. It is a proof-of-concept, which can be easily modified and extended to your requirements.





Requirements
------------




Installation
------------


Support & Bug Reports
---------------------

You can file a [github issue](https://github.com/hrhots/galaxy2shiny2galaxy/issues) or contact me directly  hrhotz@googlemail.com 

