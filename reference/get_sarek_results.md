# Get the local path to Sarek results for a SCOUT SPN

Downloads and extracts the Sarek archive for a given SPN and purity (if
not already cached) and returns the path to the extracted directory.

## Usage

``` r
get_sarek_results(
  spn,
  purity,
  record_id = .scout_record_id(spn, purity, type = "sarek"),
  cache_dir = .scout_cache_dir(spn, purity)
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- purity:

  Sample purity: `0.9`, `0.6`, or `0.3`.

- record_id:

  Zenodo record ID. Defaults to the registered record for this SPN and
  purity.

- cache_dir:

  Local directory to cache downloaded files.

## Value

Invisible path to the directory containing the Sarek results.

## Examples

``` r
if (FALSE) { # \dontrun{
path <- get_sarek_results("SPN01", purity = 0.9)
} # }
```
