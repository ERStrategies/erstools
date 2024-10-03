# Load testthat
library(testthat)
library(erstools)
# Define a test for the update_github_package function
test_that("update_github_package works when the package is already loaded", {

  pkg_name <- "erstools"  # Set the package name

  # Step 2: Run the function to update the package and load it
  ers_update_erstools(pkg_name)
  # Step 3: Check if the package was successfully reloaded
  expect_true(pkg_name %in% loadedNamespaces())
})

# Check that the documentation for a function in erstools loads properly
test_that("ers_read_sharepoint documentation loads properly", {

  # Attempt to load the help file for ers_read_sharepoint
  help_file <- utils::help("ers_read_sharepoint", package = "erstools")

  # Ensure that the help file is not NULL
  expect_true(!is.null(help_file), info = "Help file not found for ers_read_sharepoint")

  # Ensure that the help file is of the correct class (it should be 'help_files_with_topic')
  expect_true(inherits(help_file, "help_files_with_topic"), info = "Help file is not of the expected class")

})
