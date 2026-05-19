# List files available in a Zenodo record

List files available in a Zenodo record

## Usage

``` r
list_zenodo_files(record_id)
```

## Arguments

- record_id:

  Zenodo record ID (integer or string).

## Value

A tibble with columns `filename`, `size`, `download_url`.
