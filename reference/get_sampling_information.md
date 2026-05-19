# Get SCOUT sampling information

Returns a tibble with per-sample sampling details including number of
cells, sampling time, and clone proportions. Optionally filtered by SPN
and/or sample.

## Usage

``` r
get_sampling_information(spn = NULL, sample = NULL)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.

- sample:

  Sample identifier. If `NULL`, returns all samples.

## Value

A tibble with columns: `SPN`, `Sample`, `Number of cells`,
`Sampling time`, `Clone 1 proportion` … `Clone 7 proportion`.

## Examples

``` r
if (FALSE) { # \dontrun{
get_sampling_information()
get_sampling_information("SPN01")
get_sampling_information("SPN01", sample = "1.1")
} # }
```
