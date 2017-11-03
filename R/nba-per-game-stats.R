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
#' library(magrittr)
#'
#' players <- NBAPerGameStatistics(season = 2018)
#' players
#'
#' players %>%
#'   dplyr::filter(MP > 20, Pos %in% c("SF")) %>%
#'   dplyr::select(Player, link) %>%
#'   dplyr::distinct()
#'
#' @export
NBAPerGameStatistics <- function(season = 2018) {
  nba_url <- paste(getOption("NBA_api_base"),
                   "/leagues/NBA_",
                   season,
                   "_per_game.html",
                   sep = "")
  pg <- xml2::read_html(nba_url)

  nba_stats <- dplyr::tbl_df(rvest::html_table(pg, fill = T)[[1]]) %>%
    janitor::clean_names() %>%
    dplyr::filter(.data$player != "Player")

  links <- pg %>%
    rvest::html_nodes("tr.full_table") %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
  link_names <- pg %>%
    rvest::html_nodes("tr.full_table") %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()
  links_df <- dplyr::data_frame(player = as.character(link_names),
                            link       = as.character(links))
  links_df[] <- lapply(links_df, as.character)
  nba_stats <- dplyr::left_join(nba_stats, links_df, by = "player")
  nba_stats <- dplyr::mutate_at(nba_stats,
                                dplyr::vars(-.data$player, -.data$pos, -.data$tm, -.data$link),
                                dplyr::funs(as.numeric))

  return(nba_stats)
}
