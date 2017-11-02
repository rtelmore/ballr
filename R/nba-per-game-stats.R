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
#' players <- NBAPerGameStatistics(season = 2015)
#' players
#'
#' players %>%
#'   dplyr::filter(MP > 20, Pos %in% c("SF")) %>%
#'   dplyr::select(Player, link) %>%
#'   dplyr::distinct()
#'
#' @export
NBAPerGameStatistics <- function(season = 2016) {
  nba_url <- paste(getOption("NBA_api_base"),
                   "/leagues/NBA_",
                   season,
                   "_per_game.html",
                   sep = "")
  pg <- xml2::read_html(nba_url)

  nba_stats <- dplyr::tbl_df(rvest::html_table(pg, fill = T)[[1]])
  nba_stats <- dplyr::rename(nba_stats,
                             `FGP` = .data$`FG%`, 
                             `3PP` = .data$`3P%`,
                             `2PP` = .data$`2P%`,
                             `eFG` = .data$`eFG%`,
                             `FTP` = .data$`FT%`)

  nba_stats <- dplyr::filter(nba_stats, .data$Player != "Player")
  links <- pg %>%
    rvest::html_nodes("tr.full_table") %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
  link_names <- pg %>%
    rvest::html_nodes("tr.full_table") %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()
  links_df <- dplyr::data_frame(Player = as.character(link_names),
                            link       = as.character(links))
  links_df[] <- lapply(links_df, as.character)
  nba_stats <- dplyr::left_join(nba_stats, links_df, by = "Player")
  nba_stats <- dplyr::mutate_at(nba_stats, 
                                dplyr::vars(.data$Rk, .data$Age, .data$G:.data$`PS/G`),
                                dplyr::funs(as.numeric))

  return(nba_stats)
}
