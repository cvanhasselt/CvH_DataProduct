#
# "My Kind of Movies!" Shiny Web app - Server
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
library(markdown)

# load organized data; this data is not the original data from group lens
# A separate R script, dataTidying.R, is used to prepare these .rda files.
# This script is available at the GitHub repository for this project.
movies <- readRDS("data/movies.rda")
users <- readRDS("data/users.rda")
ratings <- readRDS("data/ratings.rda")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # prepare output data, to be rendered as HTML
    output$appData <- renderUI({

      # determine full cohort, based on user input of age, gender, occupation
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

      # here I calculate the mean cohort rating, for use in producing weighted scores.
      C <- mean(as.numeric(myCohortFavorites$avgCohortRating))

      # calculating each adjusted rating; 5 is the highest score possible.
      # This follows the formula explained at this URL:
      # http://stackoverflow.com/a/1411268/941255
      #
      # This is a Bayesian weighted mean - if I understand it correctly.
      #
      myCohortFavorites$adjustedRating <-
        sapply(myCohortFavorites$movie.id , function (x) {
          v <- myCohortFavorites[myCohortFavorites$movie.id == x,]$numRaters
          m <- 3 # arbitrarily chosen; must have at least 3 ratings
          R <- myCohortFavorites[myCohortFavorites$movie.id == x,]$avgCohortRating
          round(((v / (v + m) * R) + (m/(v+m))* C), digits=2)
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
            h5(paste("Ranking based on ratings of ",
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
          ),
          hr(),
          tags$div(
            p("Ratings are based on both the number of ratings and the mean rating
               for a particular movie within the group of users matching specified demographic
               criteria. Movies must have at least 3 ratings to show up in the list.
               Some combinantions of demographic criteria may have no results.")
          )
        )
      } else {
        h5("No ratings available")
      }
 } )

})

