# Get subject gender for a SCOUT SPN

Looks up gender from the SCOUT metadata Google Sheet. Requires a
`Gender` column to be present in the sheet.

## Usage

``` r
get_gender(spn)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

## Value

A character string, e.g. `"XY"` or `"XX"`.

## Examples

``` r
if (FALSE) { # \dontrun{
get_gender("SPN01")
} # }
```
