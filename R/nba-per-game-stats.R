# Get NBA Per Game Statistics
#

GetNBAPerGameStatistics <- function(season = 2016) {
  nba_url <- paste(default_base,
                   "leagues/NBA_",
                   season,
                   "_per_game.html",
                   sep = "")
  pg <- read_html(nba_url)

  nba_stats <- tbl_df(html_table(pg)[[1]])
  names(nba_stats)[c(14, 17)] <- c("3PP", "2PP")
  nba_stats <- filter(nba_stats,
                      Player != "Player")
  return(nba_stats)
}
