# Get mutations from SCOUT ground truth

Returns the path to the sequencing mutations RDS file for a given SPN,
sample type, coverage and purity.

## Usage

``` r
get_mutations(spn, type, coverage = NA, purity = NA)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- type:

  Sample type: `"tumour"` or `"normal"`.

- coverage:

  Sequencing coverage (integer, e.g. `100`). Required for
  `type = "tumour"`.

- purity:

  Sample purity between 0 and 1 (e.g. `0.9`). Required for
  `type = "tumour"`.

## Value

Path to the mutations RDS file.

## Examples

``` r
if (FALSE) { # \dontrun{
path <- get_mutations("SPN01", type = "tumour", coverage = 100, purity = 0.9)
readRDS(path)
} # }
```
