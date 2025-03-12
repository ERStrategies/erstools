#' Write files to sharepoint folders
#'
#'
#' @param data REQUIRED: The data frame, shape file, or ggplot object to be uploaded
#' @param folder_path REQUIRED: The folder where you want the data to be saved: https://app.tettra.co/teams/ersknowledge/pages/copying-a-folder-path-from-sharepoint-to-use-in-r
#' @param file_name_with_extension REQUIRED: Supported extensions: .csv, .xlsx, .png(ggsave). Example: "student_performance.csv"
#' @param drive_name OPTIONAL: R will detect what drive the file is from (e.g. 'client_work_drive', or 'internal_drive')
#' @return A message that your file was successfully uploaded.
#' @export
#' @import Microsoft365R
#' @import writexl
#' @importFrom data.table fwrite
#' @importFrom sf st_write
#' @importFrom ggplot2 ggsave
#' @import dplyr
ers_write_sharepoint <- function(data,
                                 folder_path,
                                 file_name_with_extension,
                                 drive_name = "client_work_drive") {

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
  # Check if the folder exists using get_item()
  folder_item <- try(drive$get_item(folder_path), silent = TRUE)
  if (inherits(folder_item, "try-error")) {
    stop("Folder path does not exist: '", folder_path, "'")
  }

    # Construct the full data path
  file_extension <- tools::file_ext(file_name_with_extension)
  data_path <- file.path(folder_path, file_name_with_extension)

  # Create a temporary file to store the data
  temp_file <- tempfile(fileext = paste0(".", file_extension))

  # Write the data to the temporary file based on the file type
  if (file_extension == "csv") {
    fwrite(data, temp_file, row.names = FALSE, dateTimeAs = "write.csv")
  } else if (file_extension == "xlsx") {
    writexl::write_xlsx(data, temp_file)
  } else if (file_extension == "png") {
    ggsave(temp_file, plot = data, device = "png")
  } else {
    stop("Unsupported file type: ", file_extension)
  }

  # Try to upload the file to the specified drive
  tryCatch(
    {
      drive$upload_file(temp_file, dest = data_path)
      message("Uploaded ", file_name_with_extension, " to: '", folder_path, "'")
    },
    error = function(e) {
      error_message <- conditionMessage(e)
      if (grepl("HTTP 423", error_message)) {
        stop("The file is currently open or locked on SharePoint. Close the file and try again.")
      } else if (grepl("HTTP 409", error_message)) {
        stop("A previous upload attempt failed, and the file is locked. Try renaming the file and re-uploading.")
      } else {
        stop("An unexpected error occurred during file upload: ", error_message)
      }
    }
  )
  # Return the path of the uploaded file
  return(paste0("Uploaded ", file_name_with_extension, " to: '", folder_path, "'"))
}
