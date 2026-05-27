# Zenodo

SCOUT data are distributed across several Zenodo records organised by
data type and SPN. Files are downloaded once and cached locally — repeat
calls detect the cache and skip the download automatically.

## Cache location

By default files are stored at `~/.cache/SCOUT/<spn>/`. Override with:

``` r

Sys.setenv(SCOUT_CACHE_DIR = "/scratch/shared/SCOUT")
```

------------------------------------------------------------------------

## Zenodo record structure

| Record | Content | Archive per SPN |
|----|----|----|
| One per SPN | Tumour sequencing ground truth (RDS) | `SPN0X_sequencing.tar.gz` |
| One shared | Normal sarek outputs | `SPN0X_normal.tar.gz` |
| One per SPN per purity (SPN01–06) | Sarek + tumourevo results | `sarek.tar.gz`, `tumourevo.tar.gz` |
| SPN07 sarek: one per purity | Sarek results | `sarek.tar.gz` |
| SPN07 tumourevo: one for 0.9+0.6, one for 0.3 | tumourevo results | `tumourevo.tar.gz` |

------------------------------------------------------------------------

## Downloading data

### `get_sequencing_data()`

Downloads `SPN0X_sequencing.tar.gz` from the SPN’s sequencing record.
Contains tumour mutation RDS files for all purity and coverage
combinations.

``` r

get_sequencing_data("SPN04")
```

### `get_normal_data()`

Downloads `SPN0X_normal.tar.gz` from the shared normal record. Contains
haplotypecaller and freebayes VCF files for the normal sample.

``` r

get_normal_data("SPN04")
```

### `get_sarek_results()`

Downloads `sarek.tar.gz` for a given SPN and purity.

``` r

get_sarek_results("SPN01", purity = 0.9)
get_sarek_results("SPN01", purity = 0.6)
get_sarek_results("SPN01", purity = 0.3)
```

### `get_tumourevo_results()`

Downloads `tumourevo.tar.gz` for a given SPN and purity.

``` r

get_tumourevo_results("SPN01", purity = 0.9)
```

### `list_zenodo_files()`

Inspect what is available in a record before downloading.

``` r

list_zenodo_files("1234567")
#> # A tibble: 2 × 3
#>   filename                size download_url
#>   <chr>                  <int> <chr>
#> 1 sarek.tar.gz             ...  https://zenodo.org/...
#> 2 tumourevo.tar.gz         ...  https://zenodo.org/...
```

------------------------------------------------------------------------

## Ground truth getters

After
[`get_sequencing_data()`](https://caravagnalab.github.io/SCOUT/reference/get_sequencing_data.md)
or
[`get_normal_data()`](https://caravagnalab.github.io/SCOUT/reference/get_normal_data.md),
use these functions to access specific files without navigating the
directory structure.

### `get_mutations()`

Returns the path to the mutations RDS file for a given type, coverage
and purity.

``` r

# Tumour (requires coverage and purity)
path <- get_mutations("SPN04", type = "tumour", coverage = 100, purity = 0.9)
readRDS(path)

# Normal (fixed at 30x, purity 1)
path <- get_mutations("SPN04", type = "normal")
```

------------------------------------------------------------------------

## Sarek getters

After
[`get_sarek_results()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_results.md)
or
[`get_normal_data()`](https://caravagnalab.github.io/SCOUT/reference/get_normal_data.md),
these functions return named lists of file paths for a given sample,
coverage, purity and caller.

### `get_sarek_vcf()`

Returns VCF and index file paths for tumour or normal variant calling.
Supported callers: `"mutect2"`, `"strelka"`, `"freebayes"`,
`"haplotypecaller"`.

``` r

# mutect2 — tumour
vcf <- get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.9, "mutect2", "tumour")
vcf$vcf
vcf$tbi

# strelka — returns separate SNV and indel keys
vcf <- get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.9, "strelka", "tumour")
vcf$snvs_vcf
vcf$indels_vcf

# haplotypecaller — normal sample
vcf <- get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.9, "haplotypecaller", "normal")
vcf$vcf
```

### `get_sarek_cna()`

Returns CNA file paths. Supported callers: `"ascat"`, `"sequenza"`,
`"cnvkit"`.

``` r

# ASCAT
cna <- get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.9, "ascat")
cna$segments
cna$purityploidy
cna$cnvs

# Sequenza
cna <- get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.9, "sequenza")
cna$segments
cna$confints_CP
```

------------------------------------------------------------------------

## tumourevo getters

After
[`get_tumourevo_results()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_results.md),
these functions return named lists of file paths. All require `spn`,
`coverage`, `purity`, `vcf_caller` (`"mutect2"` or `"strelka"`), and
`cna_caller` (`"ascat"` or `"sequenza"`). Sample naming convention:
`"SPN04_1.1"`.

### Formatter

``` r

# Formatted SNV RDS (vcf2cnaqc)
get_tumourevo_snv("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")

# Formatted CNA RDS (cna2cnaqc)
get_tumourevo_cna("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")

# Joint CNAqc table (cnaqc2tsv) — one file per combination
get_tumourevo_joint_table("SPN04", 50, 0.6, "mutect2", "sequenza")
```

### Variant annotation

``` r

# VEP annotated VCF
get_tumourevo_vep("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
```

### Driver annotation

``` r

# One sample
get_tumourevo_driver("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")

# All samples (sample = NULL)
get_tumourevo_driver("SPN04", 50, 0.6, "mutect2", "sequenza")
```

### Subclonal deconvolution

Supported tools: `"mobster"`, `"pyclonevi"`, `"ctree"`, `"viber"`.

``` r

# mobster — sample required
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza",
                         "mobster", "SPN04_1.1")

# viber — SPN-level result, no sample needed
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza", "viber")

# ctree — SPN-level trees (sample = NULL) or per-sample
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza", "ctree")
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza",
                         "ctree", "SPN04_1.1")
```

### QC

Supported tools: `"cnaqc"`, `"join_cnaqc"`, `"tinc"`.

``` r

# cnaqc / tinc — sample required
get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "cnaqc", "SPN04_1.1")
get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "tinc",  "SPN04_1.1")

# join_cnaqc — SPN-level, no sample needed
get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "join_cnaqc")
```

### Signature deconvolution

Supported tools: `"sigprofiler"`, `"sparsesignatures"`, `"BASCULE"`.
`sigprofiler` requires a `context` argument (e.g. `"SBS96"`, `"ID83"`,
`"DBS78"`).

``` r

# BASCULE
sigs <- get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza",
                                  "BASCULE")
sigs$refined_fit
sigs$base_fit

# SigProfiler
sigs <- get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza",
                                  "sigprofiler", context = "SBS96")
sigs$context_matrix
sigs$COSMIC_exposure
sigs$denovo_signatures
```
