#' NBA Player Career Statistics
#'
#' This function gets a player's career stats from basketball-reference.com
#'
#' @param player_link A link suffix, e.g. "/players/d/davisan02.html"
#' @return An object of class tbl_df
#' @examples
#' GetNBAPlayerPerGameStats("/players/d/davisan02.html") # Anthony Davis
#' GetNBAPlayerPerGameStats("/players/j/jamesle01.html") # Lebron James

GetNBAPlayerPerGameStats <- function(player_link) {
  player_url <- paste(getOption("NBA_api_base"),
                      player_link,
                      sep = "")
  pg <- read_html(player_url)
  player_stats <- tbl_df(html_table(pg, fill = T)[[2]])
  return(player_stats)
}
