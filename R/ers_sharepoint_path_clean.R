#' Clean beginning path and %20s in sharepoint file names for ers_read_sharepoint and ers_write_sharpoint
#'
#'
#' @param full_path REQUIRED: The path to the file. This can be pasted directly from SharePoint: https://app.tettra.co/teams/ersknowledge/pages/copying-a-folder-path-from-sharepoint-to-use-in-r
#' @return Your cleaned sharepoint path and the sharepoint drive name
#' @export
#' @import dplyr
ers_sharepoint_path_clean <- function(full_path) {
  drive_name <- case_when(
    grepl("/orgfiles/Shared%20Documents/", full_path) ~ "internal_drive",
    grepl("/orgfiles/Client%20Work/", full_path) ~ "client_work_drive",
    grepl("/external/Shared%20Documents/", full_path) ~ "external_drive",
    grepl("/ers-data/Shared%20Documents/", full_path) ~ "data_hub_drive",
    TRUE ~ "client_work_drive" # Fallback for paths that don't match any pattern
  )
  pattern <- "(.*\\/orgfiles\\/Shared%20Documents\\/|.*\\/orgfiles\\/Client%20Work\\/|.*\\/external\\/Shared%20Documents\\/|.*\\/ers-data\\/Shared%20Documents\\/)"
  path_first_part_removed <- sub(pattern, "", full_path)
  path_clean <- gsub("%20", " ", path_first_part_removed)
  path_clean <- gsub("\\/$", "", path_clean)
  return(list(path_clean = path_clean, drive_name = drive_name))
}
