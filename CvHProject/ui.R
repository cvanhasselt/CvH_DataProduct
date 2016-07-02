#
# "My Kind of Movies!" Shiny Web app - User Interface
#  By Chris van Hasselt
#  07/03/2016
#  Built for the Coursera Data Products Course
#
#  The "My Kind of Movies!" app is based on data found through the
#  Grouplens Project, (http://grouplens.org/datasets/movielens/)
#  and usese data from their benchmark dataset(http://grouplens.org/datasets/movielens/100k/)
#  of 100,000 movie ratings of 1,700 different movies from one-thousand survey respondents.
#
#  More info about this project can be found at the above hyperlinks, and you
#  can read about it in this article:
#
#     F. Maxwell Harper and Joseph A. Konstan. 2015. The MovieLens Datasets:
#     History and Context. ACM Transactions on Interactive Intelligent
#     Systems (TiiS) 5, 4, Article 19 (December 2015), 19 pages.
#     DOI=http://dx.doi.org/10.1145/2827872

library(shiny)

# selection of professions, from the Movielens project data
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

  # Application title, introduction, and basic help informatiio
  titlePanel("My Kind of Movies!"),
  h3("Find a movie that is right for you"),
  helpText(paste("Make selections below matching your age, gender, and occupation.\n",
                 "The app will find movies you may like, based on your choices.")),

  # Sidebar with a slider input for data input of age, gender, and occupation
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

      # action in main panel triggered by "Go" button.
      submitButton(text = "Go!", icon("refresh")),
      helpText("Click to update the movie list.")
    ),

    # Shows server output
    mainPanel(
      tabsetPanel(
        # main results panel
        tabPanel("Movies", uiOutput("appData")),

        # help panel
        tabPanel("About this App", includeMarkdown("helpfile.md"))
      )
    )
  )
))
