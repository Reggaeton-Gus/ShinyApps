#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(qcc)
library(qicharts)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$ControlChart <- renderPlot({
    
    
    
    
    
    # FOR R Chart
    if ( input$DataType == "Continuous" & input$Groups == "Yes" & as.numeric(input$SubgroupSize)<8 ){
      # Vector of 24 subgroup sizes (average = 12)
      sizes <- rpois(24, 12)
      
      # Vector of dates identifying subgroups
      date <- seq(as.Date('2015-1-1'), length.out = 24, by = 'day')
      date <- rep(date, sizes)
      
      # Vector of birth weights
      y <- round(rnorm(sum(sizes), 3400, 400))
      
      # Data frame of birth weights and dates
      d <- data.frame(y, date)
      
      qic(y, 
          x     = date, 
          data  = d,
          chart = 'xbar',
          main  = 'Average birth weight (Xbar chart)',
          ylab  = 'Grams',
          xlab  = 'Date')
      
      output$Explanation <- renderText({ 
        "If there is more than one measurement in each subgroup the Xbar and S charts will display the average and the within subgroup standard deviation respectively."
      })
      
      
    }
    
    # FOR IMR
    if ( input$DataType == "Continuous" & input$Groups == "No"   ){
      y <- round(rnorm(24, mean = 3400, sd = 400))
      qic(y,
          chart = 'i',
          main  = 'Birth weight (I chart)',
          ylab  = 'Grams',
          xlab  = 'Baby no.')
      
      output$Explanation <- renderText({ 
        "If there is more than one measurement in each subgroup the Xbar and S charts will display the average and the within subgroup standard deviation respectively.
        I charts are often accompanied by moving range (MR) charts, which show the absolute difference between neighbouring data points."
      })
    }
    
    
    # FOR   S Chart
    if ( input$DataType == "Continuous" & input$Groups == "Yes" & as.numeric(input$SubgroupSize)>8 ){
      # Vector of 24 subgroup sizes (average = 12)
      sizes <- rpois(24, 12)
      
      # Vector of dates identifying subgroups
      date <- seq(as.Date('2015-1-1'), length.out = 24, by = 'day')
      date <- rep(date, sizes)
      
      # Vector of birth weights
      y <- round(rnorm(sum(sizes), 3400, 400))
      
      # Data frame of birth weights and dates
      d <- data.frame(y, date)
      
      qic(y, 
          x = date, 
          data = d,
          chart = 's',
          main = 'Standard deviation of birth weight (S chart)',
          ylab = 'Grams',
          xlab = 'Date')
      
      output$Explanation <- renderText({ 
      "The purpose of the MR chart is to identify sudden changes in the (estimated) within subgroup variation. If any data point in the MR is above the upper control limit, one should interpret the I chart very cautiously."
      
    })
      
    }
    
    
    #For U Chart
    if ( input$DataType == "Attribute" & input$Counting == "Defects per unit"   ){
       
      m.beds       <- 300
      m.stay       <- 4
      m.days       <- m.beds * 7
      m.discharges <- m.days / m.stay
      p.pu         <- 0.08
      
      # Simulate data
      discharges  <- rpois(24, lambda = m.discharges)
      patientdays <- round(rnorm(24, mean = m.days, sd = 100))
      n.pu        <- rpois(24, lambda = m.discharges * p.pu * 1.5)
      n.pat.pu    <- rbinom(24, size = discharges, prob = p.pu)
      week        <- seq(as.Date('2014-1-1'),
                         length.out = 24, 
                         by         = 'week') 
      
      # Combine data into a data frame
      d <- data.frame(week, discharges, patientdays,n.pu, n.pat.pu)
      d
      
      
      
      qic(n.pu, 
          n        = patientdays,
          x        = week,
          data     = d,
          chart    = 'u',
          multiply = 1000,
          main     = 'Hospital acquired pressure ulcers (U chart)',
          ylab     = 'Count per 1000 patient days',
          xlab     = 'Week')
      
      output$Explanation <- renderText({ 
      "To demonstrate the use of U and P charts for count data I created a data frame mimicking the weekly number of hospital acquired pressure ulcers at a hospital that, on average, has 300 patients with an average length of stay of four days. \n 
        Traditionally, the term defect has been used to name whatever it is one is counting with control charts. There is a subtle but important distinction between counting defects, e.g. number of pressure ulcers, and counting defectives, e.g. number of patient with one or more pressure ulcers. \n
        Defects are expected to reflect the poisson distribution, while defectives reflect the binomial distribution. \n
        
The U chart   accounts for variation in the area of opportunity, e.g. the number of patients or the number of patient days, over time or between units one wishes to compare."
         
    })
      
      
    }
    
    
    #For C Chart
    if ( input$DataType == "Attribute" & input$Counting == "Defective items"   ){
      m.beds       <- 300
      m.stay       <- 4
      m.days       <- m.beds * 7
      m.discharges <- m.days / m.stay
      p.pu         <- 0.08
      
      # Simulate data
      discharges  <- rpois(24, lambda = m.discharges)
      patientdays <- round(rnorm(24, mean = m.days, sd = 100))
      n.pu        <- rpois(24, lambda = m.discharges * p.pu * 1.5)
      n.pat.pu    <- rbinom(24, size = discharges, prob = p.pu)
      week        <- seq(as.Date('2014-1-1'),
                         length.out = 24, 
                         by         = 'week') 
      
      # Combine data into a data frame
      d <- data.frame(week, discharges, patientdays,n.pu, n.pat.pu)
      d
      
      
      
      qic(n.pu,
          x     = week,
          data  = d,
          chart = 'c',
          main  = 'Hospital acquired pressure ulcers (C chart)',
          ylab  = 'Count',
          xlab  = 'Week')
      
      output$Explanation <- renderText({ 
      "The P chart is is used to plot the proportion (or percent) of defective units, e.g. the proportion of patients with one or more pressure ulcers. Defectives are modelled by the binomial distribution. \n
        In theory, the P chart is less sensitive to special cause variation than the U chart because it discards information by dichotomising inspection units (patients) in defectives and non-defectives ignoring the fact that a unit may have more than one defect (pressure ulcers).

On the other hand, the P chart often communicates better. For most people, not to mention the press, the percent of harmed patients is easier to grasp than the the rate of pressure ulcers expressed in counts per 1000 patient days."
      })
      
      
    }
    
    
    
    
    
  })
  
  
  
})
