# Building Predictive Text Models for Twitter, News, and Blogs Corpora 

This is an educational Capstone Project, which is the part of [Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1?utm_medium=listingPage) provided by Johns Hopkins University on Coursera. 

## Introduction

Around the world, people are spending an increasing amount of time on their mobile devices for email, social networking, banking and a whole range of other activities. But typing on mobile devices can be a serious pain. Smart keyboard can make it easier for people to type on their mobile devices. One cornerstone of a smart keyboard is predictive text models. When someone types: 

"I went to the" 

the keyboard presents three options for what the next word might be. For example, the three words might be gym, store, restaurant. In this capstone we will work on understanding and building predictive text models, and we will develop a presentational Web App for our model built. 

The capstone consists of three deliverable components:

1. A predictive text model
2. A reproducible R markdown document describing model building process
3. A data product built with Shiny to demonstrate the use of the product 

## Data

The dataset provided by [Coursera](https://www.coursera.org/) can be downloaded here:

[Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)

The files in the dataset named LOCALE.blogs.txt where LOCALE is the each of the four locales en_US, de_DE, ru_RU and fi_FI. For our tasks we will use English LOCALE only. The data is from a corpus called [HC Corpora](http://www.corpora.heliohost.org). For more details see the [README file](http://www.corpora.heliohost.org/aboutcorpus.html). The files have been language filtered but may still contain some foreign text.
Note that the raw data contain words of offensive and profane meaning.

## Results

You can explore the report about project and the reproducible R markdown document describing model building and testing process here:

[Report](http://htmlpreview.github.io/?https://github.com/HukoJack/Natural_Language_Processing_Project/blob/master/Report.html)

[Reproducible Rmd](https://github.com/HukoJack/Natural_Language_Processing_Project/blob/master/Report.Rmd)

You can have access to demonstrational Web application here:

[Word Prediction App](https://hukojack.shinyapps.io/Word_Prediction/)  It might take a few seconds for application to load.
