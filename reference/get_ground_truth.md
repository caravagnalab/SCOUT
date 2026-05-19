# Get ground truth simulation data for a SCOUT SPN

Downloads and unzips the ground truth archive from the SPN's Zenodo
record (if not already cached), then reads all RDS files into a named
list.

## Usage

``` r
get_ground_truth(
  spn,
  record_id = .scout_record_id(spn),
  cache_dir = .scout_cache_dir(spn)
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- record_id:

  Zenodo record ID for this SPN.

- cache_dir:

  Local directory to cache downloaded files. Defaults to
  `~/.cache/SCOUT/<spn>/`.

## Value

A named list of R objects, one per RDS file in the archive.

## Examples

``` r
if (FALSE) { # \dontrun{
gt <- get_ground_truth("SPN01", record_id = "1234567")
} # }
```
