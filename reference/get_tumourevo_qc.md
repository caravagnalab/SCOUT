# Get tumourevo QC result paths

Get tumourevo QC result paths

## Usage

``` r
get_tumourevo_qc(spn, coverage, purity, vcf_caller, cna_caller, tool, sample)
```

## Arguments

- spn:

  SPN identifier.

- coverage:

  Sequencing coverage (integer).

- purity:

  Sample purity (0–1).

- vcf_caller:

  VCF caller: `"mutect2"` or `"strelka"`.

- cna_caller:

  CNA caller: `"ascat"` or `"sequenza"`.

- tool:

  QC tool: `"cnaqc"`, `"join_cnaqc"`, or `"tinc"`.

- sample:

  Sample name.

## Value

Named list of file paths.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_qc("SPN01", 100, 0.9, "mutect2", "ascat", "cnaqc", "SPN01_1")
} # }
```
