# Read a public Google Sheet and return a tibble

Read a public Google Sheet and return a tibble

## Usage

``` r
read_sheet(sheet_id, gid = NULL)
```

## Arguments

- sheet_id:

  The Google Sheets document ID (the long string in the URL).

- gid:

  Optional sheet tab ID (integer). Defaults to the first sheet.

## Value

A tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
read_sheet("1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms")
} # }
```
