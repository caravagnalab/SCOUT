# Get tumourevo signature deconvolution result paths

Get tumourevo signature deconvolution result paths

## Usage

``` r
get_tumourevo_signatures(
  spn,
  coverage,
  purity,
  vcf_caller,
  cna_caller,
  tool,
  context = NULL
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

  Tool: `"sigprofiler"`, `"sparsesignatures"`, or `"BASCULE"`.

- context:

  Mutational context, e.g. `"SBS96"`, `"ID83"`, `"DBS78"`. Required for
  `tool = "sigprofiler"`.

## Value

Named list of file paths.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza", "BASCULE")
get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza",
                          "sigprofiler", context = "SBS96")
} # }
```
