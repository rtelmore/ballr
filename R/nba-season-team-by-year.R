#' NBA Team Statistics By Year
#'
#' This function returns a team's yearly statistics from basketball-reference.com
#'
#' @param team One of "ATL", "BOS", etc.
#' @param season The particular season you are querying
#' @return A team's game statistics for a particular season
#' @examples
#' NBASeasonTeamByYear("ATL", 2015)
#' NBASeasonTeamByYear("NOP", 2015)
#' @export
NBASeasonTeamByYear <- function(team, season){
  url <- paste(getOption("NBA_api_base"), "/teams/", team, "/", season,
               "_games.html", sep="")
  stats <- readHTMLTable(url)[['teams_games']][c(1, 2, 6:8, 10:14)]
  stats <- stats[-c(21, 42, 63, 84), ]
  stats[, c(1, 6:9)] <- apply(stats[, c(1, 6:9)], 2, as.numeric)
  colnames(stats)[3] <- "Away_Indicator"
  stats <- dplry::tbl_df(stats)
  stats <- dplry::mutate(stats,
                         Diff = Tm - Opp,
                         AvgDiff = cumsum(Diff)/G,
                         Away = cumsum(Away_Indicator == '@'),
                         DaysBetweenGames = c(NA, as.vector(diff(mdy(Date)))))
  return(stats)
}
