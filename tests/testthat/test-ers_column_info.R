# Load required packages for testing
library(testthat)
library(dplyr)
library(skimr)

test_that("ers_column_info runs skimr::skim() correctly", {
  # Create a simple dataset
  test_data <- tibble(
    category = c("A", "B", "C"),
    value = c(10.1, 20.2, 30.3)  # Numeric column
  )

  # Apply the function
  result <- ers_column_info(test_data)

  # Ensure the result is a tibble
  expect_s3_class(result, "tbl")

  # Check that the expected skim summary columns exist
  expect_true("skim_variable" %in% colnames(result))
  expect_true("n_missing" %in% colnames(result))
  expect_true("numeric.mean" %in% colnames(result))  # Ensures numeric summary stats exist

  # Ensure there is a row for each column in the original dataset
  expect_equal(nrow(result), ncol(test_data))
})
