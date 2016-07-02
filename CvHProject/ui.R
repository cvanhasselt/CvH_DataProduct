#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

occupations <- c("administrator",
                 "artist",
                 "doctor",
                 "educator",
                 "engineer",
                 "entertainment",
                 "executive",
                 "healthcare",
                 "homemaker",
                 "lawyer",
                 "librarian",
                 "marketing",
                 "programmer",
                 "retired",
                 "salesman",
                 "scientist",
                 "student",
                 "technician",
                 "writer",
                 "none",
                 "other")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title and intro
  titlePanel("My Kind of Movies!"),
  h3("Find a movie that is right for you"),
  helpText(paste("Make selections below matching your age, gender, and occupation.\n",
                 "The app will find movies you may like, based on your choices.")),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("age", label = h3("Your Age Range"),
                   choices = list("< 25 years" = 1,
                                  "25 - 34 years" = 2,
                                  "35 - 50 years" = 3,
                                  "> 50 years" = 5),
                   selected = 2),
      radioButtons("gender", label = h3("Your Gender"),
                   choices = list("Male" = "M" ,  "Female" = "F"),
                   selected = "M"),

      selectInput("occupation", label = h3("Your Occupation"),
                  choices = c("Choose occupation" = "",occupations),
                  selected = 1),
      submitButton(text = "Go!", icon("refresh")),
      helpText("Click to update the movie list.")
    ),

    # Shows server output
    mainPanel(
      tabsetPanel(
        tabPanel("Movies", uiOutput("appData")),
        tabPanel("About this App", includeMarkdown("helpfile.md"))
      )
    )
  )
))
