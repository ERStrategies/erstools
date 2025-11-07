#' Create a new ERS R Markdown file from a template
#'
#' @param file_name The name of the new Rmd file to create (e.g., "my_report"). You do not need to include the .Rmd extension.
#' @param include_walkthrough If TRUE or "yes", use the walkthrough template; otherwise, use the standard template
#' @return Creates a new Rmd file in your working directory
#' @export
ers_template <- function(file_name, include_walkthrough = FALSE) {
  # Decide whether to use the walkthrough template
  use_walkthrough <- isTRUE(include_walkthrough) ||
    identical(include_walkthrough, "yes")

  # Choose the template name based on the user's choice
  if (use_walkthrough) {
    template_to_use <- "erstools_walkthrough"
  } else {
    template_to_use <- "ERS_RMarkdown_Template"
  }

  # Create the new R Markdown file using the chosen template
  rmarkdown::draft(
    file = file_name,
    template = template_to_use,
    package = "erstools"
  )
}
