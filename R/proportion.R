#########################################################################
#
# Package:
#
# File: proportion.R
# Contains: proportion
#
# Written by Samuel Beazley
#
# First version: March-2021
# Last update: 5-Apr-2021
#
#########################################################################
#'
#' Test parentage of individual
#'
#' Given individual and a vectors of possible parents, function returns dataframe of proportion of pedigree conflict with each possible trio
#'
#' @param parents a vector with strings related to the name of the suspected parents
#' @param individual a string value with the individual name you are testing
#' @param data the dataframe from which the data is from
#'
#' @return A dataframe of different combinations of parents and individual with the proportion of pedigree conflicts in each trio
#' 
#' @examples
#' data(potato.data)
#' proportion(parents = c("W6511.1R","VillettaRose","W9914.1R"),
#'            individual = "W15268.1R",
#'            data = potato.data)
#'
#' @export

proportion <- function(parents, individual, data)
{
  table <- gtools::combinations(n = length(parents), r = 2, repeats.allowed = F, v = parents) #unique combinations of parents
  table <- cbind(table, rep(individual, dim(table)[1]) ) #creating table of parents to test

  vec <- c() #initializing vector

  for(i in 1:dim(table)[1])
  {
    vec <- cbind(vec, paternity(cbind(data[[ table[i,1] ]], data[[ table[i,3] ]], data[[ table[i,2] ]]) )) #vector of statistic values
  }

  table <- cbind(table, t(vec)) #adding statistic column
  colnames(table) <- c("Parent1", "Parent2", "Individual", "Statistic") #labelling columns

  DF <- as.data.frame(subset(table, select = c("Parent1", "Parent2", "Statistic"))) #final dataframe

  return(DF)
}
