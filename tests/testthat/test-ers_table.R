# library(erstools)
library(testthat)
library(dplyr)
library(gt)

test_that("ers_table creates a gt table with correct formatting", {
  # Test data
  data <- diamonds %>% head()

  # Run the function
  table_output <- ers_table(data, "diamond stuff")

  # Test if the output is a gt table
  expect_s3_class(table_output, "gt_tbl")
})
