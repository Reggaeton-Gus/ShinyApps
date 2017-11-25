#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  pageWithSidebar(
    headerPanel (" Six Sigma Control Charts"),
     
    sidebarPanel(
      h5 ("Control Charts are six sigma tools that track process statistics over time to detect the presence of special causes of variation. There are different types of charts according to the data type that you are analysing."),
      
      selectInput("DataType", "Please select Data Type",
                  choices = c("Continuous", "Attribute")),
      conditionalPanel(condition = "input.DataType == 'Continuous'",
                       selectInput("Groups", "Data collected in groups?",
                                   choices = c("Yes", "No"))),
      conditionalPanel(condition = "input.DataType == 'Attribute'",
                       selectInput("Counting", "What are you counting?",
                                   choices = c("Defective items", "Defects per unit"))),
      
      
      conditionalPanel(condition = "input.Groups == 'Yes' & input.DataType == 'Continuous' ",
                       textInput ("SubgroupSize", "Enter sub group size",1 )    ) 
      
      
      
      
      
    ),
    
   
    
    mainPanel (
      plotOutput ("ControlChart"),
      textOutput("Explanation")
      
    )
    
    
  )
  
)
