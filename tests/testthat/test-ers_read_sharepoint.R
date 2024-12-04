library(testthat)
library(dplyr)
folder_internal_clean <- "Core Services/Strategy & Innovation/Data Management & Strategy/DO NOT MOVE OR EDIT - Test data for R Scripts/erstools"
folder_internal <- "https://erstrategies1.sharepoint.com/sites/orgfiles/Shared%20Documents/Core%20Services/Strategy%20&%20Innovation/Data%20Management%20&%20Strategy/DO%20NOT%20MOVE%20OR%20EDIT%20-%20Test%20data%20for%20R%20Scripts/erstools"
folder_client_work <- "https://erstrategies1.sharepoint.com/sites/orgfiles/Client%20Work/District%20Partners/DSI_TESTING_ONLY"
folder_external <- "https://erstrategies1.sharepoint.com/sites/external/Shared%20Documents/School%20System%20Partners/DSI_TESTING_ONLY"
folder_data_hub <- "https://erstrategies1.sharepoint.com/sites/ers-data/Shared%20Documents/District%20Data/Final%20Comp%20Data%20Tables/DSI_TESTING_ONLY"

#NORMAL READ DRIVES CHECK

test_that("Internal Drive: CSV file is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_csv_standard.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- ers_read_sharepoint(folder_internal, file_name)

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_gt(nrow(result), 0)  # The file should have at least one row
})

test_that("Client Work Drive: CSV file is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_csv_standard.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- ers_read_sharepoint(folder_client_work, file_name)

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_gt(nrow(result), 0)  # The file should have at least one row
})

test_that("External Drive: CSV file is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_csv_standard.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- ers_read_sharepoint(folder_external, file_name)

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_gt(nrow(result), 0)  # The file should have at least one row
})

test_that("Data Hub Drive: CSV file is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_csv_standard.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- ers_read_sharepoint(folder_data_hub, file_name)

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_gt(nrow(result), 0)  # The file should have at least one row
})


#CLEANING CHECK


test_that("CSV file is downloaded from SharePoint with cleaning already done", {
  # Test file name
  file_name <- "dummy_file_csv_standard.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- ers_read_sharepoint(folder_internal_clean, file_name, drive_name = "internal_drive")

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_gt(nrow(result), 0)  # The file should have at least one row
})

#WEIRD SCENARIOS


test_that("CSV file with skipped rows is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_csv_skip_3_rows.csv"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- ers_read_sharepoint(folder_internal, file_name, skip_rows = 3)

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_equal(result$Enrollment[1], 100)  # The file should have at least one row
})

test_that("Excel file with multiple sheets is downloaded from SharePoint", {
  # Test file name
  file_name <- "dummy_file_xlsx_multsheet_Sheet1.xlsx"  # Ensure this file exists in your test folder on SharePoint
  # Run the function to download and read the file
  result <- ers_read_sharepoint(folder_internal, file_name, sheet_name = "Sheet1")

  # Check that the result is a data frame (i.e., file has been read successfully)
  expect_true(is.data.frame(result))

  # Optionally, check the file's contents to ensure it's not empty
  expect_equal(result$School[1], "A")  # The file should have at least one row
})

test_that("Error is raised when folder path does not exist", {
  # Define a non-existent folder path
  folder_path <- "Invalid/NonExistentFolder"

  # Expect an error when trying to read from a non-existent folder path
  expect_error(ers_read_sharepoint(folder_path, file_name = "test.csv"),
               regexp = "Folder path does not exist")
})

test_that("Error is raised when file does not exist in folder", {
  # Define an existing folder path but non-existent file name
  file_name <- "non_existent_file.csv"

  # Expect an error when trying to read a non-existent file
  expect_error(ers_read_sharepoint(folder_internal, file_name),
               regexp = "File .* does not exist in folder")
})

test_that("Error is raised when unsupported file format is provided", {
  # Define a valid folder path and file name with unsupported extension
  file_name <- "unsupported_file_format.txt"

  # Expect an error when trying to read a file with unsupported format
  expect_error(ers_read_sharepoint(folder_internal, file_name),
               regexp = "Unsupported file format. Supported formats are xls, xlsx, or csv: .*")
})

