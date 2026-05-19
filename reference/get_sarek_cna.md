# Get Sarek CNA output files for a SCOUT SPN

Returns a named list of CNA file paths from the Sarek copy-number
calling results for a given sample, coverage, purity and caller.

## Usage

``` r
get_sarek_cna(
  spn,
  sample_id,
  coverage,
  purity,
  caller,
  normal_id = "normal_sample"
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- sample_id:

  Sample identifier.

- coverage:

  Sequencing coverage (integer).

- purity:

  Sample purity (0–1).

- caller:

  CNA caller: `"ascat"`, `"sequenza"`, or `"cnvkit"`.

- normal_id:

  Normal sample ID. Defaults to `"normal_sample"`.

## Value

Named list of file paths (keys depend on caller, e.g. `segments`,
`purityploidy`, `cnvs`, etc.).

## Examples

``` r
if (FALSE) { # \dontrun{
get_sarek_cna("SPN01", "SPN01_1", 100, 0.9, "ascat")
} # }
```
