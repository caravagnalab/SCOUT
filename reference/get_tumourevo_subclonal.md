# Get tumourevo subclonal deconvolution result paths

Get tumourevo subclonal deconvolution result paths

## Usage

``` r
get_tumourevo_subclonal(
  spn,
  coverage,
  purity,
  vcf_caller,
  cna_caller,
  tool,
  sample
)
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

  Deconvolution tool: `"mobster"`, `"pyclonevi"`, `"ctree"`, or
  `"viber"`.

- sample:

  Sample name.

## Value

Named list of file paths.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_subclonal("SPN01", 100, 0.9, "mutect2", "ascat", "mobster", "SPN01_1")
} # }
```
