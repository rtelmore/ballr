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
  pg <- xml2::read_html(url)
  nba_stats <- rvest::html_table(pg, fill = T)[[1]] %>%
    janitor::clean_names()
  nba_stats <- nba_stats[-c(21, 42, 63, 84), ] %>%
    dplyr::mutate(g = as.numeric(g),
                  tm = as.numeric(tm),
                  opp = as.numeric(opp),
                  w = as.numeric(w),
                  l = as.numeric(l))

  colnames(nba_stats)[6] <- "away_indicator"
  nba_stats <- dplyr::tbl_df(nba_stats) %>%
    dplyr::mutate(diff             = .data$tm - .data$opp,
                  avg_diff          = cumsum(.data$diff) / .data$g,
                  away             = cumsum(.data$away_indicator == '@'),
                  daysbetweengames = c(NA, as.vector(diff(lubridate::mdy(.data$date)))))
  return(nba_stats)
}
