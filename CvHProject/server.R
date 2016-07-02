#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

movies <- readRDS("movies.rda")
users <- readRDS("users.rda")
ratings <- readRDS("ratings.rda")



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$appData <- renderUI({
      # determine broad job category
      # myJobCat <- users[users$occupation == input$occupation,]$jobCategory[1]
      # myJobCat <- users[users$occupation == input$occupation,]
      # determine full cohort
      myCohort <- users[users$ageGroup == input$age &
                        users$gender == input$gender &
                        users$occupation == input$occupation, ]


      # find all ratings from my cohort
      myCohortRatings <-
        ratings[ratings$user.id %in% myCohort$user.id, ]

      # find all movies rated by my cohort
      myCohortFavorites <-
        movies[movies$movie.id %in% myCohortRatings$item.id, ]

      # add column for average rating for each movie
      myCohortFavorites$avgCohortRating <-
        sapply(myCohortFavorites$movie.id, function (x) {
          mean(myCohortRatings[myCohortRatings$item.id == x, ]$rating)
        })

      # add column with number of ratings per movie
      myCohortFavorites$numRaters <-
        sapply(myCohortFavorites$movie.id, function (x) {
          nrow(myCohortRatings[myCohortRatings$item.id == x, ])
        })

      # here I calculate a weighted score for all items in cohort
      # first with some preliminary items totals, then calculating for each item.
      totalNumRatings <- nrow(myCohortRatings)
        #sum(as.numeric(myCohortFavorites$numRaters))
      meanCohortRating <- mean(as.numeric(myCohortFavorites$avgCohortRating))
      meanNumRaters <- mean(as.numeric(myCohortFavorites$numRaters))

      # calculating each adjusted rating; 5 is the highest score possible.
      myCohortFavorites$adjustedRating <-
        sapply(myCohortFavorites$movie.id , function (x) {
          #(
            (( meanCohortRating * meanNumRaters ) +
           ( myCohortFavorites[myCohortFavorites$movie.id == x, ]$numRaters *
             myCohortFavorites[myCohortFavorites$movie.id == x, ]$avgCohortRating)) *  5 )
        #totalNumRatings
        })


      # sort by cohort average, but just get the top 10
      # ordered by number of ratings, then by rating
      myCohortTopTen <- myCohortFavorites[with(myCohortFavorites,
                                               order(adjustedRating,
                                                     decreasing = TRUE)),][1:10,]


      if (nrow(myCohortRatings) != 0) {
        tags$div(
          h4("Ten Top Rated Movies"),
          tags$div(
            h5(paste(nrow(myCohort), " raters meeting criteria at left rated ",
                     nrow(myCohortRatings), " movies.")),
            h5("These are the top ten choices.")
          ),
          tags$div(
            tags$ol(
               apply(myCohortTopTen,1,FUN = function(x) {
                 tags$li(paste( x['title'], " // Rating: ",
                                x['adjustedRating']))
               })
            )
          )
        )
      } else {
        h5("No ratings available")
      }
 } )

})

