# 'server.R' file for shiny app to explore a table
#
#
# Version: 1.0.0  17-Apr-2018  first version for github repo galaxy2shiny2galaxy
#
#############################################################

library(tibble)



function(input, output) {
  

  # prepare data 
  ##############
  
  
  
  data <- read.delim("table", as.is=TRUE)
  
  rownames(data) <- data[,1]
  
  
  
  # start writting log file  
  log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "prepare data", sep=" -- ")
  write(log_text, file = "log", append = TRUE, sep = "\n")
  
  
  # required arguments for Galaxy API 
  history_id <- read.table("encoded.history.id", as.is=TRUE)$V1    
 

###REPLACE###   path_to_API_tools <- "/PATH/TO/api_helpers"



  
  
  
  
  # qCount Table 
  ##############  
  
    output$table <- DT::renderDataTable(DT::datatable({
    data <- as_tibble(read.delim("table", as.is=TRUE))
    data
    
    
    }))


  
  # scatter plot (SP)
  ###################
  
  scatter_plot  <- function(){
    plot(log2(data[,input$xcolSP]),log2(data[,input$ycolSP]), col='gray',
         xlab=paste("log2",input$xcolSP,sep=" "),ylab=paste("log2",input$ycolSP,sep=" "),
	 main=paste("X cutoff > ",input$xcoffSP, "; Y cutoff > ",input$ycoffSP, sep="") )


    cutoff <-	rownames(data)[log2(data[, input$xcolSP]) > input$xcoffSP & log2(data[, input$ycolSP]) > input$ycoffSP]	        
    points(x = log2(data[cutoff, input$xcolSP]), y = log2(data[cutoff, input$ycolSP]), pch=16, col='black')	
    
    
    genesSP <- unlist(strsplit(input$geneSP,"\n"))
    
    if (length(genesSP) > 0) {
     
      for ( gene in genesSP ) {  
      
        x.value <- log2(data[gene,input$xcolSP])
        y.value <- log2(data[gene,input$ycolSP])
  
        points(x.value,y.value, col='red', text(x.value,y.value,labels=gene, cex= 0.7,pos=3))

      }
    }
  }
  
  output$plotSP <- renderPlot({  
  
    log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "scatter plot", input$xcolSP, input$ycolSP, input$geneSP, sep=" -- ")
    write(log_text, file = "log", append = TRUE, sep = "\n")
  
    scatter_plot()

  })
  
  output$download_SP <- downloadHandler(

    filename <- function() {
      paste(Sys.Date(), '_scatterplot.', input$filetype_SP, sep='')
    },
    content <- function(file) {
    
      if(input$filetype_SP == "png") {
        
        png(file, width = 4000, height = 4000,  units = "px", pointsize = 12, res = 300)

      } else if(input$filetype_SP == "pdf") {
        
	pdf(file, width = 10, height = 10)
      }
      
      scatter_plot()
      dev.off()

      params <- paste("X cutoff > ",input$xcoffSP, "; Y cutoff > ",input$ycoffSP, sep="")
      log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "prepare scatter plot for download", input$xcolSP, input$ycolSP, params, input$geneSP, sep=' -- ')
      write(log_text, file = "log", append = TRUE, sep = "\n")
      filename_galaxy <- paste(Sys.time(), '_scatterplot.', input$filetype_SP, sep='')
      filename_galaxy <- gsub(" ", "_", filename_galaxy)
      if(input$filetype_SP == "png") {
        
        png(filename_galaxy, width = 4000, height = 4000,  units = "px", pointsize = 12, res = 300)

      } else if(input$filetype_SP == "pdf") {
        
	pdf(filename_galaxy,width = 10, height = 10)
      }  
      
      scatter_plot()
      dev.off()      
      
      command_SP <- paste("python ", path_to_API_tools, "import.py ", history_id, " ", filename_galaxy, sep="")
      system(command_SP)
      
      #extra
      write(command_SP, file = "log", append = TRUE, sep = "\n")
      
      
      
      log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "--", filename_galaxy, 'copied into history', history_id, sep=' ')
      write(log_text, file = "log", append = TRUE, sep = "\n")
    }
  )
  
  
  output$info_SP <- renderPrint({
  # brush scatter plot output
  
    # define which contrast data to use   
    XcolSP_brush <- paste("log2",input$xcolSP,sep=" ")
    YcolSP_brush <- paste("log2",input$ycolSP,sep=" ")
    
    data_brush_SP <- data.frame(ID = rownames(data),
                       XcolSP = log2(data[,input$xcolSP]),
                       YcolSP = log2(data[,input$ycolSP]))
    
    colnames(data_brush_SP) <- c('ID',XcolSP_brush,YcolSP_brush)
        
    brushedPoints(data_brush_SP[,c(1,2,3)], input$plot_brush_SP, xvar = XcolSP_brush, yvar = YcolSP_brush)
   			
 })
 
 
  output$download_highlighted_Data_SP <- downloadHandler(
    #Download elements above the cutoffs
    
    filename = function() {
      paste("data-", Sys.Date(), ".tab", sep="")
    },
    content = function(file) {

      cutoff <- rownames(data)[log2(data[, input$xcolSP]) > input$xcoffSP & log2(data[, input$ycolSP]) > input$ycoffSP]	        
      df <- data.frame(ID=cutoff, X= log2(data[cutoff, input$xcolSP]), Y= log2(data[cutoff, input$ycolSP]) )

      write.table(df, file,sep="\t", row.names = FALSE, quote=FALSE)       

      params <- paste("X cutoff > ",input$xcoffSP, "; Y cutoff > ",input$ycoffSP, sep="")      
      log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "prepare table (points above cutoff in scatter plot) for download", 
                                                                    input$xcolSP, input$ycolSP, params, sep=' -- ')
      write(log_text, file = "log", append = TRUE, sep = "\n")
      filename_galaxy <- paste(Sys.time(), '_data_above_cuttoff_in_scatterplot', '.tab', sep='')
      filename_galaxy <- gsub(" ", "_", filename_galaxy)

      write.table(df, filename_galaxy,sep="\t", row.names = FALSE, quote=FALSE)
      
      command_HL_SP <- paste("python ", path_to_API_tools, "import.py ", history_id, " ", filename_galaxy, sep="")
      system(command_HL_SP)
      log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "--", filename_galaxy, 'copied into history', history_id, sep=' ')
      write(log_text, file = "log", append = TRUE, sep = "\n")
      
    }
  ) 


   output$downloadData_SP <- downloadHandler(
   # download scatter plot selection
   
    filename = function() {
      paste("data-", Sys.Date(), ".tab", sep="")
    },
    content = function(file) {
          XcolSP_brush <- paste("log2",input$xcolSP,sep=" ")
          YcolSP_brush <- paste("log2",input$ycolSP,sep=" ")
    
          data_brush_SP <- data.frame(ID = rownames(data),
                             XcolSP = log2(data[,input$xcolSP]),
                             YcolSP = log2(data[,input$ycolSP]))
    
          colnames(data_brush_SP) <- c('ID',XcolSP_brush,YcolSP_brush)          
          
          df <- rbind(brushedPoints(data_brush_SP[,c(1,2,3)], input$plot_brush_SP, xvar = XcolSP_brush, yvar = YcolSP_brush))
          write.table(df, file,sep="\t", row.names = FALSE, quote=FALSE)      

          log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "prepare table (scatter plot) for download", input$xcolSP, input$ycolSP, sep=' -- ')
          write(log_text, file = "log", append = TRUE, sep = "\n")
          filename_galaxy <- paste(Sys.time(), '_scatterplotdata', '.tab', sep='')
          filename_galaxy <- gsub(" ", "_", filename_galaxy)

          write.table(df, filename_galaxy,sep="\t", row.names = FALSE, quote=FALSE)
      
          command_SEL_SP <- paste("python ", path_to_API_tools, "import.py ", history_id, " ", filename_galaxy, sep="")
          system(command_SEL_SP)
          log_text <- paste(format(Sys.time(), "%a %b %d %Y %H:%M:%S"), "--", filename_galaxy, 'copied into history', history_id, sep=' ')
          write(log_text, file = "log", append = TRUE, sep = "\n")
      
    }
  )  
  
  

  

 

}
