#' NBA Player Statistics For a Given Season Per Game
#'
#' This function returns all player statistics on a per game basis
#' from an NBA season on basketball-reference.com.  See an example
#' table at:
#' http://www.basketball-reference.com/leagues/NBA_2015_per_game.html
#'
#' @param season A numeric year
#'
#' @return An object of class \code{\link[dplyr]{tbl_df}}
#'
#' @examples
#' NBAPerGameStatistics(season = 2015)
#' players <- NBAPerGameStatistics(season = 2015) %>%
#'   filter(MP > 20, Pos %in% c("SF")) %>%
#'   select(Player, link) %>%
#'   distinct()
#'
#' @export
NBAPerGameStatistics <- function(season = 2016) {
  nba_url <- paste(getOption("NBA_api_base"),
                   "/leagues/NBA_",
                   season,
                   "_per_game.html",
                   sep = "")
  pg <- read_xml::read_html(nba_url)

  nba_stats <- dplyr::tbl_df(rvest::html_table(pg, fill = T)[[1]])
  names(nba_stats)[c(11, 14, 17, 18, 21)] <- c("FGP",
                                               "3PP",
                                               "2PP",
                                               "eFGP",
                                               "FTP")
  nba_stats <- dplyr::filter(nba_stats, .data$Player != "Player")
  links <- pg %>%
    html_nodes("tr.full_table") %>%
    html_nodes("a") %>%
    html_attr("href")
  link_names <- pg %>%
    html_nodes("tr.full_table") %>%
    html_nodes("a") %>%
    html_text()
  links_df <- dplyr::data_frame(Player = as.character(link_names),
                            link       = as.character(links))
  links_df[] <- lapply(links_df, as.character)
  nba_stats <- dplyr::left_join(nba_stats, links_df, by = "Player")
  nba_stats <- dplyr::mutate_each(nba_stats, dplyr::funs(as.numeric), c(1, 4, 6:30))

  return(nba_stats)
}
