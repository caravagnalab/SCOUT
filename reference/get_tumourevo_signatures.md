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

  Sample purity (0–1).

- vcf_caller:

  VCF caller: `"mutect2"` or `"strelka"`.

- cna_caller:

  CNA caller: `"ascat"` or `"sequenza"`.

- tool:

  Signature tool: `"sigprofiler"`, `"sparsesignatures"`, or `"BASCULE"`.

- context:

  Mutational context, e.g. `"SBS96"` or `"ID83"`. Required for
  `tool = "sigprofiler"`.

## Value

Named list of file paths.

## Examples

``` r
if (FALSE) { # \dontrun{
get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat", "BASCULE")
get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat", "sigprofiler", "SBS96")
} # }
```
