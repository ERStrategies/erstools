#' Output your data as a nicely formatted table using the gt package
#'
#'
#' @param dataset REQUIRED: The data that you want to make into a table
#' @param title OPTIONAL: Title of the table in quotes. Default: "Data Column Summary"
#' @return Some basic validation checks on your data for all columns. Includes type, na and missing values, unique values, and more
#' @export
#' @import tidyverse
#' @import stats
ers_column_info <- function(dataset, title = "Data Column Summary")
{data.frame(
  Column_Name = names(dataset),
  Data_Type = sapply(dataset, class),
  Count_Rows = sapply(dataset, function(x) length(na.omit(x))),
  NA_Rows = sapply(dataset, function(x) sum(is.na(x))),
  Missing_Rows = sapply(dataset, function(x) sum(x == "", na.rm = T)),
  Unique_Rows = sapply(dataset, function(x) length(unique(na.omit(x)))),
  stringsAsFactors = FALSE,
  row.names= NULL) %>% ers_table(title = title)

}
