# Get Sarek VCF output files for a SCOUT SPN

Returns a named list of VCF (and index) file paths from the Sarek
variant calling results for a given sample, coverage, purity and caller.

## Usage

``` r
get_sarek_vcf(
  spn,
  sample_id,
  coverage,
  purity,
  caller,
  type,
  normal_id = "normal_sample"
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- sample_id:

  Sample identifier.

- coverage:

  Sequencing coverage (integer, e.g. `100`).

- purity:

  Sample purity (0–1, e.g. `0.9`).

- caller:

  VCF caller: `"mutect2"`, `"strelka"`, `"freebayes"`, or
  `"haplotypecaller"`.

- type:

  Sample type: `"tumour"` or `"normal"`.

- normal_id:

  Normal sample ID. Defaults to `"normal_sample"`.

## Value

Named list of file paths (keys depend on caller, e.g. `vcf`, `tbi`,
`snvs_vcf`, etc.).

## Examples

``` r
if (FALSE) { # \dontrun{
get_sarek_vcf("SPN01", "SPN01_1", 100, 0.9, "mutect2", "tumour")
} # }
```
