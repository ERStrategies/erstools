Guidance on adding a function

1.  Create a new r file: Write the function (with Roxygen style
    documentation)

2.  Once you are done with the function go to the “Build” tab in the top
    right and click “Document” or use Ctrl+Shift+D That will create a
    .Rd file with documentation that users can access using
    ?function_name. If you don’t have the “Build” tab, then click on
    “Build” in the top lift and go to “Configure Build Tools”

3.  Check the package using the “Check” button in the top right under
    “Build” or Ctrl + Shift + E

4.  Build a binary package using the “More” button in the top right
    under “Build” Commit and push all changes to GitHub using the “Git”
    tab.

How to set a token:

1.  Run the following in R to open the .Renviron file (this stores
    environment variables): usethis::edit_r_environ()
2.  Add the following line to the file (replacing your_github_token with
    their token): GITHUB_PAT=your_github_token
3.  Save the file and restart the R session. Now R will automatically
    use the token for GitHub authentication.
