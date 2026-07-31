# Download raw FASTQ files for a SCOUT SPN from ENA

Downloads one or more FASTQ files from the ENA accession **PRJEB97253**
using the EBI FTP server. Files are cached locally and re-used on
subsequent calls.

## Usage

``` r
get_fastq(
  spn,
  sample = NULL,
  purity = NULL,
  read = "both",
  cache_dir = .ena_cache_dir(spn)
)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- sample:

  Sample identifier, e.g. `"1.1"`. Use `NULL` for normal files.

- purity:

  Tumour purity: `"0.9"`, `"0.6"`, or `"0.3"`. Required when `sample` is
  not `NULL`.

- read:

  Read direction: `"R1"`, `"R2"`, or `"both"` (default).

- cache_dir:

  Local directory to store downloaded files. Defaults to
  `~/.cache/SCOUT/<spn>/fastq/`.

## Value

Invisible named character vector of local file paths (names are `"R1"`
and/or `"R2"`).

## Examples

``` r
if (FALSE) { # \dontrun{
# Download R1 and R2 for SPN01 sample 1.1 purity 0.9
paths <- get_fastq("SPN01", sample = "1.1", purity = "0.9")
paths$R1
paths$R2

# Download normal files
get_fastq("SPN01", sample = NULL)
} # }
```
