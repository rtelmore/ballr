GetNBAPlayerPerGameStats <- function(player_link) {
  ## Example player_link is of the form
  ## Player: Anthony Davis
  ## player_link <-
  player_url <- paste(default_base,
                      player_link,
                      sep = "")
  pg <- read_html(player_url)
  player_stats <- tbl_df(html_table(pg, fill = T)[[2]]) %>%
    filter(Age < max(Age, na.rm = T))
  return(player_stats)
}
