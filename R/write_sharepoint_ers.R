#' Write files to internal sharepoint folders
#'
#'
#' @param data REQUIRED: The data frame to be uploaded
#' @param folder_path REQUIRED: The folder where you want the data to be saved. Example: "District Partners/Yakima". Folder path must start with either "District Partners" or "Internal"
#' @param file_name_with_extension REQUIRED: File name. Example: "student_performance.csv"
#' @param drive_name OPTIONAL: By default it is set to client work, if you want to access something from internal, then change to internal_drive
#' @return A message that your file was successfully uploaded.
#' @export
#' @import Microsoft365R
#' @import openxlsx
#' @import data.table
write_sharepoint_ers <- function(data,
                                 folder_path,
                                 file_name_with_extension,
                                 drive_name = client_work_drive) {
  #set sharepoint site URL for access to our org-wide and external files
  orgfiles_site_url <- "https://erstrategies1.sharepoint.com/sites/orgfiles"
  #access sharepoint site URL you may be prompted to sign in here
  orgfiles_site <- get_sharepoint_site(site_url = orgfiles_site_url)

  #see all folders in client work drive
  client_work_drive <- orgfiles_site$get_drive("Client Work")
  #see all folders in internal work drive
  internal_drive <- orgfiles_site$get_drive("Internal")
  # Construct the full data path
  file_extension <- ifelse(tools::file_ext(file_name_with_extension) == "csv", ".csv", ".xlsx")
  data_path <- file.path(folder_path, file_name_with_extension)

  # Create a temporary file to store the data
  temp_file <- tempfile(fileext = file_extension)

  # Write the data to the temporary file based on the file type
  if (file_extension == ".csv") {
    fwrite(data, temp_file, row.names = FALSE, dateTimeAs = "write.csv")
  } else {
    write.xlsx(data, temp_file, rowNames = FALSE)
  }

  # Upload the file to the specified drive
  drive_name$upload_file(temp_file, dest = data_path)

  # Return the path of the uploaded file
  return(paste0("Uploaded ", file_name_with_extension, " to: '", folder_path, "'"))
}
