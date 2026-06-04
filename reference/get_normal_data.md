# Download SCOUT normal sarek results for a SPN

Downloads and extracts `SPN0X_normal_sequencing.tar.gz` from the SPN's
sequencing Zenodo record (if not already cached). The archive contains
haplotypecaller and freebayes VCF files for the normal sample.

## Usage

``` r
get_normal_data(
  spn,
  record_id = .scout_sequencing_record_id(),
  cache_dir = .scout_cache_dir(spn)
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN04"`.

- record_id:

  Zenodo record ID. Defaults to the sequencing record for this SPN.

- cache_dir:

  Local directory to cache downloaded files.

## Value

Invisible path to the extracted directory.

## Examples

``` r
if (FALSE) { # \dontrun{
get_normal_data("SPN04")
} # }
```
