#' Output your data as a nicely formatted table using the gt package
#'
#' This function creates a formatted table from your data. Tables are limited
#' to a maximum of 50 rows. If the input dataset has more than 50 rows, only
#' the first 50 rows will be displayed and a message will be shown.
#'
#' @param dataset REQUIRED: The data that you want to make into a table
#' @param title REQUIRED: Desired title of your data table. Example: "Teacher FTE by School"
#' @return Your data as a nicely formatted table (limited to 50 rows)
#' @export
#' @import dplyr
#' @import gt
ers_table <- function(dataset, title = "Default Title") {
  # Check number of rows
  n_rows <- nrow(dataset)
  
  # Display message if dataset has more than 50 rows
  if (n_rows > 50) {
    message(sprintf("Note: The dataset has %d rows. Only the first 50 rows will be displayed in the table.", n_rows))
    dataset <- dataset %>% slice_head(n = 50)
  }
  
  dataset %>%
    ungroup %>%
    gt() %>%
    tab_header(title) %>%
    opt_stylize(style = 3) %>%
    tab_style(style = cell_text(align = "left",
                                weight = "bold",
                                size = "x-large"),
              locations = cells_title("title")) %>%
    tab_style(style = cell_text(weight = "bold"),
              locations = cells_column_labels())
}
