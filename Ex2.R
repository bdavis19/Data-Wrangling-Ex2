# Set up the environment
library(tidyverse)
library(knitr)
library(kableExtra)
options(knitr.table.format = "html")

# Load data into RStudio
dfTitanic <- read.csv("titanic_original.csv", header = TRUE, sep = ",")

# Port of embarkation
# The embarked column has some missing values, which are known to correspond to passengers who actually embarked 
# at Southampton. Find the missing values and replace them with S. (Caution: Sometimes a missing value might be read 
# into R as a blank or empty string.)
print(grep("^$", dfTitanic$embarked))
dfTitanic$embarked <- sub("^$", "S", dfTitanic$embarked)

# You’ll notice that a lot of the values in the Age column are missing. While there are many ways to fill these 
# missing values, using the mean or median of the rest of the values is quite common in such cases.
# 1) Calculate the mean of the Age column and use that value to populate the missing values
# 2) Think about other ways you could have populated the missing values in the age column. Why would you pick any of 
# those over the mean (or not)?
tmean <- mean(dfTitanic$age, na.rm = TRUE)
dfTitanic$age[is.na(dfTitanic$age)] <- tmean

# To answer the second part of the question, another method as suggested is the median. That could give a better 
# representation of the age if there are a number of very young or very old people. The higher number of extremes
# will results in a skewed mean. We could also look at other factors along with the mean. So instead of taking the
# mean of everyone, we could use the mean of men, and the mean of women. Alternatively, we could drop the X youngest
# and oldest to get a better group of numbers to use that would more accurately represent an average.
# Were they a single passenger, and if so
# could a ticket be purchased by someone under a certain age? Could they be unaccompanied? We could break down the data
# further to try and discover insight that could potentially lead to more accurate results. The mode could be looked at
# to see if there's any particular number that has a higher appearance that the rest. If we don't know why the data
# is missing, and don't have other details to help infer the ages, I'm not sure if there's any better method than the 
# mean.

# You’re interested in looking at the distribution of passengers in different lifeboats, but as we know, many 
# passengers did not make it to a boat :-( This means that there are a lot of missing values in the boat column. 
# Fill these empty slots with a dummy value e.g. the string 'None' or 'NA'
dfTitanic$boat <- sub("^$", "none", dfTitanic$boat)

# You notice that many passengers don’t have a cabin number associated with them.
# Does it make sense to fill missing cabin numbers with a value?
# What does a missing value here mean?
# You have a hunch that the fact that the cabin number is missing might be a useful indicator of survival. 
# Create a new column has_cabin_number which has 1 if there is a cabin number, and 0 otherwise.
dfTitanic <- dfTitanic %>% mutate(has_cabin_number = ifelse(cabin == "", 0, 1))

# Write the file
write.csv(dfTitanic, "titanic_clean.csv")
