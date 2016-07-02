
# Movie data retrieved from the MovieLens project site.  A description of the data
# and full datasets are available there.  For this data product, the smallest
# dataset, with 100,000 ratings from 1000 users was used.
#
# URL: http://grouplens.org/datasets/movielens/

# data manipulation for the movies list

# setup column names. Genre columns set to 1 if categorized with that genre,
# allowing a movie to be in multiple genres.
movieCols <- c("movie.id","title","release.date","video.release.date","IMDB.url",
               "unknown",
               "action",
               "adventure",
               "animation",
               "childrens",
               "comedy",
               "crime",
               "documentary",
               "drama",
               "fantasy",
               "film.noir",
               "horror",
               "musical",
               "mystery",
               "romance",
               "sci.fi",
               "thriller",
               "war",
               "western")

setClass('dashDate')
setAs("character","dashDate", function (from) as.Date(from,format = '%d-%b-%Y'))

setClass('bool')
setAs("character","bool",function(from) as.logical(from == 1) )

# read in data file
movies <- read.delim("u.item",sep='|',header=FALSE, col.names = movieCols,
                     colClasses = c("title" = "character",
                                    "release.date" = "dashDate",
                                    "IMDB.url" = "character",
                                    "unknown" = "bool",
                                    "action" = "bool",
                                    "adventure" = "bool",
                                    "animation" = "bool",
                                    "childrens" = "bool",
                                    "comedy" = "bool",
                                    "crime" = "bool",
                                    "documentary" = "bool",
                                    "drama" = "bool",
                                    "fantasy" = "bool",
                                    "film.noir" = "bool",
                                    "horror" = "bool",
                                    "musical" = "bool",
                                    "mystery" = "bool",
                                    "romance" = "bool",
                                    "sci.fi" = "bool",
                                    "thriller" = "bool",
                                    "war" = "bool",
                                    "western" = "bool"))

# drop video.release.date, as it is all blank.
movies <- movies[,!names(movies) %in% c("video.release.date")]
saveRDS(movies, file = "CVHProject/movies.rda")

# define columns for users data frame
usersCols <- c("user.id","age","gender","occupation","zip.code")

# read in users file
users <- read.delim("u.user",sep='|',header=FALSE, col.names = usersCols)
# users$ageGroup <- cut(users$age,c(0,20,30,40,50,100),labels=c("1","2","3","4","5"))
users$ageGroup <- cut(users$age,c(0,25,35,50,100),labels=c("1","2","3","4"))


# For many occupations,the number of users reporting that occupation was very small.
# To enlarge the pool of users based on occupation, I created an occupational category
# field and mapped occupations based on those catetories.

users$jobCategory <- "x"
users[users$occupation %in% c("doctor","healthcare"),]$jobCategory <- "health"
users[users$occupation %in% c("entertainment","writer","artist"),]$jobCategory <- "creative"
users[users$occupation %in% c("technician","programmer","engineer","scientist"),]$jobCategory <- "technical"
users[users$occupation %in% c("other","retired","none","homemaker","student"),]$jobCategory <- "other"
users[users$occupation %in% c("lawyer","educator","librarian","administrator"),]$jobCategory <- "professional"
users[users$occupation %in% c("salesman","executive","marketing"),]$jobCategory <- "business"


users$jobCategory <- as.factor(users$jobCategory)
saveRDS(users, file = "CVHProject/users.rda")

# setup ratings column names
ratingsCols <- c("user.id","item.id","rating","timestamp")

# read in ratings data
ratings <- read.delim("u.data",sep='\t',header=FALSE,
                      col.names=ratingsCols)

# drop timestamp; we don't need it.
ratings <- ratings[,!names(ratings) %in% c("timestamp")]
saveRDS(ratings, file = "CVHProject/ratings.rda")


