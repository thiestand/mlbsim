#' Simulate a Plate Appearance
#'
#' This function lets you simulate an MLB plate appearance.
#' @param bat hitter for the pa
#' @param pit pitcher for the pa
#' @param pit_count pitch count
#' @param bat_data batter data
#' @param pit_data pitcher data
#' @param print whether to print the result of the pa: "none" (the default) or "result"
#' @import dplyr
#' @keywords baseball
#' @export
#' @examples
#' sim_pa(bat="Aaron Judge", pit = "Jack Flaherty")
#' sim_pa()

sim_pa <- function(bat = "Jarren Duran", pit = "Griffin Canning", pit_count = 1,
                   bat_data = batters, pit_data = pitchers,
                   print = "none") {
  #require(dplyr)
  #source("bat_regress.R")

  batter <- filter(bat_data, name == bat)

  if (nrow(batter) == 0) {
    message(paste("Batter", bat, "not found; using generic profile"))

    batter <- avg_profiles |>
      filter(bathand == "R")

    batter$name <- paste0("Generic_R_Hitter")
    batter$bat_pa <- 300
  }

  if(batter$bat_pa < 150){batter <- bat_regress(batter,avg_profiles)}
  pitcher <- filter(pit_data, name == pit)

  # K Prediction
  samehand <- batter$bathand == pitcher$pithand
  vals <- c(1, batter$bat_kpct, pitcher$pit_kpct, samehand, pit_count, pit_count^2)
  coefs <- filter(model_coef, result == "K")$coefs
  pred_k <- exp(sum(vals*coefs))/(1+exp(sum(vals*coefs)))

  # Free Base Prediction
  samehand <- batter$bathand == pitcher$pithand
  vals_fb <- c(1, batter$bat_fbpct, pitcher$pit_fbpct, samehand, pit_count, pit_count^2)
  coefs_fb <- filter(model_coef, result == "Walk")$coefs
  pred_fb <- exp(sum(vals_fb*coefs_fb))/(1+exp(sum(vals_fb*coefs_fb)))

  # Single Prediction
  samehand <- batter$bathand == pitcher$pithand
  vals_1b <- c(1, batter$bat_1Bpct, pitcher$pit_1Bpct, samehand, pit_count, pit_count^2)
  coefs_1b <- filter(model_coef, result == "Single")$coefs
  pred_1B <- exp(sum(vals_1b*coefs_1b))/(1+exp(sum(vals_1b*coefs_1b)))

  # Double Prediction
  samehand <- batter$bathand == pitcher$pithand
  vals_2b <- c(1, batter$bat_2Bpct, pitcher$pit_2Bpct, samehand, pit_count, pit_count^2)
  coefs_2b <- filter(model_coef, result == "Double")$coefs
  pred_2B <- exp(sum(vals_2b*coefs_2b))/(1+exp(sum(vals_2b*coefs_2b)))

  # Triple Prediction
  samehand <- batter$bathand == pitcher$pithand
  vals_3b <- c(1, batter$bat_3Bpct, pitcher$pit_3Bpct, samehand, pit_count, pit_count^2)
  coefs_3b <- filter(model_coef, result == "Triple")$coefs
  pred_3B <- exp(sum(vals_3b*coefs_3b))/(1+exp(sum(vals_3b*coefs_3b)))

  # Home Run Prediction
  samehand <- batter$bathand == pitcher$pithand
  vals_hr <- c(1, batter$bat_HRpct, pitcher$pit_HRpct, samehand, pit_count, pit_count^2)
  coefs_hr <- filter(model_coef, result == "Home Run")$coefs
  pred_HR <- exp(sum(vals_hr*coefs_hr))/(1+exp(sum(vals_hr*coefs_hr)))

  # In Play, Out Prediction
  samehand <- batter$bathand == pitcher$pithand
  vals_ipout <- c(1, batter$bat_ipoutpct, pitcher$pit_ipoutpct, samehand, pit_count, pit_count^2)
  coefs_ipout <- filter(model_coef, result == "In Play, Out")$coefs
  pred_ipout <- exp(sum(vals_ipout*coefs_ipout))/(1+exp(sum(vals_ipout*coefs_ipout)))


  pred_total <- pred_k + pred_fb + pred_1B + pred_2B + pred_3B + pred_HR + pred_ipout
  pred_k <- pred_k / pred_total
  pred_fb <- pred_fb / pred_total
  pred_1B <- pred_1B / pred_total
  pred_2B <- pred_2B / pred_total
  pred_3B <- pred_3B / pred_total
  pred_HR <- pred_HR / pred_total
  pred_ipout <- pred_ipout / pred_total

  props <- data.frame(out_ip = pred_ipout,
                      k = pred_k,
                      single = pred_1B,
                      fb = pred_fb,
                      double = pred_2B,
                      homer = pred_HR,
                      triple = pred_3B)
  rn <- runif(1)

  props2 <- props |> t() |> cumsum()

  # Use case_when() to determine the outcome.
  # Use the order ipout, k, 1b, fb, 2b, hr, 3b

  result <- case_when(rn < props2[1] ~ "In Play, Out",
                      rn > props2[1] & rn < props2[2] ~ "Strikeout",
                      rn > props2[2] & rn < props2[3] ~ "Single",
                      rn > props2[3] & rn < props2[4] ~ "Walk",
                      rn > props2[4] & rn < props2[5] ~ "Double",
                      rn > props2[5] & rn < props2[6] ~ "Home Run",
                      rn > props2[6] & rn < props2[7] ~ "Triple")

  if (print == "props") {
    print(props)
  }

  if (print == "result") {
    if (result == "Strikeout") {
      print(paste(bat, "struck out against", pit))
    }
    else if (result == "In Play, Out") {
      print(paste(bat, "hits into an out against", pit))
    }
    else if (result == "Walk") {
      print(paste(bat, "takes a walk against", pit))
    }
    else {
      print(paste(bat, "hits a", tolower(result), "against", pit))
    }

  }

  result

}


