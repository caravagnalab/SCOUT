# Get tumourevo QC result paths

Get tumourevo QC result paths

## Usage

``` r
get_tumourevo_qc(
  spn,
  coverage,
  purity,
  vcf_caller,
  cna_caller,
  tool,
  sample = NULL
)
```

## Arguments

- spn:

  SPN identifier.

- coverage:

  Sequencing coverage (integer).

- purity:

  Sample purity: `0.9`, `0.6`, or `0.3`.

- vcf_caller:

  VCF caller: `"mutect2"` or `"strelka"`.

- cna_caller:

  CNA caller: `"ascat"` or `"sequenza"`.

- tool:

  QC tool: `"cnaqc"`, `"join_cnaqc"`, or `"tinc"`.

- sample:

  Sample name. Required for `"cnaqc"` and `"tinc"`.

## Value

Named list of file paths.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "cnaqc", "SPN04_1.1")
get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "join_cnaqc")
} # }
```
