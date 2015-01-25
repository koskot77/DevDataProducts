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
    plotOutput('myHist')
#,
#    p('some ordinary text')
  )
))
