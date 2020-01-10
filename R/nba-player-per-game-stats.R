#' NBA Player Career Statistics
#'
#' This function gets a player's career stats from basketball-reference.com
#'
#' @param player_link A link suffix, e.g. "/players/d/davisan02.html"
#' @return An object of class tbl_df
#' @examples
#' \dontrun{
#' NBAPlayerPerGameStats("/players/d/davisan02.html") # Anthony Davis
#' NBAPlayerPerGameStats("/players/j/jamesle01.html") # Lebron James
#' }
#' @export
NBAPlayerPerGameStats <- function(player_link) {
  player_url <- paste(getOption("NBA_api_base"),
                      player_link,
                      sep = "")
  pg <- xml2::read_html(player_url)
  tmp <- rvest::html_table(pg, fill = T)
  ifelse(ncol(tmp[[1]]) == 21,
         player_stats <- tmp[[2]],
         player_stats <- tmp[[1]])

  if (utils::packageVersion("janitor") > "0.3.1") {
    player_stats <- player_stats %>%
      janitor::clean_names(case = "old_janitor")
  } else {
    player_stats <- player_stats %>%
      janitor::clean_names() %>%
      janitor::remove_empty_cols()
  }

  player_stats <- player_stats[!grepl("Did Not Play", player_stats$g), ]

  return(player_stats)
}
