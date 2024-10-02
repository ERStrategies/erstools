library(erstools)
library(testthat)
library(tidyverse)
library(gt)
test_that("ers_column_info runs successfully", {
  # Test data
  table_output <- ers_column_info(diamonds)  # Call ers_column_info separately

  # Test if the output is a gt table
  expect_s3_class(table_output, "gt_tbl")
})
