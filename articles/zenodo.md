# Zenodo

Each SPN has a dedicated Zenodo record with three zip archives. Files
are downloaded once and cached locally — repeat calls skip the download.

## Cache location

By default data are stored at `~/.cache/SCOUT/<spn>/`. Override with:

``` r

Sys.setenv(SCOUT_CACHE_DIR = "/scratch/shared/SCOUT")
```

------------------------------------------------------------------------

## Downloading archives

### `get_ground_truth()`

Downloads `ground_truth.zip`, reads every RDS file inside, and returns a
**named list** — one element per file.

``` r

gt <- get_ground_truth("SPN01")

names(gt)
gt$clones
```

### `get_sarek_results()`

Downloads `sarek.zip` and returns the **path** to the extracted
directory.

``` r

sarek_dir <- get_sarek_results("SPN01")
list.files(sarek_dir, recursive = TRUE)
```

### `get_tumourevo_results()`

Downloads `tumourevo.zip` and returns the **path** to the extracted
directory.

``` r

te_dir <- get_tumourevo_results("SPN01")
list.files(te_dir, recursive = TRUE)
```

### `list_zenodo_files()`

Inspect what is available in a record before downloading anything.

``` r

list_zenodo_files("1234567")
#> # A tibble: 3 × 3
#>   filename           size download_url
#>   <chr>             <int> <chr>
#> 1 ground_truth.zip    ...  https://zenodo.org/...
#> 2 sarek.zip           ...  https://zenodo.org/...
#> 3 tumourevo.zip       ...  https://zenodo.org/...
```

------------------------------------------------------------------------

## Ground truth getters

Once
[`get_ground_truth()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth.md)
has been called, these functions let you access specific files without
navigating the directory structure manually.

### `get_mutations()`

Returns the path to the mutations RDS file for a given sample type,
coverage and purity.

``` r

# Tumour sample
path <- get_mutations("SPN01", type = "tumour", coverage = 100, purity = 0.9)
readRDS(path)

# Matched normal (fixed at 30x, purity 1)
path <- get_mutations("SPN01", type = "normal")
```

------------------------------------------------------------------------

## Sarek getters

Once
[`get_sarek_results()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_results.md)
has been called, these functions return named lists of file paths for a
given sample, coverage, purity and caller.

### `get_sarek_vcf()`

Returns VCF and index file paths. Supported callers: `"mutect2"`,
`"strelka"`, `"freebayes"`, `"haplotypecaller"`.

``` r

vcf <- get_sarek_vcf("SPN01", "SPN01_1", 100, 0.9, "mutect2", "tumour")
vcf$vcf
vcf$tbi

# strelka returns separate SNV and indel files
vcf <- get_sarek_vcf("SPN01", "SPN01_1", 100, 0.9, "strelka", "tumour")
vcf$snvs_vcf
vcf$indels_vcf
```

### `get_sarek_cna()`

Returns CNA file paths. Supported callers: `"ascat"`, `"sequenza"`,
`"cnvkit"`.

``` r

# ASCAT
cna <- get_sarek_cna("SPN01", "SPN01_1", 100, 0.9, "ascat")
cna$segments
cna$purityploidy

# Sequenza
cna <- get_sarek_cna("SPN01", "SPN01_1", 100, 0.9, "sequenza")
cna$segments
cna$confints_CP
```

------------------------------------------------------------------------

## tumourevo getters

Once
[`get_tumourevo_results()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_results.md)
has been called, these functions return named lists of file paths. All
require `spn`, `coverage`, `purity`, `vcf_caller` (`"mutect2"` or
`"strelka"`), and `cna_caller` (`"ascat"` or `"sequenza"`).

### `get_tumourevo_driver()`

Driver annotation results for a specific sample.

``` r

get_tumourevo_driver("SPN01", 100, 0.9, "mutect2", "ascat", sample = "SPN01_1")
```

### `get_tumourevo_subclonal()`

Subclonal deconvolution results. Supported tools: `"mobster"`,
`"pyclonevi"`, `"ctree"`, `"viber"`.

``` r

get_tumourevo_subclonal("SPN01", 100, 0.9, "mutect2", "ascat", "mobster", "SPN01_1")
get_tumourevo_subclonal("SPN01", 100, 0.9, "mutect2", "ascat", "pyclonevi", "SPN01_1")
```

### `get_tumourevo_qc()`

QC results. Supported tools: `"cnaqc"`, `"join_cnaqc"`, `"tinc"`.

``` r

get_tumourevo_qc("SPN01", 100, 0.9, "mutect2", "ascat", "cnaqc", "SPN01_1")
```

### `get_tumourevo_signatures()`

Signature deconvolution results. Supported tools: `"sigprofiler"`,
`"sparsesignatures"`, `"BASCULE"`. `sigprofiler` also requires a
`context` argument (e.g. `"SBS96"`, `"ID83"`).

``` r

# BASCULE
sigs <- get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat", "BASCULE")
sigs$refined_fit
sigs$base_fit

# SigProfiler
sigs <- get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat",
                                  "sigprofiler", context = "SBS96")
sigs$COSMIC_exposure
sigs$denovo_signatures
```
