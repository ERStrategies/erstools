# Read files from sharepoint

Read files from sharepoint

## Usage

``` r
ers_read_sharepoint(
  folder_path,
  file_name_with_extension,
  sheet_name = NULL,
  drive_name = "client_work_drive",
  skip_rows = 0,
  na_values = c(""),
  clean_names = "FALSE"
)
```

## Arguments

- folder_path:

  REQUIRED: The path to the file:
  https://app.tettra.co/teams/ersknowledge/pages/copying-a-folder-path-from-sharepoint-to-use-in-r

- file_name_with_extension:

  REQUIRED: Supported extensions: .csv, .xls, .xlsx, .shp Example:
  "student_performance.csv"

- sheet_name:

  OPTIONAL: Only required if you have an excel spreadsheet with multiple
  sheets. Example: "Sheet 2"

- drive_name:

  OPTIONAL: R will detect what drive the file is from (e.g.
  'client_work_drive', 'internal_drive', 'external_drive', or
  'data_hub_drive')

- skip_rows:

  OPTIONAL: Only required if your data doesn't start in the first row of
  the spreadsheet. Example: If your data starts in row 4 then enter 3

- na_values:

  OPTIONAL: By default will change all cells to NA if they have "",
  "N/A", "NA", or "Missing"

- clean_names:

  OPTIONAL: standardizes column names by removing special characters,
  converting to snake_case, and ensuring uniqueness

## Value

Your loaded data as a data frame with the name raw_data
