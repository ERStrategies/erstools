library(testthat)
library(dplyr)
folder_client_work_clean <- "District Partners/DSI_TESTING_ONLY"
folder_internal <- "https://erstrategies1.sharepoint.com/sites/orgfiles/Shared%20Documents/Core%20Services/Strategy%20&%20Innovation/Data%20Management%20&%20Strategy/DO%20NOT%20MOVE%20OR%20EDIT%20-%20Test%20data%20for%20R%20Scripts/erstools"
folder_client_work <- "https://erstrategies1.sharepoint.com/sites/orgfiles/Client%20Work/District%20Partners/DSI_TESTING_ONLY"
folder_external <- "https://erstrategies1.sharepoint.com/sites/external/Shared%20Documents/School%20System%20Partners/DSI_TESTING_ONLY"
folder_data_hub <- "https://erstrategies1.sharepoint.com/sites/ers-data/Shared%20Documents/District%20Data/Final%20Comp%20Data%20Tables/DSI_TESTING_ONLY"

# Create a sample data frame
sample_data <- data.frame(Enrollment = c(100, 200, 300), School = c("A", "B", "C"))

# Function to clean up test files after running tests
cleanup_sharepoint_files <- function(folder_path, file_name) {

  # Clean the folder path and extract the drive name from it if not explicitly provided
  cleaned <- ers_sharepoint_path_clean(folder_path)
  folder_path <- cleaned$path_clean  # Cleaned folder path for SharePoint
  drive_name <- cleaned$drive_name
  # Suppress messages while connecting to SharePoint sites
  orgfiles_site <- get_sharepoint_site(site_url = "https://erstrategies1.sharepoint.com/sites/orgfiles") %>% suppressMessages
  external_site <- get_sharepoint_site(site_url = "https://erstrategies1.sharepoint.com/sites/external") %>% suppressMessages
  data_hub_site <- get_sharepoint_site(site_url = "https://erstrategies1.sharepoint.com/sites/ers-data") %>% suppressMessages

  # Retrieve drives from each SharePoint site
  client_work_drive <- orgfiles_site$get_drive("Client Work")
  internal_drive <- orgfiles_site$get_drive("Internal")
  external_drive <- external_site$get_drive("Documents")
  data_hub_drive <- data_hub_site$get_drive("Documents")

  # Determine which drive to use based on the drive_name parameter
  if (drive_name == "client_work_drive") {
    drive <- client_work_drive
  }
  else if (drive_name == "internal_drive") {
    drive <- internal_drive
  }
  else if (drive_name == "external_drive") {
    drive <- external_drive
  }
  else if (drive_name == "data_hub_drive") {
    drive <- data_hub_drive
  }
  else {
    # If the drive_name is invalid, stop and raise an error
    stop("Invalid drive name. Use 'client_work_drive', 'internal_drive', 'external_drive', or 'data_hub_drive'.")
  }

  # Construct the full data path
  data_path <- file.path(folder_path, file_name)
  drive$delete_item(data_path, confirm = F)
}

test_that("NO CLEANING Client Work: CSV file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.csv"
  folder_path <- folder_client_work_clean
  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name)

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("Internal: CSV file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.csv"
  folder_path <- folder_internal
  folder_path_clean <- ers_sharepoint_path_clean(folder_path)[[1]]
  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name)

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path_clean, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("Client Work: CSV file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.csv"
  folder_path <- folder_client_work
  folder_path_clean <- ers_sharepoint_path_clean(folder_path)[[1]]
  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name)

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path_clean, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("External: CSV file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.csv"
  folder_path <- folder_external
  folder_path_clean <- ers_sharepoint_path_clean(folder_path)[[1]]
  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name)

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path_clean, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("Data Hub: CSV file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.csv"
  folder_path <- folder_data_hub
  folder_path_clean <- ers_sharepoint_path_clean(folder_path)[[1]]
  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name)

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path_clean, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("Excel file is uploaded successfully", {

  # Define file name
  file_name <- "test_enrollment_data.xlsx"
  folder_path <- folder_internal
  folder_path_clean <- ers_sharepoint_path_clean(folder_path)[[1]]
  # Run the function to write the data to SharePoint
  result <- ers_write_sharepoint(sample_data, folder_path, file_name)

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path_clean, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

test_that("Data integrity is maintained after upload", {

  # Define file name
  file_name <- "test_enrollment_data.csv"
  folder_path <- folder_internal
  # Write the data to SharePoint
  ers_write_sharepoint(sample_data, folder_path, file_name)

  # Read back the uploaded file
  uploaded_data <- ers_read_sharepoint(folder_path, file_name) %>% as.data.frame()
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

library(ggplot2)
library(sf)

test_that("Internal: PNG file is uploaded successfully", {

  # Define file name
  file_name <- "test_plot.png"
  folder_path <- folder_internal
  folder_path_clean <- ers_sharepoint_path_clean(folder_path)[[1]]

  # Create a simple ggplot and save it using ers_write_sharepoint
  sample_plot <- ggplot(sample_data, aes(x = School, y = Enrollment)) +
    geom_col()

  result <- ers_write_sharepoint(sample_plot, folder_path, file_name)

  # Check that the result confirms successful upload
  expect_equal(result, paste0("Uploaded ", file_name, " to: '", folder_path_clean, "'"))

  # Cleanup after the test
  cleanup_sharepoint_files(folder_path, file_name)
})

