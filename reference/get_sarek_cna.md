# Get Sarek CNA output files for a SCOUT SPN

Returns a named list of CNA file paths from the Sarek copy-number
calling results. Supported callers: `"ascat"`, `"battenberg"`,
`"sequenza"`, `"cnvkit"`.

## Usage

``` r
get_sarek_cna(
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

  Sample identifier, e.g. `"SPN04_1.1"`.

- coverage:

  Sequencing coverage (integer).

- purity:

  Sample purity: `0.9`, `0.6`, or `0.3`.

- caller:

  CNA caller: `"ascat"`, `"battenberg"`, `"sequenza"`, or `"cnvkit"`.

- normal_id:

  Normal sample ID. Defaults to `"normal_sample"`.

## Value

Named list of file paths (keys depend on caller).

## Examples

``` r
if (FALSE) { # \dontrun{
get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.3, "ascat")
get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.3, "battenberg")
get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.3, "sequenza")
} # }
```
