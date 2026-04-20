#' Simulate a Full MLB Game
#'
#' This function lets you simulate an MLB game.
#' @param home_lineup lineup for the home team
#' @param home_starter starter for the home team
#' @param home_bullpen vector of bullpen pitchers for the home team
#' @param away_lineup lineup for the away team
#' @param away_starter starter for the away team
#' @param away_bullpen vector of bullpen pitchers for the away team
#' @param box_score whether to print the box_score: TRUE or FALSE
#' @param print whether to print the result of the pa: "none" (the default) or "result"
#' @import dplyr
#' @keywords baseball
#' @export
#' @examples
#' sim_full_game(home_lineup=lineups$Reds,  home_starter = "Hunter Greene",
#' home_bullpen = c("Fernando Cruz", "Buck Farmer", "Alexis Diaz"),
#' away_lineup = lineups$Brewers, away_starter = "Freddy Peralta",
#' away_bullpen = c("Jared Koenig", "Hoby Milner", "Trevor Megill"), box_score = TRUE,
#' print = "none")
#' sim_full_game()

sim_full_game <- function (
    home_lineup = lineups$Cubs,
    home_starter = "Justin Steele",
    home_bullpen = c("Drew Smyly", "Tyson Miller", "Porter Hodge"),
    away_lineup = lineups$Twins,
    away_starter = "Joe Ryan",
    away_bullpen = c("Griffin Jax", "Cole Sands", "Jhoan Duran"),
    box_score = TRUE,
    print = "none") {
  #require(dplyr)

  h_spot <- 1
  a_spot <- 1

  h_runs <- 0
  a_runs <- 0

  h_hits <- 0
  a_hits <- 0

  h_hr <- 0
  a_hr <- 0

  h_bb <- 0
  a_bb <- 0

  h_box <- NULL
  a_box <- NULL

  # -------- line score storage --------
  away_line <- c()
  home_line <- c()

  game_end <- FALSE
  inning <- 0

  while (!game_end) {

    inning <- inning + 1

    # ---------------- TOP (Away batting) ----------------

    away_pitcher <- case_when(
      inning == 7 ~ home_bullpen[1],
      inning == 8 ~ home_bullpen[2],
      inning >= 9 ~ home_bullpen[3],
      TRUE ~ home_starter
    )

    away_result <- sim_inning(
      batters = away_lineup,
      pit = away_pitcher,
      spot = a_spot,
      print = print
    )

    a_runs <- a_runs + away_result$runs
    a_hits <- a_hits + away_result$hits
    a_hr <- a_hr + away_result$hr
    a_bb <- a_bb + away_result$bb
    a_spot <- away_result$spot

    away_line[inning] <- away_result$runs

    a_box <- rbind(a_box,
                   cbind(away_result$box_score,
                         inning = inning,
                         half = "Top"))

    # Skip bottom inning if home already ahead
    if (inning >= 9 && h_runs > a_runs) {
      home_line[inning] <- NA
      game_end <- TRUE
      break
    }

    # ---------------- BOTTOM (Home batting) ----------------

    home_pitcher <- case_when(
      inning == 7 ~ away_bullpen[1],
      inning == 8 ~ away_bullpen[2],
      inning >= 9 ~ away_bullpen[3],
      TRUE ~ away_starter
    )

    home_result <- sim_inning(
      batters = home_lineup,
      pit = home_pitcher,
      spot = h_spot,
      print = print
    )

    h_runs <- h_runs + home_result$runs
    h_hits <- h_hits + home_result$hits
    h_hr <- h_hr + home_result$hr
    h_bb <- h_bb + home_result$bb
    h_spot <- home_result$spot

    home_line[inning] <- home_result$runs

    h_box <- rbind(h_box,
                   cbind(home_result$box_score,
                         inning = inning,
                         half = "Bottom"))

    if (inning >= 9 && h_runs != a_runs) {
      game_end <- TRUE
    }
  }

  # -------- print line score --------

  max_inn <- length(away_line)

  line_score <- rbind(
    Away = c(away_line, a_runs, a_hits),
    Home = c(home_line, h_runs, h_hits)
  )

  colnames(line_score) <- c(
    paste0(1:max_inn),
    "R",
    "H"
  )

  print(line_score)

  print(paste0(
    "Final Score: Away ",
    a_runs,
    " - Home ",
    h_runs,
    " (",
    inning,
    " innings)"
  ))

  # -------- build box scores --------

  build_box <- function(box){

    bat_box <- box |>
      summarize(H = sum(result %in% c("Single","Double","Triple","Home Run")),
                HR = sum(result == "Home Run"),
                BB = sum(result == "Walk"),
                K = sum(result == "Strikeout"),
                PA = n(),
                .by = hitter) |>
      mutate(AB = PA - BB,
             BA = round(H/AB,3)) |>
      select(hitter, AB, H, HR, BB, K, BA)

    pit_box <- box |>
      summarize(BF = n(),
                PC = sum(pitch_count, na.rm = TRUE),
                H = sum(result %in% c("Single","Double","Triple","Home Run")),
                R = sum(runs),
                BB = sum(result == "Walk"),
                K = sum(result == "Strikeout"),
                HR = sum(result == "Home Run"),
                .by = pitcher)

    list(Batting = bat_box,
         Pitching = pit_box)
  }

  if (box_score) {

    away_batting  <- build_box(a_box)$Batting
    home_batting  <- build_box(h_box)$Batting

    home_pitching <- build_box(a_box)$Pitching
    away_pitching <- build_box(h_box)$Pitching

    full_box <- list(
      Away = list(
        Batting = away_batting,
        Pitching = away_pitching
      ),
      Home = list(
        Batting = home_batting,
        Pitching = home_pitching
      )
    )

    print(full_box)
  }


  invisible(list(
    away_runs = a_runs,
    home_runs = h_runs,
    innings = inning,
    line_score = line_score,
    full_box = full_box
  ))
}
