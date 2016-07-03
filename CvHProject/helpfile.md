---
title: "Explanation"
author: "Chris van Hasselt"
date: "June 24, 2016"
output: html_document
---

### Using the App

1. Select your age range.
2. Select your gender.
3. Select your occupation (or the occupation that seems most like yours)
4. Click the **Go!** button to see the **Top Ten Movies** for people matching the items you entered.

### About the Movies App

The _My Kind of Movies App_ is based on data found through [Grouplens Project](http://grouplens.org/datasets/movielens/) and their [benchmark dataset](http://grouplens.org/datasets/movielens/100k/) of 
100,000 movie ratings of 1,700 different movies from one-thousand survey respondents.

More information about the Grouplens project is found in this article:

F. Maxwell Harper and Joseph A. Konstan. 2015. The MovieLens Datasets:
History and Context. ACM Transactions on Interactive Intelligent
Systems (TiiS) 5, 4, Article 19 (December 2015), 19 pages.
DOI=http://dx.doi.org/10.1145/2827872

Visit the [GitHub Repository](https://github.com/cvanhasselt/CvH_DataProduct) for this app for 
more information about the code.

### Internals

People using the _My Kind of Movies App_ can select a few demographic characteristics 
to see a list of ten top movies as rated by people with a similar profile.  

This project involved preparing the Grouplens data for use in the app.  The file _dataTidying.R_, available at the app's GitHub repository, includes all code used to prepare the data.

This is a filtering application, not a predictive application.  A predictive
application might ask the participant to rate a random selection of movies, then identify the subset other people who had a similar rating profile, and identify a selection of movies that were popular with that subset.  This app answers the question "What movies do people similar to me like?", whereas a predictive app would answer the question "Given that I like (or dislike) these 5 movies, what other movies might I like, based on the ratings other people have given these movies?" The approach here is simpler, but it effectively demonstrates the power of Shiny.  
