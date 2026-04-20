#' Average Batter Profiles
#'
#' Average results for batters with less than 150 plate appearances in 2024.
#'
#' @format ## `avg_profiles`
#' A data frame with 3 rows and 8 columns.
#' \describe{
#'   \item{bathand}{handedness of batter}
#'   \item{bat_kpct}{proportion of plate appearances resulting in strikeout}
#'   \item{bat_1Bpct}{proportion of plate appearances resulting in single}
#'   \item{bat_2Bpct}{proportion of plate appearances resulting in double}
#'   \item{bat_3Bpct}{proportion of plate appearances resulting in triple}
#'   \item{bat_HRpct}{proportion of plate appearances resulting in home run}
#'   \item{bat_fbpct}{proportion of plate appearances resulting in a walk or hbp}
#'   \item{bat_ipoutpct}{proportion of plate appearances resulting in an in play, out}
#' }
#' @source <https://retrosheet.org/downloads/plays.html>
"avg_profiles"

#' Default Lineups
#'
#' Default lineups for each of the 30 MLB teams.
#'
#' @format ## `lineups`
#' A data frame with 9 rows and 30 columns.
#' \describe{
#'   \item{Phillies}{lineup of 9 Phillies hitters}
#'   \item{Braves}{lineup of 9 Braves hitters}
#'   \item{Nationals}{lineup of 9 Nationals hitters}
#'   ...
#' }
#' @source <https://retrosheet.org/downloads/plays.html>
"lineups"

#' 2024 MLB Batters
#'
#' A compilation of each batter from the 2024 MLB season and their given percentages
#'
#' @format ## `batters`
#' A data frame with 651 rows and 14 columns.
#' \describe{
#'   \item{batter}{a code corresponding to the name of the batter}
#'   \item{bathand}{the batters' handedness}
#'   \item{bat_kpct}{the batters' strikeout percentage}
#'   \item{bat_fbpct}{the batters' walk percentage}
#'   \item{bat_1Bpct}{the batters' single percentage}
#'   \item{bat_2Bpct}{the batters' double percentage}
#'   \item{bat_3Bpct}{the batters' triple percentage}
#'   \item{bat_HRpct}{the batters' home run percentage}
#'   \item{bat_ipoutpct}{the batters' in play, out percentage}
#'   \item{bat_pa}{the batters' number of plate appearances}
#'   \item{last}{the batters' last name}
#'   \item{first}{the batters' first name}
#'   \item{nickname}{the batters' nickname}
#'   \item{name}{the batters' full name}
#' }
#' @source <https://retrosheet.org/downloads/plays.html>
"batters"

#' 2024 MLB Pitchers
#'
#' A compilation of each pitcher from the 2024 MLB season and their given percentages
#'
#' @format ## `pitchers`
#' A data frame with 855 rows and 14 columns.
#' \describe{
#'   \item{pitcher}{a code corresponding to the name of the pitcher}
#'   \item{pithand}{the pitchers' handedness}
#'   \item{pit_kpct}{the pitchers' strikeout percentage}
#'   \item{pit_fbpct}{the pitchers' walk percentage}
#'   \item{pit_1Bpct}{the pitchers' single percentage}
#'   \item{pit_2Bpct}{the pitchers' double percentage}
#'   \item{pit_3Bpct}{the pitchers' triple percentage}
#'   \item{pit_HRpct}{the pitchers' home run percentage}
#'   \item{pit_ipoutpct}{the pitchers' in play, out percentage}
#'   \item{pit_pa}{the pitchers' number of plate appearances}
#'   \item{last}{the pitchers' last name}
#'   \item{first}{the pitchers' first name}
#'   \item{nickname}{the pitchers' nickname}
#'   \item{name}{the pitchers' full name}
#' }
#' @source <https://retrosheet.org/downloads/plays.html>
"pitchers"

#' Model Coefficients
#'
#' A compilation of coefficients for each model from the 2024 season.
#'
#' @format ## `model_coef`
#' A data frame with 42 rows and 3 columns.
#' \describe{
#'   \item{result}{the outcome of a plate appearance}
#'   \item{names}{the names of the coefficients}
#'   \item{coefs}{the numerical values of the coefficients}
#' }
#' @source <https://retrosheet.org/downloads/plays.html>
"model_coef"

#' Pitch Table
#'
#' A data frame of the likelihoods that a pa will result in a certain number of pitches.
#'
#' @format ## `pitch_table`
#' A data frame with 80 rows and 4 columns.
#' \describe{
#'   \item{nump}{the number of pitches in a plate appearance}
#'   \item{pit}{the amount of times this frequency of pitches was thrown}
#'   \item{prop}{the proportion of pitch frequency}
#'   \item{result}{the result of the plate appearance}
#' }
#' @source <https://retrosheet.org/downloads/plays.html>
"pitch_table"

#' Default Bullpens
#'
#' Default bullpens for each of the 30 MLB teams.
#'
#' @format ## `bullpens`
#' A data frame with 3 rows and 30 columns.
#' \describe{
#'   \item{Phillies}{bullpen of 3 Phillies pitchers}
#'   \item{Braves}{bullpen of 3 Braves hitters}
#'   \item{Nationals}{bullpen of 3 Nationals hitters}
#'   ...
#' }
#' @source <https://retrosheet.org/downloads/plays.html>
"bullpens"
