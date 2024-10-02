#' Read files from internal sharepoint folders
#'
#'
#' @param folder_path REQUIRED: The path to the file. Example: "District Partners/Yakima". Folder path must start with either "District Partners" or "Internal"
#' @param file_name_with_extension REQUIRED: File name. Example: "student_performance.csv"
#' @param drive_name OPTIONAL: By default it is set to "client_work_drive", if you want to access something from internal, then change to "internal_drive"
#' @param sheet_name OPTIONAL: Only required if you have an excel spreadsheet with multiple sheets. Example: "Sheet 2"
#' @param skip_rows OPTIONAL: Only required if your data doesn't start in the first row of the spreadsheet. Example: If your data starts in row 4 then enter 3
#' @param na_values OPTIONAL: By default will change all cells to NA if they have "", "N/A", "NA", or "Missing"
#' @return Your loaded data as a data frame with the name raw_data
#' @export
#' @import Microsoft365R
#' @import readxl
#' @import data.table
ers_read_sharepoint <- function(folder_path,
                                file_name_with_extension,
                                drive_name = "client_work_drive",
                                sheet_name = NULL,
                                skip_rows = 0,
                                na_values = c("","N/A","NA","Missing")) {

  #set sharepoint site URL for access to our org-wide and external files
  orgfiles_site_url <- "https://erstrategies1.sharepoint.com/sites/orgfiles"
  #access sharepoint site URL you may be prompted to sign in here
  orgfiles_site <- get_sharepoint_site(site_url = orgfiles_site_url)
  #see all folders in client work drive
  client_work_drive <- orgfiles_site$get_drive("Client Work")
  #see all folders in internal work drive
  internal_drive <- orgfiles_site$get_drive("Internal")

  # Determine which drive to use (client work by default)
  if (drive_name == "client_work_drive") {
    drive <- client_work_drive
  } else if (drive_name == "internal_drive") {
    drive <- internal_drive
  } else {
    stop("Invalid drive name. Use 'client_work_drive' or 'internal_drive'.")
  }

  # Check if the folder exists using get_item()
  folder_item <- try(drive$get_item(folder_path), silent = TRUE)
  if (inherits(folder_item, "try-error")) {
    stop("Folder path does not exist: '", folder_path, "'")
  }


  # Construct the full data path
  data_path <- file.path(folder_path, file_name_with_extension)

  # Check if the file exists using get_item()
  file_item <- try(drive$get_item(data_path), silent = TRUE)
  if (inherits(file_item, "try-error")) {
    stop("File '", file_name_with_extension, "' does not exist in folder: '", folder_path, "'")
  }

  file_extension <- paste0(".", tools::file_ext(file_name_with_extension))

  # Create a temporary file with the appropriate file extension
  temp_file <- tempfile(fileext = file_extension)

  # Download the file from the specified drive to the temporary file
  drive$download_file(data_path, dest = temp_file)

  # Read the downloaded file based on its file extension
  if (tools::file_ext(file_name_with_extension) == "csv") {
    raw_data <- fread(temp_file, skip = skip_rows, na.strings = na_values)
  } else if (tools::file_ext(file_name_with_extension) %in% c("xls", "xlsx")) {
    raw_data <- read_excel(temp_file, sheet = sheet_name, skip = skip_rows, na = na_values, guess_max = 5000)
  } else {
    stop("Unsupported file format, only xls, xlsx, or csv: '", file_name_with_extension, "'")
  }



  # Return the loaded data
  return(raw_data)
}

