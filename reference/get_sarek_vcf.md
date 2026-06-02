# Get Sarek VCF output files for a SCOUT SPN

Returns a named list of VCF (and index) file paths from the Sarek
variant calling results for a given sample, coverage, purity and caller.
Supported callers: `"mutect2"`, `"strelka"`, `"freebayes"`,
`"haplotypecaller"`.

## Usage

``` r
get_sarek_vcf(
  spn,
  sample,
  coverage,
  purity,
  caller,
  normal_id = "normal_sample"
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN04"`.

- sample:

  Sample identifier, e.g. `"SPN04_1.1"`. Not required for `"mutect2"`
  (SPN-level) or normal-only callers.

- coverage:

  Sequencing coverage (integer, e.g. `100`).

- purity:

  Sample purity: `0.9`, `0.6`, or `0.3`.

- caller:

  VCF caller: `"mutect2"`, `"strelka"`, `"freebayes"`, or
  `"haplotypecaller"`.

- normal_id:

  Normal sample ID. Defaults to `"normal_sample"`.

## Value

Named list of file paths.

## Examples

``` r
if (FALSE) { # \dontrun{
get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.3, "mutect2")
get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.3, "strelka")
get_sarek_vcf("SPN04", NULL, 100, 0.3, "haplotypecaller")
} # }
```
