library(rCharts) 

shinyUI(pageWithSidebar(
  headerPanel("Twitter activity"),
  sidebarPanel(
    h1('Draw menu'),
    selectInput("inputX", "observable X:", choices = c('Time'='dt','User ID'='userId','Length of post'='PostLength')),
    selectInput("inputY", "observable Y:", choices = c('None'='none', 'Time'='dt','User ID'='userId','Length of post'='PostLength')),

    sliderInput('xlow', 'Minimum X',value = 0,   min = 0, max = 100, step = 1,),
    sliderInput('xhigh','Maximum X',value = 100, min = 0, max = 100, step = 1,),

    sliderInput('ylow', 'Minimum Y',value = 0,   min = 0, max = 100, step = 1,),
    sliderInput('yhigh','Maximum Y',value = 100, min = 0, max = 100, step = 1,)

#    numericInput('id1', 'Numeric input, labeled id1', 0, min = 0, max = 10, step = 1),
#    checkboxGroupInput("id2", "Checkbox",
#          c("Value 1" = "1",
#            "Value 2" = "2",
#            "Value 3" = "3")),
#    dateInput("date", "Date:")
  ),
  mainPanel(
    p('The Twitter platform has gained millions of users from all around the world and it is generating an endless stream of data. Although, Twitter is also used routinely by PR departments of corporations, universities, and heads of states to propagate their agendas to public, the majority of tweets still comes from regular users and can possibly be used to as a probe of a "public mood". The idea has drawn a lot of attention from the academic community and there was one particularly interesting publication on', a("crowd behavior", href="http://arxiv.org/abs/1402.2308", target="_blank"),'.'),
    p('Using twitter API we have collected a decent number of tweets coming from a particular place in the world. A few very basic observables were selected and added to this application. You can choose between 3 of those observables and visualize 1-dimensional distributions and 2-dimensionals scatter plots. In addition you can zoom in and out these plots using the slider bars.'),
    plotOutput('myHist'),
    verbatimTextOutput("events"),
    showOutput("myChart", "dimple")
  )
))
