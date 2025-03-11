#' Load Required Libraries and Categorize Output
#'
#' This function loads a set of commonly used libraries, categorizes them,
#' suppresses unnecessary startup messages, and prints a summary of successfully
#' loaded libraries. If any packages are missing, a warning is displayed at the bottom.
#'
#' @return A categorized summary of loaded libraries and a warning message for missing packages.
#' @export
#'
#' @examples
#' ers_load_packages()
ers_load_packages <- function() {
  # Categorized list of packages with descriptions
  libraries <- list(
    "Load Data" = list(
      "Microsoft365R" = "Connects to SharePoint and loads files",
      "readxl" = "Reads Excel files",
      "writexl" = "Writes Excel files",
      "openxlsx" = "Alternative package for writing Excel files",
      "googlesheets4" = "Reads and writes Google Sheets"
    ),
    "Manipulate Data" = list(
      "tidyverse" = "Collection of data manipulation and visualization packages",
      "data.table" = "Fast CSV reading and data manipulation",
      "janitor" = "Cleans and formats column names",
      "safejoin" = "Safer join operations for 1:many matching",
      "stringr" = "String manipulation with regex support"
    ),
    "Format & Display Data" = list(
      "scales" = "Formats numbers and axes in plots",
      "gt" = "Creates publication-ready tables",
      "flextable" = "Another option for creating formatted tables",
      "extrafont" = "Handles custom fonts for plots"
    ),
    "Share Output" = list(
      "rmarkdown" = "Required for knitting RMarkdown files",
      "downloadthis" = "Creates download buttons in knitted reports"
    ),
    "Custom Tools" = list(
      "erstools" = "Custom package with functions for SharePoint and table formatting"
    )
  )

  # Initialize storage for messages
  output_messages <- c()
  missing_packages <- c()

  # Load packages quietly and store messages
  for (category in names(libraries)) {
    category_messages <- c()

    for (pkg in names(libraries[[category]])) {
      if (!requireNamespace(pkg, quietly = TRUE)) {
        missing_packages <- c(missing_packages, sprintf("Package '%s' is missing. Install it using: install.packages('%s')", pkg, pkg))
      } else {
        suppressPackageStartupMessages(suppressMessages(library(pkg, character.only = TRUE)))
        category_messages <- c(category_messages, sprintf("- %s: %s", pkg, libraries[[category]][[pkg]]))
      }
    }

    if (length(category_messages) > 0) {
      output_messages <- c(output_messages, sprintf("\n **%s**:\n%s", category, paste(category_messages, collapse = "\n")))
    }
  }

  # Print categorized package loading summary
  cat("\n Loaded Libraries:\n", paste(output_messages, collapse = "\n"), "\n")

  # Print missing package warnings at the bottom
  if (length(missing_packages) > 0) {
    cat("\n **Missing Packages:**\n", paste(missing_packages, collapse = "\n"), "\n")
  }
}
