# Write files to sharepoint folders

Write files to sharepoint folders

## Usage

``` r
ers_write_sharepoint(
  data,
  folder_path,
  file_name_with_extension,
  drive_name = "client_work_drive"
)
```

## Arguments

- data:

  REQUIRED: The data frame, shape file, or ggplot object to be uploaded

- folder_path:

  REQUIRED: The folder where you want the data to be saved:
  https://app.tettra.co/teams/ersknowledge/pages/copying-a-folder-path-from-sharepoint-to-use-in-r

- file_name_with_extension:

  REQUIRED: Supported extensions: .csv, .xlsx, .png(ggsave). Example:
  "student_performance.csv"

- drive_name:

  OPTIONAL: R will detect what drive the file is from (e.g.
  'client_work_drive', or 'internal_drive')

## Value

A message that your file was successfully uploaded.
