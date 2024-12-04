#' Output your data as a nicely formatted table using the gt package
#'
#'
#' @param dataset REQUIRED: The data that you want to make into a table
#' @param title REQUIRED: Desired title of your data table. Example: "Teacher FTE by School"
#' @return Your data as a nicely formatted table
#' @export
#' @import dplyr
#' @import gt
ers_table <- function(dataset, title) {
dataset %>%
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
