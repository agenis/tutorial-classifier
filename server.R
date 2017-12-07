
#####################################################
#  SHINY SERVER
#####################################################


server = function(input, output, session){
     
     # create fake data with a big spam area in the middle...
     df = reactive({
          m = 30 
          temp = expand.grid('x'=1:m, 'y'=1:m, 'spam'=FALSE, stringsAsFactors = FALSE)
          area.spam = round(sqrt(input$amount))
          coord.min = round(m/2-area.spam/2)
          coord.max = round(m/2+area.spam/2)
          where.spam <- (temp$x>coord.min & temp$x<coord.max & temp$y>coord.min & temp$y<coord.max)
          temp[where.spam, 'spam'] <- TRUE
          temp
     })
     
     # render plot for the user to brush
     output$main_plot = renderPlot({
          ggplot(data=df()) + aes(x=x, y=y, col=spam) + geom_point(shape="@", size=3.5) +
               scale_color_manual(values=c("darkgrey", "red"), guide=FALSE) +
               theme_void() + guides(fill=FALSE)
     })
     
     # Create reactive value to store the predicted data, initialized NULL 
     vals = reactiveValues(
          classified.data = data.frame(NULL),
          acc=NULL,
          prec=NULL,
          rec=NULL,
          f1=NULL
     )
     
     # refresh computation on any of theses events:
     toListen <- reactive({
          list(input$brush, input$amount, input$beta)
     })
     
     # after each brush, update the classified data
     observeEvent(toListen(), handlerExpr = {
          vals$classified.data <- brushedPoints(df(), input$brush, xvar = "x", yvar = "y", allRows = TRUE)
          pred      <- prediction(predictions=as.numeric(vals$classified.data$selected_), labels=as.numeric(vals$classified.data$spam))
          vals$acc  <- round(100*performance(pred, "acc")@y.values[[1]][2], 1)
          vals$prec <- round(100*performance(pred, "prec")@y.values[[1]][2], 1)
          vals$rec  <- round(100*performance(pred, "rec")@y.values[[1]][2], 1)
          vals$f1   <- round(100*performance(pred, "f", alpha=input$beta)@y.values[[1]][2], 1)
          })
     

     # infoboxes
     output$accuracy_output  = renderInfoBox({infoBox("Accuracy",  paste0(vals$acc, " %"),  icon = icon("ok", lib = "glyphicon"), color = "yellow")})
     output$precision_output = renderInfoBox({infoBox("Precision", paste0(vals$prec, " %"), icon = icon("zoom-in", lib = "glyphicon"), color = "yellow")})
     output$recall_output    = renderInfoBox({infoBox("Recall",    paste0(vals$rec, " %"),  icon = icon("thumbs-up", lib = "glyphicon"), color = "yellow")})
     output$f1_output        = renderInfoBox({infoBox("F1-score",  paste0(vals$f1, " %"),   icon = icon("screenshot", lib = "glyphicon"), color = "yellow")})
     
}
