# 'ui.R' file for shiny app to explore a table
#
###########################################################



library(tibble)
data <- as_tibble(read.delim("table", as.is=TRUE))



navbarPage(  

  theme = "styles.css",
  
  title = 'scatterplot example (1.0.0)',
  
  
  tabPanel('qCount Table',     
  ########################  
  
    DT::dataTableOutput("table")
    
  ),
  
  
  
      
  tabPanel('individual scatter plots',      
  ####################################

    pageWithSidebar(
      headerPanel(''),
      sidebarPanel(
      
        selectizeInput('xcolSP', 'X coordinate', names(data)[-1]),
	
        selectizeInput('ycolSP', 'Y coordinate', names(data)[-1]),
	
	sliderInput('xcoffSP', label = "X coordinate cutoff",
		    min = 0, max = 10, step = 0.5, value = 3),
	
	sliderInput('ycoffSP', label = "Y coordinate  cutoff", 
		    min = 0, max = 10, step = 0.5, value = 3),
        
	textAreaInput("geneSP", label = 'identifier (one element per line):'),
	
	radioButtons("filetype_SP", label = "File type", choices = list("png", "pdf"))
      ),
      mainPanel(
        plotOutput('plotSP', brush = brushOpts(id = "plot_brush_SP", fill = "yellow", opacity = 0.5)),
	downloadButton('download_SP', 'Download Scatter Plot'), 
	downloadButton('download_highlighted_Data_SP', 'Download elements above the cutoffs'),       
	br(),
	br(),
	helpText("selected datapoints:"), helpText("(select area in the plot)"),
        verbatimTextOutput('info_SP'),
	downloadButton('downloadData_SP', 'Download Table')
      )
    )

  )


)

