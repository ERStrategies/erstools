library(erstools)
library(testthat)
library(tidyverse)
folder_path <- "Core Services/Strategy & Innovation/Data Management & Strategy/DO NOT MOVE OR EDIT - Test data for R Scripts/erstools"
drive_name = "internal_drive"
test_that("CSV file is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_csv_standard.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- read_sharepoint_ers(folder_path, file_name, drive_name = "internal_drive")

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_gt(nrow(result), 0)  # The file should have at least one row
})

test_that("CSV file with skipped rows is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_csv_skip_3_rows.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- read_sharepoint_ers(folder_path, file_name, skip_rows = 3, drive_name = "internal_drive")

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_equal(result$Enrollment[1], 100)  # The file should have at least one row
})

test_that("Excel file with multiple sheets is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_xlsx_multsheet_Sheet1.xlsx"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- read_sharepoint_ers(folder_path, file_name, sheet_name = "Sheet1", drive_name = "internal_drive")

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_equal(result$School[1], "A")  # The file should have at least one row
})

test_that("Error is raised when folder path does not exist", {
  # Define a non-existent folder path
  folder_path <- "Invalid/NonExistentFolder"

  # Expect an error when trying to read from a non-existent folder path
  expect_error(read_sharepoint_ers(folder_path, file_name = "test.csv", drive_name = "internal_drive"),
               regexp = "Folder path does not exist")
})

test_that("Error is raised when file does not exist in folder", {
  folder_path <- "Core Services/Strategy & Innovation/Data Management & Strategy/DO NOT MOVE OR EDIT - Test data for R Scripts/erstools"
  # Define an existing folder path but non-existent file name
  file_name <- "non_existent_file.csv"

  # Expect an error when trying to read a non-existent file
  expect_error(read_sharepoint_ers(folder_path, file_name, drive_name = "internal_drive"),
               regexp = "File .* does not exist in folder")
})

test_that("Error is raised when unsupported file format is provided", {
  # Define a valid folder path and file name with unsupported extension
  file_name <- "unsupported_file_format.txt"

  # Expect an error when trying to read a file with unsupported format
  expect_error(read_sharepoint_ers(folder_path, file_name, drive_name = "internal_drive"),
               "Unsupported file format, only xls, xlsx, or csv")
})

