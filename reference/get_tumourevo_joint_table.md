# Get tumourevo joint CNAqc table (cnaqc2tsv)

Get tumourevo joint CNAqc table (cnaqc2tsv)

## Usage

``` r
get_tumourevo_joint_table(spn, coverage, purity, vcf_caller, cna_caller)
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

## Value

Path to the joint table TSV file.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_joint_table("SPN04", 50, 0.6, "mutect2", "sequenza")
} # }
```
