library(UsingR)
library(ggplot2)
library(rCharts)

ukr <- read.csv(file="ukr.txt", header=T, sep=',', encoding = "UTF-8", stringsAsFactors = F)
ukr$dt  <- as.POSIXct( ukr$DateTime, format="%Y-%m-%d %H:%M:%S",  tz = "GMT")

shinyServer(
  function(input, output) {
    nEvents <- 0
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
    })
    output$events <- renderPrint({
      x <- input$inputX
      y <- input$inputY
      xlow  <- input$xlow
      xhigh <- input$xhigh
      ylow  <- input$ylow
      yhigh <- input$yhigh

      nEvents <- 0

      if( y!='none' ){
        rangeX = max(ukr[[x]]) - min(ukr[[x]])
        rangeY = max(ukr[[y]]) - min(ukr[[y]])
        ua <- subset(ukr, ukr[[x]] > min(ukr[[x]]) + xlow/100.*rangeX & ukr[[x]] < min(ukr[[x]]) + xhigh/100.*rangeX &
                          ukr[[y]] > min(ukr[[y]]) + ylow/100.*rangeY & ukr[[y]] < min(ukr[[y]]) + yhigh/100.*rangeY)
        nEvents <- dim(ua)[1]
      } else {
        rangeX = max(ukr[[x]]) - min(ukr[[x]])
        ua <- subset(ukr, ukr[[x]] > min(ukr[[x]]) + xlow/100.*rangeX & ukr[[x]] < min(ukr[[x]]) + xhigh/100.*rangeX)
        nEvents <- dim(ua)[1]
      } 

      if( nEvents > 100 )
         paste(nEvents," events captured, sampling 100 random events below")
      else
         paste(nEvents," events captured, all are shown below")
    })

    output$myChart = renderChart({

      x <- input$inputX
      y <- input$inputY
      xlow  <- input$xlow
      xhigh <- input$xhigh
      ylow  <- input$ylow
      yhigh <- input$yhigh

      nEvents <- 0

      if( y!='none' ){
        rangeX = max(ukr[[x]]) - min(ukr[[x]])
        rangeY = max(ukr[[y]]) - min(ukr[[y]])
        ua <- subset(ukr, ukr[[x]] > min(ukr[[x]]) + xlow/100.*rangeX & ukr[[x]] < min(ukr[[x]]) + xhigh/100.*rangeX &
                          ukr[[y]] > min(ukr[[y]]) + ylow/100.*rangeY & ukr[[y]] < min(ukr[[y]]) + yhigh/100.*rangeY)
        nEvents <- dim(ua)[1]
      } else {
        rangeX = max(ukr[[x]]) - min(ukr[[x]])
        ua <- subset(ukr, ukr[[x]] > min(ukr[[x]]) + xlow/100.*rangeX & ukr[[x]] < min(ukr[[x]]) + xhigh/100.*rangeX)
        nEvents <- dim(ua)[1]
      } 

      if( nEvents>100 )
        ua <- ua[runif(n = 100, min = 0, max = nEvents),] 

      if( y=='none' ) y=x

        if( x=="dt" ) x="DateTime"
        if( y=="dt" ) y="DateTime"
        d1 <- dPlot(x=x, y=y, groups = c("userId","Text"), data = ua, type = "bubble") #, height=800, width=1000)

        if( x=='DateTime' )
            d1$xAxis(type = "addTimeAxis", inputFormat = "%Y-%m-%d %H:%M:%S", outputFormat = "%Y-%m-%d %H:%M:%S")
        if( y=='DateTime' )
            d1$yAxis(type = "addTimeAxis", inputFormat = "%Y-%m-%d %H:%M:%S", outputFormat = "%Y-%m-%d %H:%M:%S")

        d1$addParams(dom = 'myChart')

        return(d1)

    })

  }
)
