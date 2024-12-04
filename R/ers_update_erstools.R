#' Update the erstools package
#'
#'
#' @param pkg_name OPTIONAL: The private github package you want to install. Currently only supports erstools.
#' @param upgrade OPTIONAL: By default it installs all other necessary packages. It will give warnings if some of them failed.
#' @return Nothing. Your package will be installed
#' @export
#' @import devtools
#' @import utils
ers_update_erstools <- function(pkg_name = "erstools", upgrade = "always") {
  # Check if the package is already loaded
  if (pkg_name %in% loadedNamespaces()) {
    message("Package is loaded. Detaching package before updating...")

    # Detach the package
    tryCatch({
      detach(paste0("package:", pkg_name), unload = TRUE, character.only = TRUE)
      message("Package detached.")
    }, error = function(e) {
      message("Error while detaching: ", e$message)
    })
  }

  # Remove the package completely if it is installed
  if (pkg_name %in% installed.packages()) {
    tryCatch({
      remove.packages(pkg_name)
      message("Package successfully removed.")
    }, error = function(e) {
      message("Error during removal: ", e$message)
    })
  }

  # Attempt to install/update the package from GitHub
  tryCatch({
    devtools::install_github("ERStrategies/erstools", auth_token = Sys.getenv("GITHUB_PAT"), force = TRUE, upgrade = upgrade)
    message("Package successfully installed/updated.")
  }, error = function(e) {
    message("Error during installation: ", e$message)
  })
}
