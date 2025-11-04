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

test_that("ers_table handles tables with 50 or fewer rows without message", {
  # Test data with exactly 50 rows
  data_50 <- ggplot2::diamonds %>% head(50)
  
  # Run the function - should not produce a message
  expect_silent(ers_table(data_50, "50 rows test"))
  
  # Test data with fewer than 50 rows
  data_30 <- ggplot2::diamonds %>% head(30)
  
  # Run the function - should not produce a message
  expect_silent(ers_table(data_30, "30 rows test"))
})

test_that("ers_table limits tables to 50 rows and displays message", {
  # Test data with more than 50 rows
  data_100 <- ggplot2::diamonds %>% head(100)
  
  # Run the function and capture the message
  expect_message(
    table_output <- ers_table(data_100, "100 rows test"),
    "Note: The dataset has 100 rows. Only the first 50 rows will be displayed in the table."
  )
  
  # Verify output is still a gt table
  expect_s3_class(table_output, "gt_tbl")
  
  # Verify that the table contains only 50 rows
  # Extract the data from gt object
  table_data <- table_output[["_data"]]
  expect_equal(nrow(table_data), 50)
})

test_that("ers_table correctly limits data to first 50 rows", {
  # Create test data with identifiable rows
  data_75 <- ggplot2::diamonds %>% head(75)
  
  # Run the function with message expected
  expect_message(
    table_output <- ers_table(data_75, "75 rows test")
  )
  
  # Extract the table data
  table_data <- table_output[["_data"]]
  
  # Verify it has exactly 50 rows
  expect_equal(nrow(table_data), 50)
  
  # Verify it's the first 50 rows by comparing to the original
  expected_data <- ggplot2::diamonds %>% head(50)
  expect_equal(table_data, expected_data)
})
