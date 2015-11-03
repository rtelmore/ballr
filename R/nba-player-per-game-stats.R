GetNBAPlayerPerGameStats <- function(player) {
  player_url <- paste(default_base,
                      player[, 2],
                      sep = "")
  pg <- read_html(player_url)
  player_stats <- tbl_df(html_table(pg, fill = T)[[2]]) %>%
    filter(Age < max(Age, na.rm = T)) %>%
    mutate(Player = player$Player)
  return(player_stats)
}
