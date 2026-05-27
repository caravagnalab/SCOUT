# Get tumourevo formatted CNA (cna2cnaqc) file paths

Get tumourevo formatted CNA (cna2cnaqc) file paths

## Usage

``` r
get_tumourevo_cna(spn, coverage, purity, vcf_caller, cna_caller, sample = NULL)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- coverage:

  Sequencing coverage (integer).

- purity:

  Sample purity: `0.9`, `0.6`, or `0.3`.

- vcf_caller:

  VCF caller: `"mutect2"` or `"strelka"`.

- cna_caller:

  CNA caller: `"ascat"` or `"sequenza"`.

- sample:

  Sample name. If `NULL`, returns paths for all samples.

## Value

Named list of file paths to CNA RDS files.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_cna("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
} # }
```
