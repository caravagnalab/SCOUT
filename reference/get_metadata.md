# Get SCOUT sample metadata

Returns a tibble with one row per sample, containing identifiers and
high-level annotations (tumour type, clonal composition, FGA/FGS, clonal
class, hypermutant status, WGD, and signature context).

## Usage

``` r
get_metadata()
```

## Value

A tibble with columns: `SPN`, `Sample`, `FGA`, `FGS`, `Clonal Class`,
`Clonal Subclass`, `Tumour type`, `Sample type`, `Hypermutant Sample`,
`Hypermutant SPN`, `WGD`, `Signature Context`, `Signature Class`.

## Examples

``` r
if (FALSE) { # \dontrun{
get_metadata()
} # }
```
