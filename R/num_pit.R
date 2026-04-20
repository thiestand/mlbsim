#' Generate Number of Pitches in a Plate Appearance
#'
#' This function is used within the sim_inning function generate the number of pitches in a plate appearance
#' @param outcome the result of a plate appearance
#' @param table a table of likelihoods that a certain number of pitches will be thrown in a pa
#' @import dplyr
#' @keywords baseball
#' @export
#' @examples
#' num_pit(outcome = "Double", table = pitch_table)

num_pit <- function(outcome = "Strikeout", table = pitch_table) {
  #require(dplyr)
  df <- dplyr::filter(table, result == outcome)
  num <- sample(df$nump, size = 1, prob = df$pit)
  num
}
