# Get the local path to tumourevo results for a SCOUT SPN

Downloads and extracts the tumourevo archive for a given SPN and purity
(if not already cached) and returns the path to the extracted directory.

## Usage

``` r
get_tumourevo_results(
  spn,
  purity,
  record_id = .scout_record_id(spn, purity, type = "tumourevo"),
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

Invisible path to the directory containing the tumourevo results.

## Examples

``` r
if (FALSE) { # \dontrun{
path <- get_tumourevo_results("SPN01", purity = 0.9)
} # }
```
