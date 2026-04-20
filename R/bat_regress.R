#' Regress a Hitter to the Mean
#'
#' This function is used within the sim_pa function to give appropriate data to players under the pa cutoff
#' @param player a hitter as a data frame
#' @param profiles profiles for each type of handedness
#' @param pa_cut plate appearance cut off
#' @import dplyr
#' @keywords baseball
#' @export
#' @examples
#' bat_regress(player, profiles = avg_profiles, pa_cut = 150)
#' bat_regress()

bat_regress <- function(player, profiles = avg_profiles, pa_cut = 150) {

  avg <- filter(profiles, bathand == player$bathand)
  pa <- player$bat_pa

  player_regress <- player |>
    mutate(bat_kpct = (bat_kpct*pa + avg$bat_kpct*(pa_cut - pa)) / pa_cut,
           bat_1Bpct = (bat_1Bpct*pa + avg$bat_1Bpct*(pa_cut - pa)) / pa_cut,
           bat_2Bpct = (bat_2Bpct*pa + avg$bat_2Bpct*(pa_cut - pa)) / pa_cut,
           bat_3Bpct = (bat_3Bpct*pa + avg$bat_3Bpct*(pa_cut - pa)) / pa_cut,
           bat_HRpct = (bat_HRpct*pa + avg$bat_HRpct*(pa_cut - pa)) / pa_cut,
           bat_ipoutpct = (bat_ipoutpct*pa + avg$bat_ipoutpct*(pa_cut - pa)) / pa_cut,
           bat_fbpct = (bat_fbpct*pa + avg$bat_fbpct*(pa_cut - pa)) / pa_cut)

  player_regress
}
