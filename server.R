library(UsingR)
library(ggplot2)
ukr <- read.csv(file="ua.csv",header=T,sep=',')
ukr$dt  <- as.POSIXct( ukr$DateTime, format="%Y-%m-%d %H:%M:%S",  tz = "GMT")

shinyServer(
  function(input, output) {
    output$myHist <- renderPlot({
      x <- input$inputX
      y <- input$inputY
      xlow  <- input$xlow
      xhigh <- input$xhigh
      ylow  <- input$ylow
      yhigh <- input$yhigh

      if( x=='dt' )
          xlab <- "time (UTC+02)"
      if( x=='PostLength' )
          xlab <- "number of symbols in a post"
      if( x=='userId' )
          xlab <- "user identification number"
      if( y=='dt' )
          ylab <- "time (UTC+02)"
      if( y=='PostLength' )
          ylab <- "number of symbols in a post"
      if( y=='userId' )
          ylab <- "user identification number"

      if( y!='none' ){
        rangeX = max(ukr[[x]]) - min(ukr[[x]])
        rangeY = max(ukr[[y]]) - min(ukr[[y]])
        ua <- subset(ukr, ukr[[x]] > min(ukr[[x]]) + xlow/100.*rangeX & ukr[[x]] < min(ukr[[x]]) + xhigh/100.*rangeX &
                          ukr[[y]] > min(ukr[[y]]) + ylow/100.*rangeY & ukr[[y]] < min(ukr[[y]]) + yhigh/100.*rangeY)
        ggplot(data=ua, aes_string(x=x,y=y)) + geom_point(alpha=0.1,color="blue") + 
          theme(title = element_text(size = 15), axis.title.x = element_text(size = 15)) +
          labs(x=xlab,y=ylab,title="")
      } else {
        rangeX = max(ukr[[x]]) - min(ukr[[x]])
        ua <- subset(ukr, ukr[[x]] > min(ukr[[x]]) + xlow/100.*rangeX & ukr[[x]] < min(ukr[[x]]) + xhigh/100.*rangeX)
        width <- diff(range(ua[[x]]))
        if( x=='dt' )
            width <- as.numeric(width, units = "secs")
        nBins <- 1000
        if( x=='PostLength' )
            nBins = width
        ggplot(data=ua, aes_string(x=x)) + geom_histogram(binwidth = width/nBins,color="blue",fill="blue") + 
          theme(title = element_text(size = 15), axis.title.x = element_text(size = 15)) +
          labs(x=xlab,y="number of tweets",title="")
      }
#      output$oid1 <- renderPrint({input$id1})
    })
  }
)
