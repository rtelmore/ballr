#' NBA Team Statistics By Year
#'
#' This function returns a team's yearly statistics from basketball-reference.com
#'
#' @param team One of "ATL", "BOS", etc.
#' @param season The particular season you are querying
#' @return A team's game statistics for a particular season
#' @examples
#' NBASeasonTeamByYear("ATL", 2018)
#' NBASeasonTeamByYear("NOP", 2018)
#' @export
NBASeasonTeamByYear <- function(team, season){
  url <- paste(getOption("NBA_api_base"), "/teams/", team, "/", season,
               "_games.html", sep="")
  stats <- XML::readHTMLTable(url)[['teams_games']][c(1, 2, 6:8, 10:14)]
  stats <- stats[-c(21, 42, 63, 84), ]
  stats[, c(1, 6:9)] <- apply(stats[, c(1, 6:9)], 2, as.numeric)
  colnames(stats)[3] <- "Away_Indicator"
  stats <- dplyr::tbl_df(stats)
  stats <- dplyr::mutate(stats,
                         Diff             = .data$Tm - .data$Opp,
                         AvgDiff          = cumsum(.data$Diff) / .data$G,
                         Away             = cumsum(.data$Away_Indicator == '@'),
                         DaysBetweenGames = c(NA, as.vector(diff(lubridate::mdy(.data$Date)))))
  return(stats)
}
