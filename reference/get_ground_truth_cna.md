# Get SCOUT ground truth CNA data

Returns a tibble of ground truth copy number segments from the SCOUT
metadata Google Sheet, with columns `SPN`, `Sample`, `Chromosome`,
`Start`, `End`, `Major`, `minor`, and `CCF`. Optionally filtered to a
specific SPN and/or sample.

## Usage

``` r
get_ground_truth_cna(spn = NULL, sample = NULL)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.

- sample:

  Sample identifier. If `NULL`, returns all samples for the selected
  SPN.

## Value

A tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
get_ground_truth_cna()
get_ground_truth_cna("SPN01")
get_ground_truth_cna("SPN01", sample = "1.1")
} # }
```
