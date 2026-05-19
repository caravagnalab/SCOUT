# Get SCOUT ground truth mutational signature exposures

Returns a tibble of ground truth signature exposures from the SCOUT
metadata Google Sheet, with columns `SPN`, `Sample`, `Coverage`,
`Purity`, `Type`, `Signature`, and `Exposure`. Optionally filtered by
SPN, sample, and/or signature type.

## Usage

``` r
get_ground_truth_exposures(spn = NULL, sample = NULL, type = NULL)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.

- sample:

  Sample identifier. If `NULL`, returns all samples.

- type:

  Signature type, e.g. `"SBS"` or `"ID"`. If `NULL`, returns all types.

## Value

A tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
get_ground_truth_exposures()
get_ground_truth_exposures("SPN01")
get_ground_truth_exposures("SPN01", type = "SBS")
} # }
```
