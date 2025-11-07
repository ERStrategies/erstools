library(testthat)
library(dplyr)
library(gt)

test_that("ers_table creates a gt table with correct formatting", {
  # Test data
  data <- ggplot2::diamonds %>% head()

  # Run the function
  table_output <- ers_table(data, "diamond stuff")

  # Test if the output is a gt table
  expect_s3_class(table_output, "gt_tbl")
})

test_that("ers_table errors if more than 50 rows", {
  data <- ggplot2::diamonds %>% head(51)
  expect_error(
    ers_table(data, "Too many rows"),
    "ers_table only supports tables with 50 rows or fewer"
  )
})
