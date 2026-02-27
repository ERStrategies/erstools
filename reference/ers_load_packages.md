# Load Required Libraries and Categorize Output

This function loads a set of commonly used libraries, categorizes them,
suppresses unnecessary startup messages, and prints a summary of
successfully loaded libraries. If any packages are missing, a warning is
displayed at the bottom.

## Usage

``` r
ers_load_packages()
```

## Value

A categorized summary of loaded libraries and a warning message for
missing packages.

## Examples

``` r
ers_load_packages()
#> 
#>  **Missing Packages:**
#>  Package 'openxlsx' is missing. Install it using: install.packages('openxlsx')
#> Package 'googlesheets4' is missing. Install it using: install.packages('googlesheets4')
#> Package 'tidyverse' is missing. Install it using: install.packages('tidyverse')
#> Package 'safejoin' is missing. Install it using: install.packages('safejoin')
#> Package 'flextable' is missing. Install it using: install.packages('flextable')
#> Package 'extrafont' is missing. Install it using: install.packages('extrafont')
#> Package 'downloadthis' is missing. Install it using: install.packages('downloadthis') 
#> 
#>  Loaded Libraries:
#>  
#>  **Load Data**:
#> - Microsoft365R: Connects to SharePoint and loads files
#> - readxl: Reads Excel files
#> - writexl: Writes Excel files
#> 
#>  **Manipulate Data**:
#> - data.table: Fast CSV reading and data manipulation
#> - janitor: Cleans and formats column names
#> - stringr: String manipulation with regex support
#> - glue: String interpolation and templating
#> 
#>  **APIs & Web**:
#> - httr: Tools for working with URLs and HTTP
#> - jsonlite: Read and write JSON data
#> 
#>  **Format & Display Data**:
#> - scales: Formats numbers and axes in plots
#> - gt: Creates publication-ready tables
#> 
#>  **Share Output**:
#> - rmarkdown: Required for knitting RMarkdown files
#> 
#>  **Custom Tools**:
#> - erstools: Custom package with functions for SharePoint and table formatting 
```
