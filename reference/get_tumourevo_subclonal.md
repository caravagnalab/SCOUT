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

  Tool: `"mobster"`, `"pyclonevi"`, `"ctree"`, or `"viber"`.

- sample:

  Sample name. Required for `"mobster"` and per-sample `"ctree"`
  results.

## Value

Named list of file paths.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza",
                         "mobster", "SPN04_1.1")
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza", "viber")
} # }
```
