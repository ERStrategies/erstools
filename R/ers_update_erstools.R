#' Update the erstools package from GitHub
#'
#' Installs or updates the public erstools package from GitHub.
#' @return Invisibly returns TRUE if installation succeeds.
#' @export
ers_update_erstools <- function() {
  message("Installing/updating 'erstools' from GitHub...")
  tryCatch(
    {
      devtools::install_github("ERStrategies/erstools", upgrade = "always")
      message("'erstools' package installed/updated successfully.")
      invisible(TRUE)
    },
    error = function(e) {
      message("Failed to install/update 'erstools': ", e$message)
      invisible(FALSE)
    }
  )
}
