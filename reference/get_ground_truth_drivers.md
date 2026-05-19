# Get SCOUT ground truth driver events

Returns a tibble of ground truth driver events from the SCOUT metadata
Google Sheet, with columns `SPN`, `mutant`, `type`, `CNA_type`, `chr`,
`start`, `end`, `ref`, `alt`, `code`, `allele`, `src_allele`. Optionally
filtered to a specific SPN.

## Usage

``` r
get_ground_truth_drivers(spn = NULL)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.

## Value

A tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
get_ground_truth_drivers()
get_ground_truth_drivers("SPN01")
} # }
```
