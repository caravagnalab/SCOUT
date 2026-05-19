# Get the local path to tumourevo results for a SCOUT SPN

Downloads and unzips the tumourevo archive from the SPN's Zenodo record
(if not already cached) and returns the path to the extracted directory.

## Usage

``` r
get_tumourevo_results(
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

Invisible path to the directory containing the tumourevo results.

## Examples

``` r
if (FALSE) { # \dontrun{
path <- get_tumourevo_results("SPN01", record_id = "1234567")
list.files(path)
} # }
```
