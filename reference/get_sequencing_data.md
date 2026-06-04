# Download SCOUT sequencing ground truth for a SPN

Downloads and extracts `SPN0X_sequencing.tar.gz` from the SPN's
sequencing Zenodo record (if not already cached). The archive contains
tumour mutation RDS files for all purity and coverage combinations.

## Usage

``` r
get_sequencing_data(
  spn,
  record_id = .scout_sequencing_record_id(),
  cache_dir = .scout_cache_dir(spn)
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- record_id:

  Zenodo record ID. Defaults to the registered sequencing record for
  this SPN.

- cache_dir:

  Local directory to cache downloaded files.

## Value

Invisible path to the extracted directory.

## Examples

``` r
if (FALSE) { # \dontrun{
get_sequencing_data("SPN04")
} # }
```
