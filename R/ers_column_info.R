#' Use the skim function to validate your data and output a summary of your columns
#'
#' This function applies `skimr::skim()` to summarize a dataset and then formats numeric columns.
#' Numeric values are rounded to one decimal place. If a number is 1,000 or greater, it is formatted with commas.
#'
#' @param dataset A data frame or tibble to be summarized.
#'
#' @return A tibble with summary statistics, where numeric values are rounded to one decimal place
#'         and large numbers (≥ 1,000) are formatted with commas.
#'
#' @import dplyr
#' @import skimr
#' @import scales
#'
#' @export
ers_column_info <- function(dataset) {
  skimr::skim(dataset) %>%
    dplyr::mutate(across(
      where(is.numeric),
      ~ ifelse(.x >= 1000, scales::comma(round(.x, 2)), round(.x, 2))
    ))
}
