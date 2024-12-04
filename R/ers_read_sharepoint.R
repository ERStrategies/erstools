#' Read files from internal sharepoint folders
#'
#'
#' @param folder_path REQUIRED: The path to the file: https://app.tettra.co/teams/ersknowledge/pages/copying-a-folder-path-from-sharepoint-to-use-in-r
#' @param file_name_with_extension REQUIRED: File name. Example: "student_performance.csv"
#' @param sheet_name OPTIONAL: Only required if you have an excel spreadsheet with multiple sheets. Example: "Sheet 2"
#' @param drive_name OPTIONAL: R will detect what drive the file is from (e.g. 'client_work_drive', 'internal_drive', 'external_drive', or 'data_hub_drive')
#' @param skip_rows OPTIONAL: Only required if your data doesn't start in the first row of the spreadsheet. Example: If your data starts in row 4 then enter 3
#' @param na_values OPTIONAL: By default will change all cells to NA if they have "", "N/A", "NA", or "Missing"
#' @return Your loaded data as a data frame with the name raw_data
#' @export
#' @import Microsoft365R
#' @import readxl
#' @importFrom data.table fread
#' @import dplyr
ers_read_sharepoint <- function(folder_path,
                                file_name_with_extension,
                                sheet_name = NULL,
                                drive_name = "client_work_drive",
                                skip_rows = 0,
                                na_values = c("", "N/A", "NA", "Missing"))
{
  # Replace '%20' in the file name with spaces to clean the file name
  file_name_with_extension <- gsub("%20", " ", file_name_with_extension)

  # Clean the folder path and extract the drive name from it if not explicitly provided
  cleaned <- erstools::ers_sharepoint_path_clean(folder_path)
  folder_path <- cleaned$path_clean  # Cleaned folder path for SharePoint

  # If drive_name is not explicitly provided, use the drive_name extracted from the folder path
  if (missing(drive_name)) {
    drive_name <- cleaned$drive_name
  }

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

  # Try to get the folder item from the drive
  folder_item <- try(drive$get_item(folder_path), silent = TRUE)
  if (inherits(folder_item, "try-error")) {
    # Stop execution if the folder path does not exist
    stop("Folder path does not exist: '", folder_path, "'")
  }

  # Construct the full path to the data file within the folder
  data_path <- file.path(folder_path, file_name_with_extension)

  # Try to get the file item from the drive
  file_item <- try(drive$get_item(data_path), silent = TRUE)
  if (inherits(file_item, "try-error")) {
    # Stop execution if the file does not exist
    stop("File '", file_name_with_extension, "' does not exist in folder: '",
         folder_path, "'")
  }

  # Determine the file extension of the target file
  file_extension <- paste0(".", tools::file_ext(file_name_with_extension))

  # Create a temporary file with the appropriate extension for downloading
  temp_file <- tempfile(fileext = file_extension)

  # Download the file from SharePoint to the temporary file
  drive$download_file(data_path, dest = temp_file)

  # Read the file based on its extension
  if (tools::file_ext(file_name_with_extension) == "csv") {
    # For CSV files, use `fread` with specified skip and NA values
    raw_data <- fread(temp_file, skip = skip_rows, na.strings = na_values)
  }
  else if (tools::file_ext(file_name_with_extension) %in% c("xls", "xlsx")) {
    # For Excel files, use `read_excel` with the specified sheet name, skip rows, and NA values
    raw_data <- read_excel(temp_file, sheet = sheet_name,
                           skip = skip_rows, na = na_values, guess_max = 5000)
  }
  else {
    # Stop execution for unsupported file formats
    stop("Unsupported file format. Supported formats are xls, xlsx, or csv: '",
         file_name_with_extension, "'")
  }

  # Return the loaded data
  return(raw_data)
}
