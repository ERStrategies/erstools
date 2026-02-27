# Use the skim function to validate your data and output a summary of your columns

This function applies
[`skimr::skim()`](https://docs.ropensci.org/skimr/reference/skim.html)
to summarize a dataset and then formats numeric columns. Numeric values
are rounded to one decimal place. If a number is 1,000 or greater, it is
formatted with commas.

## Usage

``` r
ers_column_info(dataset)
```

## Arguments

- dataset:

  A data frame or tibble to be summarized.

## Value

A tibble with summary statistics, where numeric values are rounded to
one decimal place and large numbers (≥ 1,000) are formatted with commas.
