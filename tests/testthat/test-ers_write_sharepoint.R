library(erstools)
library(testthat)
folder_path <- "Core Services/Strategy & Innovation/Data Management & Strategy/DO NOT MOVE OR EDIT - Test data for R Scripts/erstools"
# Create a sample data frame
sample_data <- data.frame(Enrollment = c(100, 200, 300), School = c("A", "B", "C"))
# Function to clean up test files after running tests
cleanup_sharepoint_files <- function(folder_path, file_name) {
  orgfiles_site_url <- "https://erstrategies1.sharepoint.com/sites/orgfiles"
  orgfiles_site <- get_sharepoint_site(site_url = orgfiles_site_url)
  internal_drive <- orgfiles_site$get_drive("Internal")

  # Construct the full data path
  data_path <- file.path(folder_path, file_name)
  internal_drive$delete_item(data_path)
}

test_that("CSV file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.csv"

  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name, drive_name = "internal_drive")

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("Excel file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.xlsx"

  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name, drive_name = "internal_drive")

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("Data integrity is maintained after upload", {

  # Define file name
  file_name <- "test_enrollment_data.csv"

  # Write the data to SharePoint
  ers_write_sharepoint(sample_data, folder_path, file_name, drive_name = "internal_drive")

  # Read back the uploaded file
  uploaded_data <- ers_read_sharepoint(folder_path, file_name, drive_name = "internal_drive") %>% as.data.frame()
  # Print structure for debugging
  print(str(uploaded_data))
  print(str(sample_data))

  # Check that the original data matches the uploaded data
  expect_equal(uploaded_data, sample_data)
})

test_that("Error is raised when folder path does not exist", {
  # Define a non-existent folder path
  folder_path <- "Invalid/NonExistentFolder"

  # Expect an error when trying to write to a non-existent folder path
  expect_error(ers_write_sharepoint(sample_data, folder_path, file_name = "test.csv", drive_name = "internal_drive"),
               "Folder path does not exist")
})


