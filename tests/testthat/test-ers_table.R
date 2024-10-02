library(erstools)
library(testthat)
library(tidyverse)
library(gt)
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
test_that("ers_table creates a gt table with correct formatting", {
  # Test data
  data <- diamonds %>% head()

  # Run the function
  table_output <- ers_table(data, "diamond stuff")

  # Test if the output is a gt table
  expect_s3_class(table_output, "gt_tbl")
})
