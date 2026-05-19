# Get tumourevo driver annotation paths

Get tumourevo driver annotation paths

## Usage

``` r
get_tumourevo_driver(spn, coverage, purity, vcf_caller, cna_caller, sample)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- coverage:

  Sequencing coverage (integer).

- purity:

  Sample purity (0–1).

- vcf_caller:

  VCF caller: `"mutect2"` or `"strelka"`.

- cna_caller:

  CNA caller: `"ascat"` or `"sequenza"`.

- sample:

  Sample name.

## Value

Character vector of paths to driver RDS files.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_driver("SPN01", 100, 0.9, "mutect2", "ascat", "SPN01_1")
} # }
```
