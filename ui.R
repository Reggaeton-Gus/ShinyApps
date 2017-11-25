#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#

library(shiny)


ui <- navbarPage("Six Sigma Control Charts",
                 tabPanel("Main",
                          fluidPage(
                            sidebarLayout(

                              # Sidebar
                              sidebarPanel(
                                h5 ("Control Charts are six sigma tools that track process statistics over time to detect the presence of special causes of variation."),
                                h5 ("There are different types of charts according to the data type that you are analysing."),

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

                              # Show a plot of the generated distribution
                              mainPanel(
                                plotOutput ("ControlChart"),
                                textOutput("Explanation")
                              )
                            )
                          )

                 ),
                 tabPanel("Documentation",
                          tags$br("Welcome to my first Shiny App. In this App you will learn a bit about Six Sigma Charts.
                                  Different charts are used according to the type of data you are analysing.
                                  For using this App, change the data input according to the data type you want to analysie.
                                  The App will show you which graph you need to use.
                                  And will give provide you with some information."),
                          h5 ("Enjoy!  And please let me know how I can improve the App.")
                          )
)
