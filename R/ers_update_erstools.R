#' Update the erstools package
#'
#'
#' @param pkg_name OPTIONAL: The private github package you want to install. Currently only supports erstools.
#' @param upgrade OPTIONAL: By default it installs all other necessary packages. It will give warnings if some of them failed.
#' @return Nothing. Your package will be installed
#' @export
#' @importFrom devtools install_github
#' @importFrom utils installed.packages remove.packages
ers_update_erstools <- function(pkg_name = "erstools", upgrade = "always") {
  # Ensure namespace is unloaded
  if (pkg_name %in% loadedNamespaces()) {
    message("Package is loaded. Unloading package before updating...")
    tryCatch({
      unloadNamespace(pkg_name)
      message("Namespace unloaded.")
    }, error = function(e) {
      message("Error while unloading namespace: ", e$message)
    })
  }

  # Remove the package completely
  if (pkg_name %in% installed.packages()) {
    tryCatch({
      remove.packages(pkg_name, lib = .libPaths()[1])
      message("Package successfully removed.")
    }, error = function(e) {
      message("Error during removal: ", e$message)
    })
  }

  # Clear cached help database
  tryCatch({
    unlink(file.path(.libPaths()[1], pkg_name), recursive = TRUE, force = TRUE)
    message("Cached files cleared.")
  }, error = function(e) {
    message("Error clearing cached files: ", e$message)
  })

  # Install/update the package from GitHub
  tryCatch({
    devtools::install_github("ERStrategies/erstools",
                             auth_token = Sys.getenv("GITHUB_PAT"),
                             force = TRUE,
                             upgrade = upgrade)
    message("Package successfully installed/updated.")
  }, error = function(e) {
    message("Error during installation: ", e$message)
  })
}
